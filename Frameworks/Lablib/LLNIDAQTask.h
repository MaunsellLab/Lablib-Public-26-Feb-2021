//
//  LLNIDAQTask.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLSockets.h"

typedef enum {kNoType,
    kAnalogOutputType,
    kAnalogInputType,
    kDigitalOutputType,
    kDigitalInputType
} TaskType;

typedef uint32_t *NIDAQTask;

@interface LLNIDAQTask : NSObject {

    NSMutableArray      *channelMaxV;
    NSMutableArray      *channelMinV;
    NSMutableArray      *channelNames;
    LLSockets           *socket;
    NSString            *taskName;
    long                taskID;
    TaskType            taskType;
}

- (BOOL)alterState:(NSString *)newState;
- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (BOOL)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
- (BOOL)configureTriggerDisableStart;
- (BOOL)createChannelWithName:(NSString *)channelName;
- (BOOL)createAOTask;
- (BOOL)createDOTask;
- (BOOL)createVoltageChannelWithName:(NSString *)channelName maxVolts:(float)maxV minVolts:(float)minV;
- (BOOL)deleteTask;
- (BOOL)doTrain:(Float64 *)train numSamples:(long)trainSamples outputRateHz:(float)outputRateHz
        digitalTrigger:(BOOL)digitalTrigger triggerChannelName:(NSString *)channelName autoStart:(BOOL)autoStart
        waitTimeS:(float)waitTimeS;
- (instancetype)initWithSocket:(LLSockets *)theSocket;
- (BOOL)isDone;
- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
- (BOOL)setMaxVolts:(float)maxV minVolts:(float)minV forChannelName:(NSString *)channelName;
- (BOOL)start;
- (BOOL)stop;
- (BOOL)waitUntilDone:(float)timeoutS;
- (BOOL)writeSamples:(Float64 *)outArray numSamples:(long)numSamples autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;

@end
