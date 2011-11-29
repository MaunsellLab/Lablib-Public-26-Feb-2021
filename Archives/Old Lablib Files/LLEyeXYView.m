//
//  LLEyeXYView.m
//  Lablib
//
//  Created by John Maunsell on Thu May 01 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLEyeXYView.h"
#import "LLEyeCalibrator.h"
#import "LLPlotAxes.h"
#import "LLViewUtilities.h"

#define kMaxDeg				90.0
#define kTickHeightDeg		0.1

@implementation LLEyeXYView

- (void)addDrawable:(id <LLDrawable>)drawable {

	[drawables addObject:drawable];
}

- (void)addSample:(NSPoint)samplePoint;
{
	[dataLock lock];
    [data addObject:[NSValue valueWithPoint:samplePoint]];	
	[dataLock unlock];
    [self setNeedsDisplay:YES];
} 

- (void)centerDisplay;
{
	NSRect b = [self bounds];

    [self scrollPoint:NSMakePoint((b.size.width - [self visibleRect].size.width) / 2, 
                (b.size.height - [self visibleRect].size.height) / 2)];
}

- (void)clearSamples;
{
	[dataLock lock];
	[data removeAllObjects];
	[dataLock unlock];
}

// Convert an NSPoint in degrees to an NSPoint within the view's bounds

- (NSPoint)convertPoint:(NSPoint)eyePoint;
{
	NSRect b = [self bounds];

    return NSMakePoint(eyePoint.x / (b.size.width / kMaxDeg) + b.size.width / 2.0,
						eyePoint.y / (b.size.height / kMaxDeg) + b.size.height / 2.0); 
}

// Convert an NSRect in degrees to an NSRect within the view's bounds

- (NSRect)convertRect:(NSRect)eyeRect;
{
	NSRect b = [self bounds];
	
	return NSMakeRect(eyeRect.origin.x / (b.size.width / kMaxDeg) + b.size.width / 2.0, 
						eyeRect.origin.y / (b.size.height / kMaxDeg) + b.size.height / 2.0,
						eyeRect.size.width / (b.size.width / kMaxDeg), 
						eyeRect.size.height / (b.size.height / kMaxDeg));
}

- (void) dealloc {

	[eyeColor release];
	[plotColors release];
	[data release];
	[dataLock release];
    [drawables release];
    [super dealloc];
}

- (BOOL)doDotFade;
{
	return doDotFade;
}

- (void) drawRect:(NSRect)rect {

    long index, ticks, grids, p, numToDelete;
    double alphaStep;
    NSRect b;
    NSRect pointRect;
	NSAffineTransform *transform;

// Clear

	b = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:b];

// Concatenate a transform to convert from degrees to coordinates in the view

	transform = [NSAffineTransform transform];
	[transform translateXBy:b.size.width / 2.0 yBy:b.size.height / 2.0];
	[transform scaleXBy:b.size.width / kMaxDeg yBy:b.size.height / kMaxDeg];
	[transform concat];
	[NSBezierPath setDefaultLineWidth:kMaxDeg / (float)b.size.width];
	
// Plot grid lines and tick marks

    [[NSColor blueColor] set];
	grids = (doGrid && gridDeg > 0) ? (long)(kMaxDeg / gridDeg) : 1;
	index = (doGrid && gridDeg > 0) ? -grids : 0;
	for ( ; index < grids; index++) {
		[NSBezierPath strokeLineFromPoint:NSMakePoint(-kMaxDeg, index * gridDeg) 
						toPoint:NSMakePoint(kMaxDeg, index * gridDeg)];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(index * gridDeg, -kMaxDeg) 
						toPoint:NSMakePoint(index * gridDeg, kMaxDeg)];
	}
	if (doTicks && tickDeg > 0) {
		ticks = (long)(kMaxDeg / tickDeg);
		for (index = -ticks; index < ticks; index++) {
			[NSBezierPath strokeLineFromPoint:NSMakePoint(index * tickDeg, -kTickHeightDeg) 
					toPoint:NSMakePoint(index * tickDeg, kTickHeightDeg)];
			[NSBezierPath strokeLineFromPoint:NSMakePoint(-kTickHeightDeg, index * tickDeg) 
					toPoint:NSMakePoint(kTickHeightDeg, index * tickDeg)];
		}
	}
	
