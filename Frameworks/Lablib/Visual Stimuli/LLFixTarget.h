//
//  LLFixTarget.h
//  Lablib
//
//  Created by John Maunsell on Thu Feb 12 2004.
//  Copyright (c) 2004. All rights reserved.
//

#import "LLVisualStimulus.h"

typedef NS_ENUM(unsigned int, LLTargetShape) {kLLCircle, kLLSquare, kLLDiamond, kLLCross, kLLShapes};

extern NSString *LLFixAzimuthDegKey;
extern NSString *LLFixBackColorKey;
extern NSString *LLFixDirectionDegKey;
extern NSString *LLFixElevationDegKey;
extern NSString *LLFixForeColorKey;
extern NSString *LLFixKdlThetaDegKey;
extern NSString *LLFixKdlPhiDegKey;
extern NSString *LLFixRadiusDegKey;

extern NSString *LLFixInnerRadiusDegKey; 
extern NSString *LLFixShapeKey; 

@interface LLFixTarget : LLVisualStimulus {

    float        innerRadiusDeg;
    long        shape;
}

- (void)drawCircleWithRadius:(float)radiusDeg;
- (void)drawRectWithWidthDeg:(float)widthDeg lengthDeg:(float)lengthDeg;
@property (NS_NONATOMIC_IOSONLY, copy) NSColor *fixTargetColor;
@property (NS_NONATOMIC_IOSONLY) float innerRadiusDeg;
@property (NS_NONATOMIC_IOSONLY) float outerRadiusDeg;
- (void)setOnRed:(float)red green:(float)green blue:(float)blue;
@property (NS_NONATOMIC_IOSONLY) long shape;

@end
