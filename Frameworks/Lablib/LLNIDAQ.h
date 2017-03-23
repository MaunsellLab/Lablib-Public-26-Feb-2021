//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLSockets.h"
#import "LLNIDAQAnalogOutput.h"
#import "LLNIDAQDigitalOutput.h"
#import "LLPowerCalibrator.h"

@interface LLNIDAQ : NSObject {

    LLNIDAQAnalogOutput     *analogOutput;
    NSLock                  *deviceLock;
    NSString                *deviceName;
    LLNIDAQDigitalOutput    *digitalOutput;
    BOOL                    doControlShutter;
    LLPowerCalibrator       *calibrator;
    LLSockets               *socket;
}

- (id)initWithSocket:(LLSockets *)theSocket;
- (float)maximumMW;
- (float)minimumMW;
- (void)outputDigitalValue:(short)value;
- (void)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
                     duration1MS:(long)dur1MS delay1MS:(long)delay1MS;
- (void)setPowerToMinimum;
- (void)showWindow:(id)sender;

@end
