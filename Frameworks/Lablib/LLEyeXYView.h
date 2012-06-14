//
//  LLEyeXYView.h
//  Lablib
//
//  Created by John Maunsell on Thu May 01 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLEyeWindow.h"
#import "LLEyeCalibrator.h"
#import "LLViewScale.h"

#define kAlphaLevels		8
#define kMaxSamplesDisplay	1000
enum {kLeftEye, kRightEye, kEyes};

@interface LLEyeXYView:NSView {

	NSColor			*backgroundColor;
    float			boundsOffset;
    float			boundsScaling;
	NSRect			dirtyRectPix;
    BOOL			doDotFade;
	BOOL			doGrid;
	BOOL			doTicks;
    float			dotSizeDeg;
    NSMutableArray	*drawables;
	BOOL			drawOnlyDirtyRect;
	NSColor			*eyeColor[kEyes];
    NSMutableArray	*eyeWindows;
	NSColor			*gridColor;
	float			gridDeg;
    long			oneInN;
    NSMutableArray	*paths;
	NSColor			*pointColors[kEyes][kMaxSamplesDisplay];
	long			sampleCount[kEyes];
    NSLock			*sampleLock;
    NSMutableArray  *sampleRectsDeg[kEyes];
	long			samplesToSave;
	float			tickDeg;
}

- (void)addDrawable:(id <LLDrawable>)drawable;
- (void)addLSample:(NSPoint)samplePointDeg;
- (void)addRSample:(NSPoint)samplePointDeg;
- (void)addSample:(NSPoint)samplePointDeg;
- (void)addSample:(NSPoint)samplePointDeg forEye:(long)eyeIndex;
- (void)centerDisplay;
- (void)clearSamples;
- (float)dotSizeDeg;
- (void)drawPointsForEye:(long)eyeIndex;
- (NSColor *)eyeColor;
- (NSColor *)eyeLColor;
- (NSColor *)eyeRColor;
- (long)oneInN;
- (NSPoint)pixPointFromDegPoint:(NSPoint)eyePointDeg;
- (NSRect)pixRectFromDegRect:(NSRect)eyeRectDeg;
- (void)removeAllDrawables;
- (void)removeDrawable:(id <LLDrawable>)drawable;
- (void)setDoGrid:(BOOL)state;
- (void)setDotFade:(BOOL)state;
- (void)setDoDotFade:(BOOL)state;
- (void)setDotSizeDeg:(double)sizeDeg;
- (void)setDrawOnlyDirtyRect:(BOOL)state;
- (void)setEyeColor:(NSColor *)newColor;
- (void)setLEyeColor:(NSColor *)newColor;
- (void)setREyeColor:(NSColor *)newColor;
- (void)setGridDeg:(float)spacingDeg;
- (void)setGrid:(BOOL)state;
- (void)setOneInN:(double)n;
- (void)setSamplesToSave:(long)samples;
- (void)setTickDeg:(float)spacingDeg;
- (void)setTicks:(BOOL)state;
- (void)updatePointColors;


@end
