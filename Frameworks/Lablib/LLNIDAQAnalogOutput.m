//
//  LLNIDAQAnalogOutput.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQAnalogOutput.h"

static long nextTaskID = 0;         // class variable to persist across all instances

@implementation LLNIDAQAnalogOutput

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

- (void)createChannel:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
                taskName, @"taskName", channelName, @"channelName", nil];
        dict = [socket writeDictionary:dict];
    }
}

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
    [self deleteTask];
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
        taskName = [[NSString stringWithFormat:@"AOTask%ld", nextTaskID++] retain];
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"createAOTask", @"command",
                                                               taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
        task = (NIDAQTask)[[dict valueForKey:@"task"] pointerValue];
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
        task = nil;
    }
}

- (void)waitUntilDone;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"waitUntilDone", @"command", taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart;
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
                [NSNumber numberWithBool:autoStart], @"autoStart", sendArray, @"outArray", nil];
        dict = [socket writeDictionary:dict];
        [array release];
    }
}


@end
