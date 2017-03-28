//
//  LLNIDAQTask.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQTask.h"

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
            taskName, @"taskName", [NSNumber numberWithDouble:outputRateHz], @"outputRateHz", mode, @"mode",
            [NSNumber numberWithLong:count], @"samplesPerChannel", nil];
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

- (BOOL)createChannelWithName:(NSString *)channelName;
{
    long channel;
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
            taskName, @"taskName", channelName, @"channelName", nil];
    for (channel = 0; channel < [channelNames count]; channel++) {
        if ([channelName isEqualToString:[channelNames objectAtIndex:channel]]) {
            break;
        }
    }
    if (channel >= [channelNames count]) {
        [channelNames addObject:channelName];
    }
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
    taskName = [[NSString stringWithFormat:@"AOTask%ld", taskID++] retain];
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
    taskName = [[NSString stringWithFormat:@"DOTask%ld", taskID++] retain];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createDOTask", @"command",
            taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)createVoltageChannelWithName:(NSString *)channelName maxVolts:(float)maxV minVolts:(float)minV;
{
    long channel;
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createVoltageChannel", @"command",
                taskName, @"taskName", channelName, @"channelName",
                [NSNumber numberWithFloat:maxV], @"maximumV",[NSNumber numberWithFloat:minV], @"minimumV",
                nil];
    for (channel = 0; channel < [channelNames count]; channel++) {
        if ([channelName isEqualToString:[channelNames objectAtIndex:channel]]) {
            break;
        }
    }
    if (channel >= [channelNames count]) {
        [channelNames addObject:channelName];
        [channelMaxV addObject:[NSNumber numberWithFloat:maxV]];
        [channelMinV addObject:[NSNumber numberWithFloat:minV]];
    }
    else {
        [channelMaxV replaceObjectAtIndex:channel withObject:[NSNumber numberWithFloat:maxV]];
        [channelMinV replaceObjectAtIndex:channel withObject:[NSNumber numberWithFloat:minV]];
    }
    return [self sendDictionary:dict];
}

- (void)dealloc;
{
    [self stop];
    [self alterState:@"unreserve"];
    [self deleteTask];
    [channelNames release];
    [channelMaxV release];
    [channelMinV release];
    [socket release];
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

- (id)initWithSocket:(LLSockets *)theSocket;
{
    if ([super init] != nil) {
        socket = theSocket;
        [socket retain];
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

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"isDone", @"command", taskName, @"taskName", nil];
    returnDict = [socket writeDictionary:dict];
    if (returnDict == nil) {
        return NO;
    }
    if ([[returnDict objectForKey:@"success"] boolValue]) {
        return ([[returnDict objectForKey:@"isDone"] boolValue]);
    }
    return NO;
}


- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
{
    long channel;
    NSString *message;
    NSMutableDictionary *returnDict;
    static long retries = 0;

    returnDict = [socket writeDictionary:dict];
    if (returnDict == nil) {
        return NO;
    }
    if ([[returnDict objectForKey:@"success"] boolValue]) {
        return YES;
    }
    // We've gotten an error.  Check whether the AOTask has been lost.
    if (retries == 0) {                         // task recreation is recursive, so we want to prevent endless loops
        retries++;
        message = [returnDict objectForKey:@"errorMessage"];
        if ([message hasPrefix:[NSString stringWithFormat:@"no task named %@", taskName]]) {
            switch (taskType) {
                case (kAnalogOutputType):
                    [self createAOTask];            // try to recreate a new task
                    for (channel = 0; channel < [channelNames count]; channel++) {
                        [self createVoltageChannelWithName:[channelNames objectAtIndex:channel]
                                                  maxVolts:[[channelMaxV objectAtIndex:channel] floatValue]
                                                  minVolts:[[channelMinV objectAtIndex:channel] floatValue]];
                    }
                    break;
                case (kDigitalOutputType):
                    [self createDOTask];            // try to recreate a new task
                    for (channel = 0; channel < [channelNames count]; channel++) {
                        [self createChannelWithName:[channelNames objectAtIndex:channel]];
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
                [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
    return [self sendDictionary:dict];
}

- (BOOL)writeSamples:(Float64 *)outArray numSamples:(long)numSamples autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;
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
            [NSNumber numberWithBool:autoStart], @"autoStart", sendArray, @"outArray",
            [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
    [array release];
    return [self sendDictionary:dict];;
}

@end