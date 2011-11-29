//
//  EyeXYController.m
//  Experiment
//
//  XY Display of eye position.
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#define NoGlobals

#import "Experiment.h"
#import "EyeXYController.h"

#define kCircleRadiusDeg	0.15
#define kCrossArmDeg		0.25
#define kLineWidthDeg		0.02

NSString *eyeXYDoGridKey = @"Eye XY Do Grid";
NSString *eyeXYDoTicksKey = @"Eye XY Do Ticks";
NSString *eyeXYDrawCalKey = @"Eye XY Draw Calibration";
NSString *eyeXYGridDegKey = @"Eye XY Grid Deg";
NSString *eyeXYHScrollKey = @"Eye XY H Scroll";
NSString *eyeXYMagKey = @"Eye XY Magnification";
NSString *eyeXYVScrollKey = @"Eye XY V Scroll";
NSString *eyeXYWindowVisibleKey = @"Eye XY Window Visible";
NSString *eyeXYColorKey = @"Eye XY Eye Color";
NSString *eyeXYTickDegKey = @"Eye XY Tick Deg";
NSString *dotLifeSKey = @"Eye Dot Life";
NSString *dotSizeDegKey = @"Eye Dot Size";
NSString *fadeDotsKey = @"Fade Eye Dots";
NSString *oneInNKey = @"One In N Eye Dot";

@implementation EyeXYController

- (IBAction)centerDisplay:(id)sender {

    [eyePlot centerDisplay];
}

- (IBAction)changeDoGrid:(id)sender {

	[eyePlot setGrid:[doGridButton intValue]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[doGridButton intValue]] 
				forKey:eyeXYDoGridKey];
}

- (IBAction)changeDoTicks:(id)sender {

	[eyePlot setTicks:[doTicksButton intValue]];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:[doTicksButton intValue]] 
				forKey:eyeXYDoTicksKey];
}

- (IBAction)changeDotLife:(id)sender {

	[[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:dotLifeSKey];
	[eyePlot setSamplesToSave:1000.0 * [sender floatValue] / kSamplePeriodMS];
}

- (IBAction)changeDotSize:(id)sender {

	[eyePlot setDotSizeDeg:[sender floatValue]];
	[[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:dotSizeDegKey];
}

- (IBAction)changeDrawCal:(id)sender {

	[[NSUserDefaults standardUserDefaults] setBool:[sender intValue] forKey:eyeXYDrawCalKey];
}

- (IBAction)changeEyeColor:(id)sender {

    NSColor *color;
    
    color = [sender color];
	[eyePlot setEyeColor:color];
	[[NSUserDefaults standardUserDefaults] 
            setObject:[NSArchiver archivedDataWithRootObject:color] forKey:eyeXYColorKey];
}

- (IBAction)changeFadeDots:(id)sender {

	[eyePlot setDotFade:[sender intValue]];
    [[NSUserDefaults standardUserDefaults] setBool:([sender intValue] == NSOnState) 
                                forKey:fadeDotsKey];
}

- (IBAction)changeGridDeg:(id)sender {

	[eyePlot setGridDeg:[sender floatValue]];
    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:eyeXYGridDegKey];
}

- (IBAction)changeOneInN:(id)sender {

	[eyePlot setOneInN:[sender intValue]];
	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:oneInNKey];
}

- (IBAction)changeTickDeg:(id)sender {

	[eyePlot setTickDeg:[sender floatValue]];
    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:eyeXYTickDegKey];
}

- (IBAction)changeZoom:(id)sender {

//	[eyePlot centerDisplay];
    [self setScaleFactor:1.0 / ([sender maxValue] - [sender floatValue] + 1)];
	// ??? Move setScaleFactor into here?
}

- (void) dealloc {

	[fixWindowColor release];
	[respWindowColor release];
	[calColor release];
	[unitsToDeg release];
	[degToUnits release];
	[calBezierPath release];
    [super dealloc];
}

