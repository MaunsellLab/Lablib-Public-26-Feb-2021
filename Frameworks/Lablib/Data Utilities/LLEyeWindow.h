//
//  LLEyeWindow.h
//  Lablib
//
//  Created by John Maunsell on Sun May 18 2003.
//  Copyright (c) 2003-2012. All rights reserved.
//

#import <Lablib/LLDrawable.h>

@interface LLEyeWindow:NSObject {

    float     azimuthDeg;
    NSColor    *fillColor;
    NSColor *plotColor;
    float    elevationDeg;
    float    radiusDeg;
    NSRect    rectDeg;
    NSColor    *strokeColor;
}

- (float)azimuthDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint centerDeg;
@property (NS_NONATOMIC_IOSONLY, copy) NSColor *color;
- (float)elevationDeg;
- (float)heightDeg;
- (BOOL)inWindowDeg:(NSPoint)pointDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint originDeg;
- (float)radiusDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSRect rectDeg;
- (void)setAzimuthDeg:(double)azimuth elevationDeg:(double)elevation;
- (void)setAzimuthDeg:(double)azimuth;
- (void)setElevationDeg:(double)elevation;
- (void)setHeightDeg:(double)height;
- (void)setRadiusDeg:(double)radius;
- (void)setRectOrigin;
- (void)setWidthAndHeightDeg:(double)value;
- (void)setWidthDeg:(double)width;
- (void)setWidthDeg:(double)width heightDeg:(double)height;
@property (NS_NONATOMIC_IOSONLY, readonly) NSSize sizeDeg;
- (float)widthDeg;

@end
