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

- (void)addSample:(NSPoint)samplePointDeg;
{
	NSRect rectDeg;
	
	rectDeg = NSMakeRect(samplePointDeg.x - dotSizeDeg / 2.0, samplePointDeg.y - dotSizeDeg / 2.0,
		dotSizeDeg, dotSizeDeg);
	[sampleLock lock];
    [sampleRectsDeg addObject:[NSValue valueWithRect:rectDeg]];	
	[sampleLock unlock];
	
	dirtyRectPix = NSUnionRect(dirtyRectPix, [self pixRectFromDegRect:rectDeg]);
	
	if (!((sampleCount++) % oneInN)) {
		if (drawOnlyDirtyRect) {
			dirtyRectPix = NSInsetRect(dirtyRectPix, -1.0, -1.0);			// allow for rounding error
			[self setNeedsDisplayInRect:dirtyRectPix];
		}
		else {
			[self setNeedsDisplay:YES];
		}
	}
} 

- (void)centerDisplay;
{
	NSRect b = [self bounds];

    [self scrollPoint:NSMakePoint((b.size.width - [self visibleRect].size.width) / 2, 
                (b.size.height - [self visibleRect].size.height) / 2)];
}

- (void)clearSamples;
{
	[sampleLock lock];
	[sampleRectsDeg removeAllObjects];
	dirtyRectPix = NSMakeRect(0, 0, 0, 0);
	[sampleLock unlock];
}

- (void)dealloc;
{
	[eyeColor release];
	[gridColor release];
	[sampleRectsDeg release];
	[sampleLock release];
    [drawables release];
    [super dealloc];
}

- (BOOL)doDotFade;
{
	return doDotFade;
}

- (float)dotSizeDeg;
{
    return dotSizeDeg;
}

- (void)drawRect:(NSRect)rect;
{
    long index, ticks, grids, p, numPoints, numToDelete, rectCount, numRects;
	NSSize dotPointSizeDeg;
    NSRect b, cumRectDeg;
	NSAffineTransform *transform;
	NSRect	pointRectsDeg[kMaxSamplesDisplay];
	
// Clear

	[NSBezierPath strokeRect:rect];

	b = [self bounds];
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:b];

// Concatenate a transform to convert from degrees to coordinates in the view

	transform = [NSAffineTransform transform];
	[transform translateXBy:b.size.width / 2.0 yBy:b.size.height / 2.0];
	[transform scaleXBy:b.size.width / kMaxDeg yBy:b.size.height / kMaxDeg];
	[transform concat];
//	[NSBezierPath setDefaultLineWidth:kMaxDeg / (float)b.size.width];
	[NSBezierPath setDefaultLineWidth:kMaxDeg / b.size.width];

// Plot grid lines and tick marks

    [gridColor set];
//    [[NSColor blueColor] set];
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
	
// Draw the drawables.  Note that drawables will not have any effect on regions outside the
// dirtyRectPix.  Drawables need to enable drawing by calling the LLEyeXYView method
// setNeedsDisplayInRect before they draw.

	[drawables makeObjectsPerformSelector:@selector(draw)];
	
// Plot eye positions.  The MIN() on the index for plotColors is essential, because the array data
// may change size (larger or smaller) while we are in the loop.  That might make us go beyond the
// end of the plotColors array.

	numPoints = [sampleRectsDeg count];
	if (numPoints > 0 && [sampleLock tryLock]) {
		if (numPoints > samplesToSave) {			// clear overflow points first
			numToDelete = ([sampleRectsDeg count] - samplesToSave + 1) / oneInN * oneInN;
			[sampleRectsDeg removeObjectsInRange:NSMakeRange(0, numToDelete)];
			numPoints -= numToDelete;
		}
		numRects = MIN(samplesToSave / oneInN, kMaxSamplesDisplay);
		dotPointSizeDeg = NSMakeSize(dotSizeDeg, dotSizeDeg);
		cumRectDeg = NSMakeRect(0, 0, 0, 0);
		for (rectCount = 0, p = 0; p < numPoints && rectCount < numRects; p += oneInN, rectCount++) {
			pointRectsDeg[rectCount] = [[sampleRectsDeg objectAtIndex:p] rectValue];
			cumRectDeg = NSUnionRect(cumRectDeg, pointRectsDeg[rectCount]);
		}
		dirtyRectPix = [self pixRectFromDegRect:cumRectDeg];
		[sampleLock unlock];
		if (doDotFade) {
			NSRectFillListWithColors(pointRectsDeg, pointColors, rectCount);
		}
		else {
			[eyeColor set];
			NSRectFillList(pointRectsDeg, rectCount);
		}
	}
    [NSBezierPath setDefaultLineWidth:1.0];
	[[NSColor blackColor] set];
}

