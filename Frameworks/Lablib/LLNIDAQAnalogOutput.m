//
//  LLNIDAQAnalogOutput.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQAnalogOutput.h"

static long nextTaskID = 0;         // class variable to persist across all instances

@implementation LLNIDAQAnalogOutput

- (void)alterState:(NSString *)newState;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"alterState", @"command", taskName, @"taskName",
                newState, @"state", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTriggerDigitalEdgeStart", @"command",
                taskName, @"taskName", edge, @"edge", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)configureTriggerDisableStart;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTriggerDisableStart", @"command",
                taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"configureTimingSampleClock", @"command",
                taskName, @"taskName", [NSNumber numberWithDouble:outputRateHz], @"outputRateHz", mode, @"mode",
                [NSNumber numberWithLong:count], @"samplesPerChannel", nil];
        dict = [socket writeDictionary:dict];
    }
}

//- (void)createChannel:(NSString *)channelName;
//{
//    NSMutableDictionary *dict;
//
//    if (taskName != nil) {
//        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
//                taskName, @"taskName", channelName, @"channelName", nil];
//        dict = [socket writeDictionary:dict];
//    }
//}

- (void)createVoltageChannelWithName:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createVoltageChannel", @"command",
                taskName, @"taskName", channelName, @"channelName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)dealloc;
{
    [self stop];
    [self alterState:@"unreserve"];
    [self deleteTask];
    [socket release];
    [super dealloc];
}

- (void)deleteTask;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"deleteTask", @"command",
                taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
        [taskName release];
        taskName = nil;
    }
}

- (id)initWithSocket:(LLSockets *)theSocket;
{
    NSMutableDictionary *dict;

    if ([super init] != nil) {
        socket = theSocket;
        [socket retain];
        taskName = [[NSString stringWithFormat:@"AOTask%ld", nextTaskID++] retain];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createAOTask", @"command",
                                                               taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
    }
    return self;
}

- (void)start;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"startTask", @"command", taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)stop;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"stopTask", @"command", taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)waitUntilDone:(float)timeoutS;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"waitUntilDone", @"command", taskName, @"taskName",
                [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;
{
    long index;
    NSMutableDictionary *dict;
    NSMutableArray *array;
    NSArray *sendArray;

    if (taskName != nil) {
        array = [[NSMutableArray alloc] init];
        for (index = 0; index < lengthBytes / sizeof(Float64); index++) {
//            [array addObject:[NSString stringWithFormat:@"%f", outArray[index]]];
            [array addObject:[NSNumber numberWithFloat:outArray[index]]];
        }
        sendArray = [NSArray arrayWithArray:array];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"writeArray", @"command", taskName, @"taskName",
                [NSNumber numberWithBool:autoStart], @"autoStart", sendArray, @"outArray",
                [NSNumber numberWithFloat:timeoutS], @"timeoutS", nil];
        dict = [socket writeDictionary:dict];
        [array release];
    }
}


@end
