//
//  FTEyeXYController.m
//  Fixate Task
//
//  XY Display of eye position.
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#define NoGlobals

#import "FT.h"
#import "FTEyeXYController.h"

#define kCircleRadiusDeg	0.15
#define kCrossArmDeg		0.25
#define kLineWidthDeg		0.02

NSString *FTEyeXYAutosaveKey = @"FTEyeXYAutosave";
NSString *FTEyeXYDoDotFadeKey = @"FTEyeXYDoDotFade";
NSString *FTEyeXYDoDrawCalKey = @"FTEyeXYDoDrawCal";
NSString *FTEyeXYDoGridKey = @"FTEyeXYDoGrid";
NSString *FTEyeXYDoTicksKey = @"FTEyeXYDoTicks";
NSString *FTEyeXYDotSizeDegKey = @"FTEyeXYDotSizeDeg";
NSString *FTEyeXYGridDegKey = @"FTEyeXYGridDeg";
NSString *FTEyeXYHScrollKey = @"FTEyeXYHScroll";
NSString *FTEyeXYMagKey = @"FTEyeXYMag";
NSString *FTEyeXYVScrollKey = @"FTEyeXYVScroll";
NSString *FTEyeXYWindowVisibleKey = @"FTEyeXYWindowVisible";
NSString *FTEyeXYEyeColorKey = @"FTEyeXYEyeColor";
NSString *FTEyeXYSamplesToSaveKey = @"FTEyeXYSamplesToSave";
NSString *FTEyeXYTickDegKey = @"FTEyeXYTickDeg";
NSString *FTEyeXYOneInNKey = @"FTEyeXYOneInN";

@implementation FTEyeXYController

- (IBAction)centerDisplay:(id)sender {

    [eyePlot centerDisplay];
}

- (IBAction)changeZoom:(id)sender {

//    [self setScaleFactor:1.0 / ([sender maxValue] - [sender floatValue] + 1)];
    [self setScaleFactor:[sender floatValue]];
}

// Prepare to be destroyed.  This odd method is needed because we increased our retainCount when we added
// ourselves to eyePlot (in windowDidLoad).  Owing to that increment, the object that created us will never
// get us to a retainCount of zero when it releases us.  For that reason, we need this method as a route
// for our creating object to get us to get us released from eyePlot and prepared to be fully released.

- (void)deactivate;
{
	[eyePlot removeDrawable:self];			// Remove ourselves, lowering our retainCount;
	[self close];							// clean up
}

- (void) dealloc;
{

     NSRect r;
    
	r = [eyePlot visibleRect];
	[[NSUserDefaults standardUserDefaults] setFloat:r.origin.x forKey:FTEyeXYHScrollKey];
	[[NSUserDefaults standardUserDefaults] setFloat:r.origin.y forKey:FTEyeXYVScrollKey];
	[fixWindowColor release];
	[calColor release];
	[unitsToDeg release];
	[degToUnits release];
	[calBezierPath release];
    [super dealloc];
}

- (IBAction) doOptions:(id)sender {
	
    [NSApp beginSheet:optionsSheet modalForWindow:[self window] modalDelegate:self
        didEndSelector:Nil contextInfo:Nil];
}

// Because we have added ourself as an LLDrawable to the eyePlot, this draw method
// will be called every time eyePlot redraws.  This allows us to put in any specific
// windows, etc that we want to display.

- (void)draw {

	long interval;
	float defaultLineWidth = [NSBezierPath defaultLineWidth];

// Draw the fixation window

	if (NSPointInRect(currentEyeDeg, eyeWindowRectDeg)) {
		[[fixWindowColor highlightWithLevel:0.90] set];
		[NSBezierPath fillRect:eyeWindowRectDeg];
	}
	[fixWindowColor set];
	[NSBezierPath setDefaultLineWidth:defaultLineWidth * 4.0]; 
	[NSBezierPath strokeRect:eyeWindowRectDeg];

// Draw the calibration for the fixation window
	
	if ([[NSUserDefaults standardUserDefaults] integerForKey:FTEyeXYDoDrawCalKey]) {
		[calColor set];
		[calBezierPath stroke];
	}
}

- (IBAction) endOptionSheet:(id)sender {

    [optionsSheet orderOut:sender];
    [NSApp endSheet:optionsSheet returnCode:1];
}

