//
//  LLBar.h
//
//  Created by John Maunsell on Sat Feb 15 2003.
//  Copyright (c) 2006. All rights reserved.
//

#import <Lablib/LLVisualStimulus.h>

extern NSString *LLBarAzimuthDegKey;
extern NSString *LLBarBackColorKey;
extern NSString *LLBarDirectionDegKey;
extern NSString *LLBarElevationDegKey;
extern NSString *LLBarForeColorKey;
extern NSString *LLBarKdlThetaDegKey;
extern NSString *LLBarKdlPhiDegKey;
extern NSString *LLBarRadiusDegKey;

extern NSString *LLBarLengthDegKey;
extern NSString *LLBarWidthDegKey;

@interface LLBar : LLVisualStimulus {

    float        lengthDeg;
    float        widthDeg;
}

@property (NS_NONATOMIC_IOSONLY) float lengthDeg;
- (void)setOrientationDeg:(float)newOri;
@property (NS_NONATOMIC_IOSONLY) float widthDeg;

@end

