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
- (void)outputDigitalValue:(short)value;
- (void)setPowerToMinimum;
- (void)showWindow:(id)sender;

@end
