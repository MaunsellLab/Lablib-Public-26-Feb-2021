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
    NSString    *taskName;
}

- (void)alterState:(NSString *)newState;
- (void)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (void)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
- (void)configureTriggerDisableStart;
- (void)createVoltageChannelWithName:(NSString *)channelName;
- (void)deleteTask;
- (id)initWithSocket:(LLSockets *)theSocket;
- (void)start;
- (void)stop;
- (void)waitUntilDone:(float)timeoutS;
- (void)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;

@end
