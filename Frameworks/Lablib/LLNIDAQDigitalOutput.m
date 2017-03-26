//
//  LLNIDAQDigitalOutput.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQDigitalOutput.h"

static long nextTaskID = 0;         // class variable to persist across all instances

@implementation LLNIDAQDigitalOutput

- (BOOL)alterState:(NSString *)newState;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"alterState", @"command", taskName, @"taskName",
                newState, @"state", nil];
    return [self sendDictionary:dict];
}

- (BOOL)configureTriggerDisableStart;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTriggerDisableStart", @"command",
                taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTimingSampleClock", @"command",
                taskName, @"taskName", [NSNumber numberWithDouble:outputRateHz], @"outputRateHz", mode, @"mode",
                [NSNumber numberWithLong:count], @"samplesPerChannel", nil];
    return [self sendDictionary:dict];
}

- (BOOL)createChannelWithName:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
                taskName, @"taskName", channelName, @"channelName", nil];
    return [self sendDictionary:dict];
}

- (void)dealloc;
{
    [self stop];
    [self alterState:@"unreserve"];
    [self deleteTask];
    [socket release];
    [super dealloc];
}

- (BOOL)deleteTask;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"deleteTask", @"command",
            taskName, @"taskName", nil];
    [taskName release];
    taskName = nil;
    return [self sendDictionary:dict];
}

- (id)initWithSocket:(LLSockets *)theSocket;
{
    NSMutableDictionary *dict;

    if ([super init] != nil) {
        socket = theSocket;
        [socket retain];
        taskName = [[NSString stringWithFormat:@"DOTask%ld", nextTaskID++] retain];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createDOTask", @"command",
                                                               taskName, @"taskName", nil];
        [socket writeDictionary:dict];
    }
    return self;
}

- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
{
    NSString *message;
    NSMutableDictionary *returnDict;

    returnDict = [socket writeDictionary:dict];
    if (returnDict == nil) {
        return NO;
    }
    if ([[returnDict objectForKey:@"success"] boolValue]) {
        return YES;
    }
    // We've gotten an error.  Check whether the AOTask has been lost.
    message = [returnDict objectForKey:@"errorMessage"];
    if ([message hasPrefix:@"no task named AOTask"]) {
        NSLog(@"Yikes!");
    }
    return YES;
}

- (BOOL)start;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"startTask", @"command", taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)stop;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"stopTask", @"command", taskName, @"taskName", nil];
    return [self sendDictionary:dict];
}

- (BOOL)waitUntilDone:(float)timeoutS;
{
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"waitUntilDone", @"command", taskName, @"taskName",
                [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
    return [self sendDictionary:dict];
}

- (BOOL)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart;
{
    long index;
    NSMutableArray *array;
    NSArray *sendArray;
    NSMutableDictionary *dict;

    if (taskName == nil) {
        return NO;
    }
    array = [[NSMutableArray alloc] init];
    for (index = 0; index < lengthBytes / sizeof(Float64); index++) {
        [array addObject:[NSNumber numberWithFloat:outArray[index]]];
    }
    sendArray = [NSArray arrayWithArray:array];
    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"writeArray", @"command", taskName, @"taskName",
            [NSNumber numberWithBool:autoStart], @"autoStart", sendArray, @"outArray", nil];
    [array release];
    return [self sendDictionary:dict];
}


@end