- (IBAction) doOptions:(id)sender {

    NSUserDefaults *defaults;

    defaults = [NSUserDefaults standardUserDefaults];
    [dotLifeField setFloatValue:[defaults floatForKey:dotLifeSKey]];
    [dotSizeField setFloatValue:[defaults floatForKey:dotSizeDegKey]];
    [oneInNField setIntValue:[defaults integerForKey:oneInNKey]];
    [fadeDotsButton setIntValue:[defaults integerForKey:fadeDotsKey]];
	
    [doGridButton setIntValue:[defaults integerForKey:eyeXYDoGridKey]];
    [gridDegField setFloatValue:[defaults floatForKey:eyeXYGridDegKey]];
    [doTicksButton setIntValue:[defaults integerForKey:eyeXYDoTicksKey]];
    [tickDegField setFloatValue:[defaults floatForKey:eyeXYTickDegKey]];
    [drawCalButton setIntValue:[defaults integerForKey:eyeXYDrawCalKey]];
	
	[eyeColorWell setColor:[NSUnarchiver 
                unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] 
                objectForKey:eyeXYColorKey]]];

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

// Draw the response windows
	
	for (interval = 0; interval < 2; interval++) {
		if (NSPointInRect(currentEyeDeg, respWindowRectDeg[interval])) {
			[[respWindowColor highlightWithLevel:0.80] set];
			[NSBezierPath fillRect:respWindowRectDeg[interval]];
		}
		[respWindowColor set];
		if (inTrial && (interval == trial.stimulusInterval)) {
			[NSBezierPath setDefaultLineWidth:defaultLineWidth * 4.0]; 
		}
		else {
			[NSBezierPath setDefaultLineWidth:defaultLineWidth];
		}
		[NSBezierPath strokeRect:respWindowRectDeg[interval]];
	}
	[NSBezierPath setDefaultLineWidth:defaultLineWidth];

// Draw the calibration for the fixation window
	
	if ([[NSUserDefaults standardUserDefaults] integerForKey:eyeXYDrawCalKey]) {
		[calColor set];
		[calBezierPath stroke];
	}
}

- (IBAction) endOptionSheet:(id)sender {

    NSUserDefaults *defaults;

    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithFloat:[dotLifeField floatValue]] forKey:dotLifeSKey];
    [defaults setObject:[NSNumber numberWithFloat:[dotSizeField floatValue]] forKey:dotSizeDegKey];
    [defaults setObject:[NSNumber numberWithInt:[oneInNField intValue]] forKey:oneInNKey];
    [defaults setObject:[NSNumber numberWithInt:[fadeDotsButton intValue]] forKey:fadeDotsKey];
    [defaults setObject:[NSNumber numberWithInt:[doTicksButton intValue]] forKey:eyeXYDoTicksKey];
    [defaults setObject:[NSNumber numberWithInt:[doGridButton intValue]] forKey:eyeXYDoGridKey];
    [defaults setObject:[NSNumber numberWithFloat:[tickDegField floatValue]] forKey:eyeXYTickDegKey];
    [defaults setObject:[NSNumber numberWithFloat:[gridDegField floatValue]] forKey:eyeXYGridDegKey];


	[self setEyePlotValues];
    [optionsSheet orderOut:sender];
    [NSApp endSheet:optionsSheet returnCode:1];
}

// Update the scroll position, so it is available when we next launch

- (void) handleScrollChange:(NSNotification *)note {

    NSRect r;
    
    r = [eyePlot visibleRect];
	[[NSUserDefaults standardUserDefaults] setFloat:r.origin.x forKey:eyeXYHScrollKey];
	[[NSUserDefaults standardUserDefaults] setFloat:r.origin.y forKey:eyeXYVScrollKey];
}

- (id) init {

    if ((self = [super initWithWindowNibName:@"EyeXYController"]) != Nil) {
        [self setWindowFrameAutosaveName:@"EyeXYController"];
        [self window];							// Force the window to load now
    }
    return self;
}

- (void)setEyePlotValues {

	[eyePlot setDotSizeDeg:[[NSUserDefaults standardUserDefaults] floatForKey:dotSizeDegKey]];
	[eyePlot setDotFade:[[NSUserDefaults standardUserDefaults] boolForKey:fadeDotsKey]];
    [eyePlot setEyeColor:[NSUnarchiver 
                unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] 
                objectForKey:eyeXYColorKey]]];
	[eyePlot setGrid:[[NSUserDefaults standardUserDefaults] boolForKey:eyeXYDoGridKey]];
	[eyePlot setGridDeg:[[NSUserDefaults standardUserDefaults] floatForKey:eyeXYGridDegKey]];
	[eyePlot setOneInN:[[NSUserDefaults standardUserDefaults] integerForKey:oneInNKey]];
	[eyePlot setTicks:[[NSUserDefaults standardUserDefaults] boolForKey:eyeXYDoTicksKey]];
	[eyePlot setTickDeg:[[NSUserDefaults standardUserDefaults] floatForKey:eyeXYTickDegKey]];
	[eyePlot setSamplesToSave:(1000.0 * [[NSUserDefaults standardUserDefaults] floatForKey:dotLifeSKey] / kSamplePeriodMS)];
}

