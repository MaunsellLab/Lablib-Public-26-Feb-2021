//
//  LLNIDAQTask.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//  The NIDAQ supports only one each of AO, AI, DO, and DI tasks (each) simultaneously:
//  https://knowledge.ni.com/KnowledgeArticleDetails?id=kA00Z0000019KWYSA2

#import <Lablib/LLNIDAQTask.h>

static long nextTaskID = 0;         // class variable to persist across all instances

@implementation LLNIDAQTask

- (BOOL)alterState:(NSString *)newState;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"alterState", @"command", taskName, @"taskName",
            newState, @"state", nil];
    return [self sendDictionary:dict];
}

- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTimingSampleClock", @"command",
            taskName, @"taskName", @(outputRateHz), @"outputRateHz", mode, @"mode",
            @(count), @"samplesPerChannel", nil];
    return [self sendDictionary:dict];
}

- (BOOL)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTriggerDigitalEdgeStart", @"command",
            taskName, @"taskName", triggerChannelName, @"channelName", edge, @"edge", nil];
    return [self sendDictionary:dict];
}

- (BOOL)configureTriggerDisableStart;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTriggerDisableStart", @"command",
                taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)createAOTask;
{
    NSMutableDictionary *dict;

    if ((taskType != kNoType) && (taskType != kAnalogOutputType)) {
        NSLog(@"Attempt to change the type of a LLNIDAQTask, ignored");
        return NO;
    }
    taskType = kAnalogOutputType;
    [taskName release];
    taskName = [[NSString stringWithFormat:@"%@ AOTask %ld", [self.socket rigID].capitalizedString, taskID++] retain];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createAOTask", @"command",
            taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)createDOTask;
{
    NSMutableDictionary *dict;

    if ((taskType != kNoType) && (taskType != kDigitalOutputType)) {
        NSLog(@"Attempting to change the type of a LLNIDAQTask, ignored");
        return NO;
    }
    taskType = kDigitalOutputType;
    [taskName release];
    taskName = [[NSString stringWithFormat:@"%@ DOTask %ld", [self.socket rigID].capitalizedString, taskID++] retain];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createDOTask", @"command",
            taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)createChannelWithName:(NSString *)channelName;
{
    long channel;
    NSMutableDictionary *dict;

    NSLog(@"createChannelWithName: creating channel with name: %@", channelName);
    
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
            taskName, @"taskName", channelName, @"channelName", nil];
    for (channel = 0; channel < channelNames.count; channel++) {
        if ([channelName isEqualToString:channelNames[channel]]) {
            break;
        }
    }
    if (channel >= channelNames.count) {
        [channelNames addObject:channelName];
    }
    return [self sendDictionary:dict];
}

/*
 There is an extraordinary 1.5 s delay the first time a createVoltageChannelWithName is called after
 the PC python script is launched.  No telling where that is coming from.  It looks like it is buried
 deep within the NIDAQ library.  It's only the first call from any computer.  After that, all call seem
 to take a reasonable time.  In any case, to avoid that we extend the timeout for the LLSocket the first
 time we make this call from within any instance of LLNIDAQTask.
*/

- (BOOL)createVoltageChannelWithName:(NSString *)channelName maxVolts:(float)maxV minVolts:(float)minV;
{
    long channel;
    NSMutableDictionary *dict;
    double originalTimeoutS;
    BOOL result;
    static BOOL firstTime = YES;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createVoltageChannel", @"command",
            taskName, @"taskName", channelName, @"channelName",
            @(maxV), @"maximumV", @(minV), @"minimumV",
            nil];
    for (channel = 0; channel < channelNames.count; channel++) {
        if ([channelName isEqualToString:channelNames[channel]]) {
            break;
        }
    }
    if (channel >= channelNames.count) {
        [channelNames addObject:channelName];
        [channelMaxV addObject:@(maxV)];
        [channelMinV addObject:@(minV)];
    }
    else {
        channelMaxV[channel] = @(maxV);
        channelMinV[channel] = @(minV);
    }
    if (firstTime) {
        originalTimeoutS = [self.socket timeoutS];
        [self.socket setTimeoutS:2.5];
    }
    result = [self sendDictionary:dict];
    if (firstTime) {
        [self.socket setTimeoutS:originalTimeoutS];
        firstTime = NO;
    }
    return result;
}

- (void)dealloc;
{
    if (taskName != nil) {
        [self stop];
        [self alterState:@"unreserve"];
        [self deleteTask];
    }
    [channelNames release];
    [channelMaxV release];
    [channelMinV release];
    self.socket = nil;
    [super dealloc];
}

- (BOOL)deleteTask;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"deleteTask", @"command",
                taskName, @"taskName", nil];
    [taskName release];
    taskName = nil;
    return [self sendDictionary:dict];
}

// A train is always assumed to incorporate two analog out channels.  Digital trigger edge is assumed to be rising.

