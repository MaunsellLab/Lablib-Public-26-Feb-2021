//
//  LLEyeWindow.h
//  Lablib
//
//  Created by John Maunsell on Sun May 18 2003.
//  Copyright (c) 2003-2012. All rights reserved.
//

#import "LLDrawable.h"

#define kLLEyeWindowEventDesc\
		{{@"long",	@"index", 1, offsetof(FixWindowData, index)},\
		{@"float",	@"windowDeg.origin.x", 1, offsetof(FixWindowData, windowDeg.origin.x)},\
		{@"float",	@"windowDeg.origin.y", 1, offsetof(FixWindowData, windowDeg.origin.y)},\
		{@"float",	@"windowDeg.size.width", 1, offsetof(FixWindowData, windowDeg.size.width)},\
		{@"float",	@"windowDeg.size.height", 1, offsetof(FixWindowData, windowDeg.size.height)},\
		{@"float",	@"windowUnits.origin.x", 1, offsetof(FixWindowData, windowUnits.origin.x)},\
		{@"float",	@"windowUnits.origin.y", 1, offsetof(FixWindowData, windowUnits.origin.y)},\
		{@"float",	@"windowUnits.size.width", 1, offsetof(FixWindowData, windowUnits.size.width)},\
		{@"float",	@"windowUnits.size.height", 1, offsetof(FixWindowData, windowUnits.size.height)},\
		{nil}}

@interface LLEyeWindow:NSObject {

    float 	azimuthDeg;
	NSColor	*fillColor;
    NSColor *plotColor;
    float	elevationDeg;
    float	radiusDeg;
    NSRect	rectDeg;
	NSColor	*strokeColor;
}

- (float)azimuthDeg;
- (NSPoint)centerDeg;
- (NSColor *)color;
- (float)elevationDeg;
- (float)heightDeg;
- (BOOL)inWindowDeg:(NSPoint)pointDeg;
- (NSPoint)originDeg;
- (float)radiusDeg;
- (NSRect)rectDeg;
- (void)setAzimuthDeg:(double)azimuth elevationDeg:(double)elevation;
- (void)setAzimuthDeg:(double)azimuth;
- (void)setElevationDeg:(double)elevation;
- (void)setHeightDeg:(double)height;
- (void)setRadiusDeg:(double)radius;
- (void)setRectOrigin;
- (void)setWidthAndHeightDeg:(double)value;
- (void)setWidthDeg:(double)width;
- (void)setWidthDeg:(double)width heightDeg:(double)height;
- (void)setColor:(NSColor *)color;
- (NSSize)sizeDeg;
- (float)widthDeg;

@end