- (NSColor *)eyeColor;
{
	return eyeColor;
}

- (id) initWithFrame:(NSRect)frame;
{
    if ((self = [super initWithFrame:frame]) != nil) {
		[self setEyeColor:[NSColor blueColor]];
        drawables = [[NSMutableArray alloc] init];		
		eyeColor = [[NSColor blueColor] retain];
		tickDeg = 1.0;
		doTicks = doGrid = YES;
		gridDeg = 5.0;
		gridColor = [[NSColor blueColor] retain];

		sampleLock = [[NSLock alloc] init];
		sampleRectsDeg = [[NSMutableArray alloc] init];
		dirtyRectPix = NSMakeRect(0, 0, 0, 0);
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

// Convert an NSPoint in degrees to an NSPoint within the view's bounds

- (NSPoint)pixPointFromDegPoint:(NSPoint)eyePointDeg;
{
	NSRect b = [self bounds];

    return NSMakePoint(eyePointDeg.x * (b.size.width / kMaxDeg) + b.size.width / 2.0,
						eyePointDeg.y * (b.size.height / kMaxDeg) + b.size.height / 2.0); 
}

// Convert an NSRect in degrees to an NSRect within the view's bounds

- (NSRect)pixRectFromDegRect:(NSRect)eyeRectDeg;
{
	NSRect b = [self bounds];
	
	return NSMakeRect(eyeRectDeg.origin.x * (b.size.width / kMaxDeg) + b.size.width / 2.0, 
						eyeRectDeg.origin.y * (b.size.height / kMaxDeg) + b.size.height / 2.0,
						eyeRectDeg.size.width * (b.size.width / kMaxDeg), 
						eyeRectDeg.size.height * (b.size.height / kMaxDeg));
}

- (void)removeAllDrawables;
{
	[drawables removeAllObjects];
}

- (void)removeDrawable:(id <LLDrawable>)drawable;
{
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

- (void)setDotSizeDeg:(double)sizeDeg;
{
    dotSizeDeg = sizeDeg;
}

- (void)setDrawOnlyDirtyRect:(BOOL)state;
{
	if (state != drawOnlyDirtyRect) {
		drawOnlyDirtyRect = state;
		[self clearSamples];
	}
}

- (void)setEyeColor:(NSColor *)newColor;
 {
	[newColor retain];
	[eyeColor release];
	eyeColor = newColor;
	[self updatePointColors];
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

- (void)setSamplesToSave:(long)samples;
{
	long numToDelete;
	
	samplesToSave = samples;
    if ([sampleRectsDeg count] > samplesToSave) {
		[sampleLock lock];
		numToDelete = ([sampleRectsDeg count] - samplesToSave + 1) / oneInN * oneInN;
        [sampleRectsDeg removeObjectsInRange:NSMakeRange(0, numToDelete)];
		[sampleLock unlock];
    }
	[self updatePointColors];
}

- (void)setTickDeg:(float)spacingDeg {

	tickDeg = spacingDeg;
}

- (void)setTicks:(BOOL)state {

	doTicks = state;
}

- (void)updatePointColors;
{
	long a, limit;
	
	limit = MIN(samplesToSave, kMaxSamplesDisplay);
	for (a = 0; a < limit; a++) {
		[pointColors[a] release];
		pointColors[a] = [[eyeColor 
						blendedColorWithFraction:(1.0 - (float)a / limit) 
						ofColor:[NSColor whiteColor]] retain];
	}
}

@end
