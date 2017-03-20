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
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"configureTimingSampleClock", @"command",
                task, @"task", outputRateHz, @"outputRateHz", mode, @"mode", [NSNumber numberWithLong:count], nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)createChannel:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createVoltageChannel", @"command",
                task, @"task", channelName, @"channelName", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)createChannelWithName:(NSString *)channelName;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"createChannel", @"command",
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
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"startTask", @"command", task, @"task", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)stop;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"stopTask", @"command", task, @"task", nil];
        dict = [socket writeDictionary:dict];
        task = nil;
    }
}

- (void)waitUntilDone;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"waitUntilDone", @"command", task, @"task", nil];
        dict = [socket writeDictionary:dict];
    }
}

- (void)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart;
{
    NSMutableDictionary *dict;

    if (taskName != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"writeArray", @"command", task, @"task",
                [NSData dataWithBytes:outArray length:lengthBytes], @"array", autoStart, @"autoStart", nil];
        dict = [socket writeDictionary:dict];
    }
}


@end
