//
//  LLEyeXYView.h
//  Lablib
//
//  Created by John Maunsell on Thu May 01 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import <Lablib/LLEyeWindow.h>
#import <Lablib/LLEyeCalibrator.h>
#import <Lablib/LLViewScale.h>

#define kAlphaLevels        8
#define kMaxSamplesDisplay    1000

#ifndef kEyes
typedef NS_ENUM(unsigned int, LLWhichEye) {kLeftEye, kRightEye};
#define kEyes   (kRightEye + 1)
#endif

@interface LLEyeXYView:NSView {

    NSColor         *backgroundColor;
    NSRect          dirtyRectPix;
    BOOL            doDotFade;
    BOOL            doGrid;
    BOOL            doTicks;
    CGFloat         dotSizeDeg;
    NSMutableArray  *drawables;
    BOOL            drawOnlyDirtyRect;
    NSColor         *eyeColor[kEyes];
    NSMutableArray  *eyeWindows;
    NSColor         *gridColor;
    CGFloat         gridDeg;
    long            oneInN;
    NSMutableArray  *paths;
    NSColor         *pointColors[kEyes][kMaxSamplesDisplay];
    long            sampleCount[kEyes];
    NSLock          *sampleLock;
    NSMutableArray  *sampleRectsDeg[kEyes];
    long            samplesToSave;
    NSRect          theBounds;
    CGFloat         tickDeg;
}

- (void)addDrawable:(id <LLDrawable>)drawable;
- (void)addSample:(NSPoint)samplePointDeg;
- (void)addSample:(NSPoint)samplePointDeg forEye:(long)eyeIndex;
- (void)centerDisplay;
- (void)clearSamples;
@property (NS_NONATOMIC_IOSONLY) CGFloat dotSizeDeg;
- (void)drawPointsInRect:(NSRect)rect forEye:(long)eyeIndex;
@property (NS_NONATOMIC_IOSONLY, copy) NSColor *eyeColor;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSColor *eyeLColor;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSColor *eyeRColor;
- (long)oneInN;
- (NSPoint)pixPointFromDegPoint:(NSPoint)eyePointDeg;
- (NSRect)pixRectFromDegRect:(NSRect)eyeRectDeg;
- (void)removeAllDrawables;
- (void)removeDrawable:(id <LLDrawable>)drawable;
- (void)setDoGrid:(BOOL)state;
- (void)setDotFade:(BOOL)state;
- (void)setDoDotFade:(BOOL)state;
- (void)setDrawOnlyDirtyRect:(BOOL)state;
- (void)setEyeColor:(NSColor *)newColor forEye:(long)eyeIndex;
- (void)setGridDeg:(CGFloat)spacingDeg;
- (void)setGrid:(BOOL)state;
- (void)setOneInN:(CGFloat)n;
- (void)setSamplesToSave:(long)samples;
- (void)setTickDeg:(CGFloat)spacingDeg;
- (void)setTicks:(BOOL)state;
- (void)updatePointColors;


@end