- (id) init;
{
	NSString *key;
	NSEnumerator *enumerator;
	NSArray *keyArray = [NSArray arrayWithObjects:
			FTEyeXYDoGridKey, FTEyeXYDoTicksKey, FTEyeXYSamplesToSaveKey, FTEyeXYDotSizeDegKey,
			FTEyeXYGridDegKey, FTEyeXYTickDegKey, FTEyeXYDoDotFadeKey, FTEyeXYOneInNKey, 
			nil];
		
    if ((self = [super initWithWindowNibName:@"FTEyeXYController"]) != Nil) {
 		[self setShouldCascadeWindows:NO];
        [self setWindowFrameAutosaveName:FTEyeXYAutosaveKey];
		[[NSUserDefaults standardUserDefaults] registerDefaults:
					[NSDictionary dictionaryWithObject:
					[NSArchiver archivedDataWithRootObject:[NSColor blueColor]] 
					forKey:FTEyeXYEyeColorKey]];
        [self window];							// Force the window to load now

// Bind the LLEyeXYView values to our keys

		enumerator = [keyArray objectEnumerator];
		while ((key = [enumerator nextObject]) != nil) {
			[eyePlot bind:[LLTextUtil stripPrefixAndDecapitalize:key prefix:@"FTEyeXY"]
				toObject:[NSUserDefaultsController sharedUserDefaultsController]
				withKeyPath:[NSString stringWithFormat:@"values.%@", key] 
				options:nil];
		}
		[eyePlot bind:@"eyeColor"
			toObject:[NSUserDefaultsController sharedUserDefaultsController]
			withKeyPath:@"values.FTEyeXYEyeColor" 
			options:[NSDictionary dictionaryWithObject:@"NSUnarchiveFromData" 
			forKey:@"NSValueTransformerName"]];
    }
    return self;
}

// Change the scaling factor for the view
// Because scaleUnitSquareToSize acts on the current scaling, not the original scaling,
// we have to work out the current scaling using the relative scaling of the eyePlot and
// its superview

- (void) setScaleFactor:(double)factor;
{
	float currentFactor, applyFactor;
  
	currentFactor = [eyePlot bounds].size.width / [[eyePlot superview] bounds].size.width;
	applyFactor = factor / currentFactor;
	[[scrollView contentView] scaleUnitSquareToSize:NSMakeSize(applyFactor, applyFactor)];
	[self centerDisplay:self];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] 
                forKey:FTEyeXYWindowVisibleKey];
}


// Initialization is handled through the following delegate method for our window 

- (void) windowDidLoad {

	calBezierPath = [[NSBezierPath alloc] init];
    calColor = [[NSColor colorWithDeviceRed:0.60 green:0.45 blue:0.15 alpha:1.0] retain];
    fixWindowColor = [[NSColor colorWithDeviceRed:0.00 green:0.00 blue:1.00 alpha:1.0] retain];
	unitsToDeg = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
	degToUnits = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
	[slider setFloatValue:[[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYMagKey]];
    [self setScaleFactor:[[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYMagKey]];
    [eyePlot setDrawOnlyDirtyRect:YES];
	[eyePlot addDrawable:self];
	[self changeZoom:slider];
	[eyePlot scrollPoint:NSMakePoint(
            [[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYHScrollKey], 
            [[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYVScrollKey])];
	[[self window] setFrameUsingName:FTEyeXYAutosaveKey];			// Needed when opened a second time
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FTEyeXYWindowVisibleKey]) {
        [[self window] makeKeyAndOrderFront:self];
    }
    else {
        [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    }
    [super windowDidLoad];
}

- (BOOL) windowShouldClose:(NSNotification *)aNotification {

    [[self window] orderOut:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] 
                forKey:FTEyeXYWindowVisibleKey];
    [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    return NO;
}

// Methods related to data events follow:

// Update the display of the calibration in the xy window.  We get the calibration structure
// and use it to construct crossing lines that mark �1 degree.

- (void)eyeCalibration:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	NSBezierPath *oldPath;
	LLEyeCalibrationData cal;
	
	[eventData getBytes:&cal];
	[unitsToDeg setTransformStruct:cal.calibration];
	[degToUnits setTransformStruct:cal.calibration];
	[degToUnits invert];


    oldPath = calBezierPath;
	calBezierPath = [LLEyeCalibrator bezierPathForCalibration:cal];
	[calBezierPath retain];
	[oldPath release];
}

- (void)eyeData:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
	short *pSamples;
	long samplePair, samplePairs, x, y;
	
	samplePairs = [eventData length] / (2 * sizeof(short));
	pSamples = (short *)[eventData bytes];
	for (samplePair = 0; samplePair < samplePairs; samplePair++) {
		x = *pSamples++;
		y = *pSamples++;
		currentEyeDeg = [unitsToDeg transformPoint:NSMakePoint(x, y)];
		[eyePlot addSample:currentEyeDeg];
	}
	if (!inWindow && NSPointInRect(currentEyeDeg, eyeWindowRectDeg) ||
				(inWindow && !NSPointInRect(currentEyeDeg, eyeWindowRectDeg))) {
		[eyePlot setNeedsDisplayInRect:[eyePlot pixRectFromDegRect:eyeWindowRectDeg]];
		inWindow = !inWindow;
	}
}

- (void)eyeWindow:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
	FixWindowData fixWindowData;
    
	[eventData getBytes:&fixWindowData];
	eyeWindowRectDeg = fixWindowData.windowDeg;
    [eyePlot setNeedsDisplay:YES];
}

@end
