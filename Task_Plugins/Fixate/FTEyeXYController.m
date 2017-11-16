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

#define kCircleRadiusDeg    0.15
#define kCrossArmDeg        0.25
#define kLineWidthDeg        0.02

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
NSString *FTEyeXYLEyeColorKey = @"FTEyeXYLEyeColor";
NSString *FTEyeXYREyeColorKey = @"FTEyeXYREyeColor";
NSString *FTEyeXYSamplesToSaveKey = @"FTEyeXYSamplesToSave";
NSString *FTEyeXYTickDegKey = @"FTEyeXYTickDeg";
NSString *FTEyeXYOneInNKey = @"FTEyeXYOneInN";

@implementation FTEyeXYController

- (IBAction)centerDisplay:(id)sender {

    [eyePlot centerDisplay];
}

- (IBAction)changeZoom:(id)sender {

    [self setScaleFactor:[sender floatValue]];
}

// Prepare to be destroyed.  This odd method is needed because we increased our retainCount when we added
// ourselves to eyePlot (in windowDidLoad).  Owing to that increment, the object that created us will never
// get us to a retainCount of zero when it releases us.  For that reason, we need this method as a route
// for our creating object to get us to get us released from eyePlot and prepared to be fully released.

- (void)deactivate;
{
    [eyePlot removeDrawable:self];            // Remove ourselves, lowering our retainCount;
    [self close];                            // clean up
}

- (void) dealloc;
{
    long eyeIndex;
     NSRect r;
    
    r = eyePlot.visibleRect;
    [[NSUserDefaults standardUserDefaults] setFloat:r.origin.x forKey:FTEyeXYHScrollKey];
    [[NSUserDefaults standardUserDefaults] setFloat:r.origin.y forKey:FTEyeXYVScrollKey];
    [fixWindowColor release];
    for (eyeIndex = kLeftEye; eyeIndex < kEyes; eyeIndex++) {
        [unitsToDeg[eyeIndex] release];
        [degToUnits[eyeIndex] release];
        [calBezierPath[eyeIndex] release];
        [eyeXSamples[eyeIndex] release];
        [eyeYSamples[eyeIndex] release];
    }
    [super dealloc];
}

- (IBAction)doOptions:(id)sender;
{    
//    [NSApp beginSheet:optionsSheet modalForWindow:[self window] modalDelegate:self didEndSelector:nil contextInfo:nil];
    [self.window beginSheet:optionsSheet completionHandler:nil];
}

// Because we have added ourself as an LLDrawable to the eyePlot, this draw method
// will be called every time eyePlot redraws.  This allows us to put in any specific
// windows, etc that we want to display.

- (void)draw;
{
    float defaultLineWidth = [NSBezierPath defaultLineWidth];

// Draw the fixation window

    if (inWindow) {
        [[fixWindowColor highlightWithLevel:0.90] set];
        [NSBezierPath fillRect:eyeWindowRectDeg];
    }
    [fixWindowColor set];
    [NSBezierPath setDefaultLineWidth:defaultLineWidth * 4.0]; 
    [NSBezierPath strokeRect:eyeWindowRectDeg];

// Draw the calibration for the fixation window
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:FTEyeXYDoDrawCalKey]) {
        [eyePlot.eyeLColor set];
        [calBezierPath[kLeftEye] stroke];
        [eyePlot.eyeRColor set];
        [calBezierPath[kRightEye] stroke];
    }
}

- (IBAction) endOptionSheet:(id)sender;
{
    [self setEyePlotValues];
    [optionsSheet orderOut:sender];
    [NSApp endSheet:optionsSheet returnCode:1];
}

