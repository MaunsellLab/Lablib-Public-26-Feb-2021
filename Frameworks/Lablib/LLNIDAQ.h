//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLSockets.h"
#import "LLNIDAQTask.h"
#import "LLPowerCalibrator.h"

#define kAOChannels 2

@interface LLNIDAQ : NSObject {

    LLNIDAQTask             *analogOutput;
    NSLock                  *deviceLock;
    NSString                *deviceName;
    LLNIDAQTask             *digitalOutput;
    BOOL                    doControlShutter;
    LLPowerCalibrator       *calibrator[kAOChannels];
    LLSockets               *socket;
}

- (void)doInitWithSocket:(LLSockets *)theSocket calibrationFileName:(NSString *)fileName;
- (id)initWithSocket:(LLSockets *)theSocket;
- (id)initWithSocket:(LLSockets *)theSocket calibrationFile:(NSString *)calibrationFileName;
- (BOOL)isDone:(LLNIDAQTask *)theTask;
- (BOOL)loadCalibration:(short)channel url:(NSURL *)url;
- (float)maximumMWForChannel:(long)channel;
- (float)minimumMWForChannel:(long)channel;
- (void)outputDigitalValue:(short)value;
- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS delay1MS:(long)delay1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS delay0MS:(long)delay0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS delay1MS:(long)delay1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
- (void)setChannel:(long)channel powerTo:(float)powerMW;
- (void)setPowerToMinimum;
- (void)setPowerToMinimumForChannel:(long)channel;
- (void)showWindow:(id)sender;
- (BOOL)start:(LLNIDAQTask *)theTask;
- (BOOL)stop:(LLNIDAQTask *)theTask;

@end