- (void) setScaleFactor:(double)factor {

    double delta;
    static double scaleFactor = 1.0;
  
    if (scaleFactor != factor) {
        delta = factor / scaleFactor;
        [[scrollView contentView] scaleUnitSquareToSize:NSMakeSize(delta, delta)];
        scaleFactor = factor;
        [scrollView display];
		[[NSUserDefaults standardUserDefaults] setFloat:[slider floatValue] forKey:eyeXYMagKey];
   }
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] 
                forKey:eyeXYWindowVisibleKey];
}

// Initialization is handled through the following delegate method for our window 

- (void) windowDidLoad {

	calBezierPath = [[NSBezierPath alloc] init];
    calColor = [[NSColor colorWithDeviceRed:0.60 green:0.45 blue:0.15 alpha:1.0] retain];
    fixWindowColor = [[NSColor colorWithDeviceRed:0.00 green:0.00 blue:1.00 alpha:1.0] retain];
    respWindowColor = [[NSColor colorWithDeviceRed:0.95 green:0.55 blue:0.50 alpha:1.0] retain];
	unitsToDeg = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
	degToUnits = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
	[slider setFloatValue:[[NSUserDefaults standardUserDefaults] floatForKey:eyeXYMagKey]];
    [self setScaleFactor:[[NSUserDefaults standardUserDefaults] floatForKey:eyeXYMagKey]];
	[self setEyePlotValues]; 
    [eyePlot addDrawable:self];
	[self changeZoom:slider];
	[eyePlot scrollPoint:NSMakePoint(
            [[NSUserDefaults standardUserDefaults] floatForKey:eyeXYHScrollKey], 
            [[NSUserDefaults standardUserDefaults] floatForKey:eyeXYVScrollKey])];
	
    if ([[NSUserDefaults standardUserDefaults] boolForKey:eyeXYWindowVisibleKey]) {
        [[self window] makeKeyAndOrderFront:self];
    }
    else {
        [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    }

    [scrollView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScrollChange:)
        name:@"NSViewBoundsDidChangeNotification" object:Nil];
    
    [super windowDidLoad];
}

- (BOOL) windowShouldClose:(NSNotification *)aNotification {

    [[self window] orderOut:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] 
                forKey:eyeXYWindowVisibleKey];
    [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    return NO;
}

// Methods related to data events follow:

// Update the display of the calibration in the xy window.  We get the calibration structure
// and use it to construct crossing lines that mark ±1 degree.

- (void)eyeCalibration:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	long index;
	float factor, xSum, ySum;
	LLEyeCalibrationData cal;
	NSPoint xVector, yVector, actualDeg;
	NSSize xVectorSize, yVectorSize;
	NSPoint c, a;
	
	[eventData getBytes:&cal];
	[unitsToDeg setTransformStruct:cal.calibration];
	[degToUnits setTransformStruct:cal.calibration];
	[degToUnits invert];

// Draw bars to show the current calibration.  We construct a parallogram that reflect
// the X and Y scaling of where the actually fixation points are (when plotted in  
// isotropic degree space).
	

	[calBezierPath removeAllPoints];
	if (cal.offsetSizeDeg == 0) {
		return;
	}