- (instancetype) init;
{
    if ((self = [super initWithWindowNibName:@"FTEyeXYController"]) != Nil) {
         [self setShouldCascadeWindows:NO];
        self.windowFrameAutosaveName = FTEyeXYAutosaveKey;
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{FTEyeXYLEyeColorKey: [NSArchiver archivedDataWithRootObject:[NSColor blueColor]]}];
        [[NSUserDefaults standardUserDefaults] registerDefaults:@{FTEyeXYREyeColorKey: [NSArchiver archivedDataWithRootObject:[NSColor redColor]]}];
        eyeXSamples[kLeftEye] = [[NSMutableData alloc] init];
        eyeYSamples[kLeftEye] = [[NSMutableData alloc] init];
        eyeXSamples[kRightEye] = [[NSMutableData alloc] init];
        eyeYSamples[kRightEye] = [[NSMutableData alloc] init];
        sampleLock = [[NSLock alloc] init];
         [self setShouldCascadeWindows:NO];
        self.windowFrameAutosaveName = @"FTXYAutosave";
        [self window];                            // Force the window to load now
    }
    return self;
}

- (void)processEyeSamplePairs;
{
    long eyeIndex;
    NSEnumerator *enumerator;
    NSArray *pairs;
    NSValue *value;
    
    for (eyeIndex = kLeftEye; eyeIndex < kEyes; eyeIndex++) {
        [sampleLock lock];
        pairs = [LLDataUtil pairXSamples:eyeXSamples[eyeIndex] withYSamples:eyeYSamples[eyeIndex]];
        [sampleLock unlock];
        if (pairs != nil) {
            enumerator = [pairs objectEnumerator];
            while (value = [enumerator nextObject]) {
                currentEyeDeg[eyeIndex] = [unitsToDeg[eyeIndex] transformPoint:value.pointValue];
                [eyePlot addSample:currentEyeDeg[eyeIndex] forEye:eyeIndex];
            }
        }
    }
    if ((!inWindow && 
         (NSPointInRect(currentEyeDeg[kLeftEye], eyeWindowRectDeg) || 
          NSPointInRect(currentEyeDeg[kRightEye], eyeWindowRectDeg))) ||
        (inWindow && (!NSPointInRect(currentEyeDeg[kLeftEye], eyeWindowRectDeg) &&
                      !NSPointInRect(currentEyeDeg[kRightEye], eyeWindowRectDeg)))) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [eyePlot setNeedsDisplayInRect:[eyePlot pixRectFromDegRect:eyeWindowRectDeg]];
        });
        inWindow = !inWindow;
    }
}

