//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLSockets.h"
#import "LLNIDAQTask.h"
#import "LLPowerCalibrator.h"

@interface LLNIDAQ : NSObject {

    LLNIDAQTask             *analogOutput;
    NSLock                  *deviceLock;
    NSString                *deviceName;
    LLNIDAQTask             *digitalOutput;
    BOOL                    doControlShutter;
    LLPowerCalibrator       *calibrator;
    LLSockets               *socket;
}

- (void)doInitWithSocket:(LLSockets *)theSocket calibrationFileName:(NSString *)fileName;
- (id)initWithSocket:(LLSockets *)theSocket;
- (id)initWithSocket:(LLSockets *)theSocket calibrationFile:(NSString *)calibrationFileName;
- (BOOL)isDone:(LLNIDAQTask *)theTask;
- (float)maximumMW;
- (float)minimumMW;
- (void)outputDigitalValue:(short)value;
- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
                   duration1MS:(long)dur1MS delay1MS:(long)delay1MS digitalTrigger:(BOOL)digitalTrigger;
- (void)setPowerToMinimum;
- (void)showWindow:(id)sender;
- (BOOL)start:(LLNIDAQTask *)theTask;
- (BOOL)stop:(LLNIDAQTask *)theTask;

@end
