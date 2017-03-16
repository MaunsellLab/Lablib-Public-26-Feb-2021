//
//  LLNIDAQAnalogOutput.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQAnalogOutput.h"

@implementation LLNIDAQAnalogOutput

- (void)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
{

}

- (void)createChannel:(NSString *)channelName;
{
    
}

- (void)dealloc;
{
    [self stop];
    [super dealloc];
}

- (void)createChannelWithName:(NSString *)channelName;
{

}

- (id)initWithName:(NSString *)taskName socket:(LLSockets *)theSocket;
{
    NSMutableDictionary *dict;

    if ([super init] != nil) {
        socket = theSocket;
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                @"DAQmxCreateTask", @"command", taskName, @"taskName", nil];
        dict = [socket writeDictionary:dict];
        task = (NIDAQTask)[[dict valueForKey:@"task"] pointerValue];
    }
    return self;
}

- (void)start;
{
}

- (void)stop;
{
    NSMutableDictionary *dict;

    if (task != nil) {
        dict = [NSMutableDictionary dictionaryWithObjectsAndKeys: @"DAQmxStopTask", @"command", task, @"task", nil];
        dict = [socket writeDictionary:dict];
        task = nil;
    }
}

- (void)waitUntilDone;
{
}

- (void)writeArray:(Float64 *)outArray autoStart:(BOOL)autoStart;
{

}


@end
