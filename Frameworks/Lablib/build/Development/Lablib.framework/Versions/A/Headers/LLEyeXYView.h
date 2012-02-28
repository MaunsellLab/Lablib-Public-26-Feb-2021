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
	NSColor			*eyeColor;
    NSMutableArray	*eyeWindows;
	NSColor			*gridColor;
	float			gridDeg;
    long			oneInN;
    NSMutableArray	*paths;
	NSColor			*pointColors[kMaxSamplesDisplay];
	long			sampleCount;
    NSLock			*sampleLock;
    NSMutableArray  *sampleRectsDeg;
	long			samplesToSave;
	float			tickDeg;
}

- (void)addDrawable:(id <LLDrawable>)drawable;
- (void)addSample:(NSPoint)samplePoint;
- (void)centerDisplay;
- (void)clearSamples;
- (float)dotSizeDeg;
- (NSColor *)eyeColor;
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
- (void)setGridDeg:(float)spacingDeg;
- (void)setGrid:(BOOL)state;
- (void)setOneInN:(double)n;
- (void)setSamplesToSave:(long)samples;
- (void)setTickDeg:(float)spacingDeg;
- (void)setTicks:(BOOL)state;
- (void)updatePointColors;

@end
