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

- (BOOL)alterState:(NSString *)newState;
- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (BOOL)configureTriggerDisableStart;
- (BOOL)createChannelWithName:(NSString *)channelName;
- (BOOL)deleteTask;
- (id)initWithSocket:(LLSockets *)theSocket;
- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
- (BOOL)start;
- (BOOL)stop;
- (BOOL)waitUntilDone:(float)timeoutS;
- (BOOL)writeArray:(Float64 *)outArray length:(long)lengthBytes autoStart:(BOOL)autoStart;

@end