// Make the offsets that are being used for calibration with circles

	[calBezierPath setLineWidth:kLineWidthDeg];							// line width in degrees
	c = cal.currentOffsetDeg;
	[calBezierPath moveToPoint:NSMakePoint(kCircleRadiusDeg, 0)];		// move so we don't draw a line
	[calBezierPath appendBezierPathWithArcWithCenter:NSMakePoint(0, 0)
					radius:kCircleRadiusDeg startAngle:0.0 endAngle:360.0];
	[calBezierPath moveToPoint:NSMakePoint(-2 * c.x + kCircleRadiusDeg, 0)];
	[calBezierPath appendBezierPathWithArcWithCenter:NSMakePoint(-2 * c.x, 0)
					radius:kCircleRadiusDeg startAngle:0.0 endAngle:360.0];
	[calBezierPath moveToPoint:NSMakePoint(-2 * c.x + kCircleRadiusDeg, -2 * c.y)];
	[calBezierPath appendBezierPathWithArcWithCenter:NSMakePoint(-2 * c.x, -2 * c.y)
					radius:kCircleRadiusDeg startAngle:0.0 endAngle:360.0];
	[calBezierPath moveToPoint:NSMakePoint(kCircleRadiusDeg, -2 * c.y)];
	[calBezierPath appendBezierPathWithArcWithCenter:NSMakePoint(0, -2 * c.y)
					radius:kCircleRadiusDeg startAngle:0.0 endAngle:360.0];
	
// Mark the sites that the eye actually hits with small crosses

	for (index = 0; index < kOffsets; index++) {
		actualDeg = [unitsToDeg transformPoint:cal.actualUnits[index]];
		[calBezierPath moveToPoint:NSMakePoint(actualDeg.x - kCrossArmDeg, actualDeg.y)];	
		[calBezierPath lineToPoint:NSMakePoint(actualDeg.x + kCrossArmDeg, actualDeg.y)];	
		[calBezierPath moveToPoint:NSMakePoint(actualDeg.x, actualDeg.y - kCrossArmDeg)];	
		[calBezierPath lineToPoint:NSMakePoint(actualDeg.x, actualDeg.y + kCrossArmDeg)];
	}

// Make a parallogram to show the distortion in the affine transform.  We make the area equal
// to the area bounded by the offset target locations.

// Note, this is currently a rough approximation.  The correct parallelogram area is bh,
// where b is the base and h is the height normal to the base

	xVectorSize = [degToUnits transformSize:NSMakeSize(1.0, 0.0)];
	yVectorSize = [degToUnits transformSize:NSMakeSize(0.0, 1.0)];
	xVector.x = xVectorSize.width;
	xVector.y = xVectorSize.height;
	yVector.x = yVectorSize.width;
	yVector.y = yVectorSize.height;

	factor = (cal.offsetSizeDeg * cal.offsetSizeDeg) / 
				(sqrt(xVector.x * xVector.x + xVector.y * xVector.y) *
				sqrt(yVector.x * yVector.x + yVector.y * yVector.y));
	factor = sqrt(factor) / 2;					// convert areal to linear and get half side
	xVector.x *= factor;
	xVector.y *= factor;
	yVector.x *= factor;
	yVector.y *= factor;
	
	for (index = xSum = ySum = 0; index < kOffsets; index++) {
		xSum += cal.actualUnits[index].x;
		ySum += cal.actualUnits[index].y;
	}
	a = [unitsToDeg transformPoint:NSMakePoint(xSum / kOffsets, ySum / kOffsets)];
	[calBezierPath moveToPoint:
				NSMakePoint(a.x - xVector.x - yVector.x, a.y - xVector.y - yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x - xVector.x + yVector.x, a.y - xVector.y + yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x + xVector.x + yVector.x, a.y + xVector.y + yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x + xVector.x - yVector.x, a.y + xVector.y - yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x - xVector.x - yVector.x, a.y - xVector.y - yVector.y)];
}

- (void)eyeWindow:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	FixWindowData fixWindowData;
    
	[eventData getBytes:&fixWindowData];
	eyeWindowRectDeg = fixWindowData.windowDeg;
    [eyePlot setNeedsDisplay:YES];
}

- (void) responseWindow:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	FixWindowData respWindowData;
    
	[eventData getBytes:&respWindowData];
	respWindowRectDeg[respWindowData.index] = respWindowData.windowDeg;
    [eyePlot setNeedsDisplay:YES];
}

- (void) sample01:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	short samples[2];
	
	[eventData getBytes:&samples];
	currentEyeDeg = [unitsToDeg transformPoint:NSMakePoint(samples[0], samples[1])];
	[eyePlot addSample:currentEyeDeg];
}

- (void) trial:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	[eventData getBytes:&trial];
    inTrial = YES;
}

- (void) trialEnd:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	inTrial = NO;
}

@end
