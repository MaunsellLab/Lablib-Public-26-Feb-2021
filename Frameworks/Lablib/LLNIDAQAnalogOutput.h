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

    NSMutableArray      *channelMaxV;
    NSMutableArray      *channelMinV;
    NSMutableArray      *channelNames;
    LLSockets           *socket;
    NSString            *taskName;
}

- (BOOL)alterState:(NSString *)newState;
- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (BOOL)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
- (BOOL)configureTriggerDisableStart;
- (BOOL)createTaskWithName:(NSString *)theName;
- (BOOL)createVoltageChannelWithName:(NSString *)channelName maxVolts:(float)maxV minVolts:(float)minV;
- (BOOL)deleteTask;
- (id)initWithSocket:(LLSockets *)theSocket;
- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
- (BOOL)start;
- (BOOL)stop;
- (BOOL)waitUntilDone:(float)timeoutS;
- (BOOL)writeSamples:(Float64 *)outArray numSamples:(long)numSamples autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;

@end