- (void)setEyePlotValues;
{    
    eyePlot.dotSizeDeg = [[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYDotSizeDegKey];
    [eyePlot setDotFade:[[NSUserDefaults standardUserDefaults] boolForKey:FTEyeXYDoDotFadeKey]];
    [eyePlot setEyeColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FTEyeXYLEyeColorKey]]
                  forEye:kLeftEye];
    [eyePlot setEyeColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:FTEyeXYREyeColorKey]]
                  forEye:kRightEye];
    [eyePlot setGrid:[[NSUserDefaults standardUserDefaults] boolForKey:FTEyeXYDoGridKey]];
    [eyePlot setGridDeg:[[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYGridDegKey]];
    [eyePlot setOneInN:[[NSUserDefaults standardUserDefaults] integerForKey:FTEyeXYOneInNKey]];
    [eyePlot setTicks:[[NSUserDefaults standardUserDefaults] boolForKey:FTEyeXYDoTicksKey]];
    [eyePlot setTickDeg:[[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYTickDegKey]];
    [eyePlot setSamplesToSave:[[NSUserDefaults standardUserDefaults] integerForKey:FTEyeXYSamplesToSaveKey]];
}


// Change the scaling factor for the view
// Because scaleUnitSquareToSize acts on the current scaling, not the original scaling,
// we have to work out the current scaling using the relative scaling of the eyePlot and
// its superview

- (void) setScaleFactor:(double)factor;
{
    float currentFactor, applyFactor;
  
    currentFactor = eyePlot.bounds.size.width / eyePlot.superview.bounds.size.width;
    applyFactor = MAX(1, factor) / currentFactor;
    [scrollView.contentView scaleUnitSquareToSize:NSMakeSize(applyFactor, applyFactor)];
    [self centerDisplay:self];
}

- (void)updateEyeCalibration:(long)eyeIndex eventData:(NSData *)eventData;
{
    LLEyeCalibrationData cal;
    
    [eventData getBytes:&cal length:sizeof(LLEyeCalibrationData)];
    
    unitsToDeg[eyeIndex].transformStruct = cal.calibration;
    degToUnits[eyeIndex].transformStruct = cal.calibration;
    [degToUnits[eyeIndex] invert];
    
    [calBezierPath[eyeIndex] autorelease];
    calBezierPath[eyeIndex] = [LLEyeCalibrator bezierPathForCalibration:cal];
    [calBezierPath[eyeIndex] retain];
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {

    [[NSUserDefaults standardUserDefaults] setObject:@YES
                forKey:FTEyeXYWindowVisibleKey];
}


// Initialization is handled through the following delegate method for our window 

- (void) windowDidLoad {

    fixWindowColor = [[NSColor colorWithDeviceRed:0.00 green:0.00 blue:1.00 alpha:1.0] retain];
    unitsToDeg[kLeftEye] = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
    unitsToDeg[kRightEye] = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
    degToUnits[kLeftEye] = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
    degToUnits[kRightEye] = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
    [self setScaleFactor:[[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYMagKey]];
    [self setEyePlotValues];
    [eyePlot setDrawOnlyDirtyRect:YES];
    [eyePlot addDrawable:self];
    [self changeZoom:slider];
    [eyePlot scrollPoint:NSMakePoint([[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYHScrollKey], 
                                     [[NSUserDefaults standardUserDefaults] floatForKey:FTEyeXYVScrollKey])];
    
    [self.window setFrameUsingName:@"FTXYAutosave"];            // Needed when opened a second time
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FTEyeXYWindowVisibleKey]) {
        [self.window makeKeyAndOrderFront:self];
    }
    else {
        [NSApp addWindowsItem:self.window title:self.window.title filename:NO];
    }
    [scrollView setPostsBoundsChangedNotifications:YES];
    [super windowDidLoad];
}

- (BOOL) windowShouldClose:(NSNotification *)aNotification {

    [self.window orderOut:self];
    [[NSUserDefaults standardUserDefaults] setObject:@NO
                forKey:FTEyeXYWindowVisibleKey];
    [NSApp addWindowsItem:self.window title:self.window.title filename:NO];
    return NO;
}

// Methods related to data events follow:

// Update the display of the calibration in the xy window.  We get the calibration structure
// and use it to construct crossing lines that mark ±1 degree.


- (void)eyeLeftCalibration:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [self updateEyeCalibration:kLeftEye eventData:eventData];
}

- (void)eyeRightCalibration:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [self updateEyeCalibration:kRightEye eventData:eventData];
}

- (void)eyeLXData:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [sampleLock lock];
    [eyeXSamples[kLeftEye] appendData:eventData];
    [sampleLock unlock];
    //    [self processEyeSamplePairs];
}

- (void)eyeLYData:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [sampleLock lock];
    [eyeYSamples[kLeftEye] appendData:eventData];
    [sampleLock unlock];
    [self processEyeSamplePairs];
}

- (void)eyeRXData:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [sampleLock lock];
    [eyeXSamples[kRightEye] appendData:eventData];
    [sampleLock unlock];
    //    [self processEyeSamplePairs];
}

- (void)eyeRYData:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    [sampleLock lock];
    [eyeYSamples[kRightEye] appendData:eventData];
    [sampleLock unlock];
    [self processEyeSamplePairs];
}

- (void)eyeWindow:(NSData *)eventData eventTime:(NSNumber *)eventTime;
{
    FixWindowData fixWindowData;
    
    [eventData getBytes:&fixWindowData length:sizeof(FixWindowData)];
    eyeWindowRectDeg = fixWindowData.windowDeg;
    dispatch_async(dispatch_get_main_queue(), ^{
        [eyePlot setNeedsDisplay:YES];
    });
}


@end
