//
//  LLBinocCalibrator.h
//  Lablib
//
//  Created by John Maunsell 
//  Copyright (c) 2012 All rights reserved.
//

#import "LLEyeCalibrator.h"

#ifndef kEyes
typedef NS_ENUM(unsigned int, kWhichEye) {kLeftEye, kRightEye};
#define kEyes   (kRightEye + 1)
#endif

#define kLLEyeCalibratorOffsets         4

@interface LLBinocCalibrator : NSWindowController {

    LLEyeCalibrator         *calibrators[kEyes];
    NSAffineTransformStruct currentCalibration;                // calibration with offset
    LLEyeCalibrationData    data;
    NSAffineTransformStruct offsetCalibration;
    NSPoint                 offsetDeg[kLLEyeCalibratorOffsets];
    long                    offsetIndex;
    BOOL                    positionDone[kLLEyeCalibratorOffsets];
    long                    positionsDone;
}

@property (NS_NONATOMIC_IOSONLY, readonly) NSAffineTransformStruct calibration;
@property (NS_NONATOMIC_IOSONLY, readonly) LLEyeCalibrationData *calibrationData;
@property (NS_NONATOMIC_IOSONLY) float calibrationOffsetDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint calibrationOffsetPointDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint offsetDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) long offsetIndex;

- (NSAffineTransformStruct)calibrationForEye:(long)eyeIndex;
- (LLEyeCalibrationData *)calibrationDataForEye:(long)eyeIndex NS_RETURNS_INNER_POINTER;
- (LLEyeCalibrator *)calibratorForEye:(long)eyeIndex;
- (NSPoint)degPointFromUnitPoint:(NSPoint)unitPoint;
- (NSPoint)degPointFromUnitPoint:(NSPoint)unitPoint forEye:(long)eyeIndex;
- (instancetype)initWithKeyPrefix:(NSString *)prefix;
- (void)loadOffsets;
- (long)nextCalibrationPosition;
- (long)nextCalibrationPosition:(long)offsetIndex;
- (void)setDefaults:(NSUserDefaults *)newDefaults;
- (void)setFixAzimuthDeg:(float)newAzimuthDeg elevationDeg:(float)newElevationDeg;
- (NSPoint)unitPointFromDegPoint:(NSPoint)degPoint;
- (NSPoint)unitPointFromDegPoint:(NSPoint)degPoint forEye:(long)eyeIndex;
- (NSRect)unitRectFromDegRect:(NSRect)rectDeg;
- (NSRect)unitRectFromDegRect:(NSRect)degRect forEye:(long)eyeIndex;
- (NSRect)unitRectFromEyeWindow:(LLEyeWindow *)eyeWindow;
- (NSRect)unitRectFromEyeWindow:(LLEyeWindow *)eyeWindow forEye:(long)eyeIndex;
- (NSSize)unitSizeFromDegSize:(NSSize)sizeDeg;
- (void)updateCalibration:(NSPoint)pointDeg;
- (void)updateCalibration:(NSPoint)pointDeg forEye:(long)eyeIndex;
- (void)updateLeftCalibration:(NSPoint)pointLDeg rightCalibration:(NSPoint)pointRDeg;

- (IBAction)changeToDefaults:(id)sender;
- (IBAction)parametersChanged:(id)sender;

@end