- (BOOL)doTrain:(Float64 *)train numSamples:(long)trainSamples outputRateHz:(float)outputRateHz
        digitalTrigger:(BOOL)digitalTrigger triggerChannelName:(NSString *)channelName autoStart:(BOOL)autoStart
        waitTimeS:(float)waitTimeS;
{
    long index;
    NSMutableDictionary *dict;
    NSMutableArray *array;
    NSArray *sendArray;

    array = [[NSMutableArray alloc] init];
    for (index = 0; index < trainSamples; index++) {
        [array addObject:[NSNumber numberWithFloat:train[index]]];
    }
    sendArray = [NSArray arrayWithArray:array];
    [array release];

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"doTrain", @"command", taskName, @"taskName",
            sendArray, @"outArray",
            [NSNumber numberWithDouble:outputRateHz], @"outputRateHz",
            @(autoStart), @"autoStart",
            @(digitalTrigger), @"digitalTrigger",
            channelName, @"channelName",
            @(waitTimeS), @"waitTimeS",
            nil];
    return [self sendDictionary:dict];
}

- (instancetype)initWithSocket:(LLSockets *)theSocket;
{
    if ((self = [super init]) != nil) {
        _socket = theSocket;
        [_socket retain];
        channelNames = [[NSMutableArray alloc] init];
        channelMaxV = [[NSMutableArray alloc] init];
        channelMinV = [[NSMutableArray alloc] init];
        taskType = kNoType;
        taskID = nextTaskID++;
    }
    return self;
}

- (BOOL)isDone;
{
    NSMutableDictionary *dict, *returnDict;

    if (self.socket == nil) {                                       // allow debugging when no socket is active
        return YES;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"isDone", @"command", taskName, @"taskName", nil];
    returnDict = [self.socket writeDictionary:dict];
    if (returnDict == nil) {
        return NO;
    }
    if ([returnDict[@"success"] boolValue]) {
        return ([returnDict[@"isDone"] boolValue]);
    }
    return NO;
}

- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
{
    long channel;
    NSString *message;
    NSMutableDictionary *returnDict;
    static long retries = 0;

    returnDict = [self.socket writeDictionary:dict];
    if (returnDict == nil) {
        return NO;
    }
    if ([returnDict[@"success"] boolValue]) {
        return YES;
    }
    // We've gotten an error.  Check whether our AO/AI-Task has been lost.
    if (retries == 0) {                         // task recreation is recursive, so we want to prevent endless loops
        retries++;
        message = returnDict[@"errorMessage"];
        if ([message hasPrefix:[NSString stringWithFormat:@"no task named \"%@\"", taskName]]) {
            switch (taskType) {
                case (kAnalogOutputType):
                    [self createAOTask];            // try to recreate a new task
                    for (channel = 0; channel < channelNames.count; channel++) {
                        [self createVoltageChannelWithName:channelNames[channel]
                                                  maxVolts:[channelMaxV[channel] floatValue]
                                                  minVolts:[channelMinV[channel] floatValue]];
                    }
                    break;
                case (kDigitalOutputType):
                    [self createDOTask];            // try to recreate a new task
                    for (channel = 0; channel < channelNames.count; channel++) {
                        [self createChannelWithName:channelNames[channel]];
                    }
                    break;
                case (kAnalogInputType):
                case (kDigitalInputType):
                default:
                    break;
            }
        }
        retries--;
    }
    return NO;                                  // regardless of recreating the task, the current command failed
}

- (BOOL)setMaxVolts:(float)maxV minVolts:(float)minV forChannelName:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"setChannelMaxMin", @"command", taskName, @"taskName",
            channelName, @"channelName", @(maxV), @"maxVolts",
            @(minV), @"minVolts",
            nil];
    return [self sendDictionary:dict];
}

- (BOOL)start;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"startTask", @"command", taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)stop;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"stopTask", @"command", taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)waitUntilDone:(float)timeoutS;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"waitUntilDone", @"command", taskName, @"taskName",
                @(timeoutS), @"timeoutS", nil];
    return [self sendDictionary:dict];
}

- (BOOL)writeSamples:(Float64 *)outArray numSamples:(long)numSamples autoStart:(BOOL)autoStart
            timeoutS:(Float64)timeoutS;
{
    long index;
    NSMutableDictionary *dict;
    NSMutableArray *array;
    NSArray *sendArray;

    array = [[NSMutableArray alloc] init];
    for (index = 0; index < numSamples; index++) {
//            [array addObject:[NSString stringWithFormat:@"%f", outArray[index]]];
        [array addObject:[NSNumber numberWithFloat:outArray[index]]];
    }
    sendArray = [NSArray arrayWithArray:array];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"writeArray", @"command", taskName, @"taskName",
            @(autoStart), @"autoStart", sendArray, @"outArray",
            [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
    [array release];
    return [self sendDictionary:dict];;
}

@end
