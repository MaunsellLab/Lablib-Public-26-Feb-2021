//
//  LLNIDAQDigitalOutput.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLSockets.h"

typedef uint32_t *NIDAQTask;

@interface LLNIDAQDigitalOutput : NSObject {

    LLSockets   *socket;
    NSString    *taskName;
}

- (void)alterState:(NSString *)newState;
- (void)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (void)configureTriggerDisableStart;
- (void)createChannelWithName:(NSString *)channelName;
- (void)deleteTask;
- (id)initWithSocket:(LLSockets *)theSocket;
- (void)start;
- (void)stop;
- (void)waitUntilDone:(float)timeoutS;
- (void)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart;

@end
