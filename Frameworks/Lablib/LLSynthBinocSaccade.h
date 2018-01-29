//
//  LLSynthBinocSaccade.h
//  Lablib
//
//  Created by John Maunsell on 2012
//  Copyright (c) 2012. All rights reserved.
//

#ifndef kEyes
typedef NS_ENUM(unsigned int, WhichEye) {kLeftEye, kRightEye};
#define kEyes   (kRightEye + 1)
#endif


@interface LLSynthBinocSaccade : NSObject {

@protected

    NSSize  accelPerSample[kEyes];
    long    accelSteps[kEyes];
    NSPoint    currentPosition[kEyes];
    long     decelSteps[kEyes];
    NSSize    stepSize[kEyes];
}

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL done;
- (instancetype)initFrom:(NSPoint *)currentDeg degToUnits:(NSAffineTransform **)degToUnits samplePerMS:(long)samplePeriodMS;
- (instancetype)initFrom:(NSPoint *)currentDeg to:(NSPoint)targetDeg degToUnits:(NSAffineTransform **)degToUnits
                                samplePerMS:(long)samplePeriodMS;
- (void)initParametersFrom:(NSPoint *)currentDeg to:(NSPoint)targetDeg degToUnits:(NSAffineTransform **)degToUnits
               samplePerMS:(long)samplePeriodMS;
- (void)nextPositions:(NSPoint *)positions;

@end
