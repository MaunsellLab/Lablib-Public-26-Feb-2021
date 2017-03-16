//
//  LLNIDAQAnalogOutput.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLSockets.h"

typedef uint32_t *NIDAQTask;

@interface LLNIDAQAnalogOutput : NSObject {

    LLSockets   *socket;
    NIDAQTask   task;
}

- (void)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (void)createChannelWithName:(NSString *)channelName;
- (id)initWithName:(NSString *)taskName socket:(LLSockets *)theSocket;
- (void)start;
- (void)stop;
- (void)waitUntilDone;
- (void)writeArray:(Float64 *)outArray autoStart:(BOOL)autoStart;

@end
