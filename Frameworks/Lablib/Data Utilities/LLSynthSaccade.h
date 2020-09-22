//
//  LLSynthSaccade.h
//  Lablib
//
//  Created by John Maunsell on Mon May 19 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import <Lablib/LLEyeCalibrator.h>

@interface LLSynthSaccade : NSObject {

@protected

    long    accelSteps;
    NSPoint    currentPosition;
    long     decelSteps;
    double    dirRad;
    double    magnitudeUnits;
    double    samplesPerS;
    double    unitsPerDeg;
    double    xMagEye;
    double    xStepAccelPerSample;
    double    xStepSize;
    double    yMagEye;
    double    yStepAccelPerSample;
    double    yStepSize;
}

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL done;
- (instancetype)initFrom:(NSPoint)current samplePerMS:(long)samplePer unitsPerDeg:(float)calibration;
- (instancetype)initFrom:(NSPoint)current to:(NSPoint)target samplePerMS:(long)samplePer 
                    unitsPerDeg:(float)calibration;
- (void)initParameters;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint nextPosition;

@end
