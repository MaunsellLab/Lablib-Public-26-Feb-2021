//
//  LLNIDAQTask.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import <Lablib/LLSockets.h>

typedef NS_ENUM(unsigned int, TaskType) {kNoType,
    kAnalogOutputType,
    kAnalogInputType,
    kDigitalOutputType,
    kDigitalInputType
};

typedef uint32_t *NIDAQTask;

@interface LLNIDAQTask : NSObject {

    NSMutableArray      *channelMaxV;
    NSMutableArray      *channelMinV;
    NSMutableArray      *channelNames;
    NSString            *taskName;
    long                taskID;
    TaskType            taskType;
}

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL configureTriggerDisableStart;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL createAOTask;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL createDOTask;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL deleteTask;
@property (NS_NONATOMIC_IOSONLY, retain) LLSockets *socket;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL start;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL stop;

- (BOOL)alterState:(NSString *)newState;
- (BOOL)configureTimingSampleClockWithRate:(double)outputRateHz mode:(NSString *)mode samplesPerChannel:(long)count;
- (BOOL)configureTriggerDigitalEdgeStart:(NSString *)triggerChannelName edge:(NSString *)edge;
- (BOOL)createChannelWithName:(NSString *)channelName;
- (BOOL)createVoltageChannelWithName:(NSString *)channelName maxVolts:(float)maxV minVolts:(float)minV;
- (BOOL)doTrain:(Float64 *)train numSamples:(long)trainSamples outputRateHz:(float)outputRateHz
        digitalTrigger:(BOOL)digitalTrigger triggerChannelName:(NSString *)channelName autoStart:(BOOL)autoStart
        waitTimeS:(float)waitTimeS;
- (instancetype)initWithSocket:(LLSockets *)theSocket;
- (BOOL)isDone;
- (BOOL)sendDictionary:(NSMutableDictionary *)dict;
- (BOOL)setMaxVolts:(float)maxV minVolts:(float)minV forChannelName:(NSString *)channelName;
- (BOOL)waitUntilDone:(float)timeoutS;
- (BOOL)writeSamples:(Float64 *)outArray numSamples:(long)numSamples autoStart:(BOOL)autoStart timeoutS:(Float64)timeoutS;

@end