// Draw the drawables

	[drawables makeObjectsPerformSelector:@selector(draw)];
	
// Plot eye positions.  The MIN() on the index for plotColors is essential, because the array data
// may change size (larger or smaller) while we are in the loop.  That might make us go beyond the
// end of the plotColors array.

	[dataLock lock];
    if ([data count] > 0) {
		if ([data count] > samplesToSave) {
			numToDelete = ([data count] - samplesToSave + 1) / oneInN * oneInN;
			[data removeObjectsInRange:NSMakeRange(0, numToDelete)];
		}
        pointRect.size = NSMakeSize(dotSizeDeg, dotSizeDeg);
        alphaStep = [data count] / (double)kAlphaLevels;
        [[plotColors objectAtIndex:kAlphaLevels - 1] set]; 
        for (p = 0; p < [data count]; p += oneInN) {
            if (doDotFade) {
                [[plotColors objectAtIndex:MIN(kAlphaLevels - 1, (long)(p / alphaStep))] set];
            }
            pointRect.origin = [[data objectAtIndex:p] pointValue];
            [NSBezierPath fillRect:pointRect];
        }
    }
	[dataLock unlock];
    [NSBezierPath setDefaultLineWidth:1.0];
}

- (NSColor *)eyeColor;
{
	return eyeColor;
}

- (id) initWithFrame:(NSRect)frame;
{
//    NSRect b;
    if ((self = [super initWithFrame:frame]) != nil) {
		plotColors = [[NSMutableArray alloc] init];
		[self setEyeColor:[NSColor blueColor]];
 //       b = [self bounds];
//        boundsOffset = b.size.width / 2;
        drawables = [[NSMutableArray alloc] init];		
		
		tickDeg = 1.0;
		doTicks = doGrid = YES;
		gridDeg = 5.0;

		dataLock = [[NSLock alloc] init];
		data = [[NSMutableArray alloc] init];
    }
    return self;
}

// Overwrite isOpaque to improve performance

- (BOOL)isOpaque {

	return YES;
}

// Return the one in n ratio that tells what fraction of the points will be plotted

- (long)oneInN {

	return oneInN;
}

- (void)removeAllDrawables {

	[drawables removeAllObjects];
}

- (void)removeDrawable:(id <LLDrawable>)drawable {

	[drawables removeObject:drawable];
}

- (void)setDoGrid:(BOOL)state;
{
	doGrid = state;
}

- (void)setDoDotFade:(BOOL)state;
{
    doDotFade = state;
}

- (void)setDotFade:(BOOL)state {

    doDotFade = state;
}

- (void)setDotSizeDeg:(double)sizeDeg {

    dotSizeDeg = sizeDeg;
}

- (void)setEyeColor:(NSColor *)newColor;
 {

    long a;
    float red, green, blue;
    
	[newColor retain];
	[eyeColor release];
	eyeColor = newColor;
    red = [eyeColor redComponent];
    green = [eyeColor greenComponent];
    blue = [eyeColor blueComponent];

	[plotColors removeAllObjects];
    for (a = 0; a < kAlphaLevels; a++) {
        [plotColors addObject:[NSColor 
				colorWithDeviceRed:red green:green blue:blue alpha:(a + 1) * (1.0 / kAlphaLevels)]];
    }
}

- (void)setGridDeg:(float)spacingDeg {

	gridDeg = spacingDeg;
}

- (void)setGrid:(BOOL)state {

	doGrid = state;
}

- (void) setOneInN:(double)n {

    oneInN = n;
}

- (void)setSamplesToSave:(long)samples {

	long numToDelete;
	
	samplesToSave = samples;
    if ([data count] > samplesToSave) {
		[dataLock lock];
		numToDelete = ([data count] - samplesToSave + 1) / oneInN * oneInN;
        [data removeObjectsInRange:NSMakeRange(0, numToDelete)];
		[dataLock unlock];
    }
}

- (void)setTickDeg:(float)spacingDeg {

	tickDeg = spacingDeg;
}

- (void)setTicks:(BOOL)state {

	doTicks = state;
}

@end
