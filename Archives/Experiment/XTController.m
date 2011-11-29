//
//  XTController.m
//  Experiment
//
//  Window with summary information trial events.
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#define NoGlobals

#import "Experiment.h"
#import "XTController.h"

#define kPlotBinsDefault	10
#define	kXTickSpacing		100

NSString *trialWindowVisibleKey = @"Trial Window Visible";
NSString *trialWindowZoomKey = @"Trial Window Zoom";

@implementation XTController

- (IBAction)changeFreeze:(id)sender {

    [xtView setFreeze:[sender intValue]];
    [sender setTitle:([sender intValue]) ? @"Unfreeze" : @"Freeze"];
}

- (IBAction)changeZoom:(id)sender {

    long zoomValue;
    
    zoomValue = [[sender selectedCell] tag];
    [self setScaleFactor:zoomValue / 100.0];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:zoomValue] 
                forKey:trialWindowZoomKey];
}

- (id)init {

    if ((self = [super initWithWindowNibName:@"XTController"]) != Nil) {
        [self setWindowFrameAutosaveName:@"XTController"];
        [self window];							// Force the window to load now
    }
    return self;
}

- (void) positionZoomButton {

    NSRect scrollerRect, buttonRect;
    
    scrollerRect = [[scrollView horizontalScroller] frame];
    scrollerRect.size.width = [scrollView frame].size.width - scrollerRect.size.height - 8;
    NSDivideRect(scrollerRect, &buttonRect, &scrollerRect, 60.0, NSMaxXEdge);
    [[scrollView horizontalScroller] setFrame:scrollerRect];
    [[scrollView horizontalScroller] setNeedsDisplay:YES];
    buttonRect.origin.y += buttonRect.size.height;				// Offset because the clipRect is flipped
    buttonRect.origin = [[[self window] contentView] convertPoint:buttonRect.origin fromView:scrollView];
    [zoomButton setFrame:NSInsetRect(buttonRect, 1.0, 1.0)];
    [zoomButton setNeedsDisplay:YES];
}

- (void) setScaleFactor:(double)factor {

    double delta;
    NSSize	baseViewSize;
    static double scaleFactor = 1.0;
  
    if (scaleFactor != factor) {
        delta = factor / scaleFactor;
        [[scrollView contentView] scaleUnitSquareToSize:NSMakeSize(delta, delta)];
        scaleFactor = factor;
        [self positionZoomButton];
        [scrollView display];
   }
   
// Always set the maxSize, because this is called at initialization

    baseViewSize = [xtView sizePix];
    [[self window] setMaxSize:NSMakeSize(baseViewSize.width * factor + staticWindowFrame.width, 
            baseViewSize.height * factor + staticWindowFrame.height)];
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {
	
	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] 
                forKey:trialWindowVisibleKey];
}

- (void) windowDidLoad {

    long index, defaultZoom, deltaHeight, deltaWidth;
    NSSize baseScrollFrameSize, windowFrameSize, baseViewSize;
    
// Calculate the base (1x scaling) content size for the window.  We will use this for
// setting the maximum zoom size when the scale changes.

    [xtView setSamplePeriodMS:kSamplePeriodMS spikeChannels:kSpikeChannels spikeTickPerMS:kTimestampTickMS];
    [xtView setDurationS:5.0];   // ?? This should be controlled by a dialog and saved in preferences. 
    
    baseViewSize = [xtView sizePix];
    baseScrollFrameSize = [NSScrollView frameSizeForContentSize:baseViewSize
            hasHorizontalScroller:YES hasVerticalScroller:YES borderType:[scrollView borderType]];
    deltaWidth = baseScrollFrameSize.width - [scrollView frame].size.width;		// allow for frame's current size
    deltaHeight = baseScrollFrameSize.height - [scrollView frame].size.height;
    windowFrameSize = [[self window] frame].size;
    staticWindowFrame = NSMakeSize(windowFrameSize.width + deltaWidth - baseViewSize.width, 
               windowFrameSize.height + deltaHeight - baseViewSize.height);

    [[zoomButton cell] setBordered:NO];
    [[zoomButton cell] setBezeled:YES];
    [[zoomButton cell] setFont:[NSFont labelFontOfSize:10.0]];
    defaultZoom = [[NSUserDefaults standardUserDefaults] integerForKey:trialWindowZoomKey];
    for (index = 0; index < [[zoomButton itemArray] count]; index++) {
        if ([[zoomButton itemAtIndex:index] tag] == defaultZoom) {
            [zoomButton selectItemAtIndex:index];
            [self setScaleFactor:defaultZoom / 100.0];
            break;
        }
    }
        
    if ([[NSUserDefaults standardUserDefaults] boolForKey:trialWindowVisibleKey]) {
        [[self window] makeKeyAndOrderFront:self];
    }
    else {
        [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    }
    
    [self positionZoomButton];							// position zoom must be after visible
    [super windowDidLoad];
}

// We use a delegate method to detect when the window has resized, and 
// adjust the postion of the zoom button when it does.

- (void) windowDidResize:(NSNotification *)aNotification {

	[self positionZoomButton];
}

- (BOOL) windowShouldClose:(NSNotification *)aNotification {

    [[self window] orderOut:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] 
                forKey:trialWindowVisibleKey];
    [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    return NO;
}

// Methods related to data events follow:

- (void)eyeWindow:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	FixWindowData fixWindowData;
    
	[eventData getBytes:&fixWindowData];
    [xtView eyeRect:fixWindowData.windowUnits time:[eventTime longValue]];
}

- (void)fixate:(NSData *)eventData eventTime:(NSNumber *)eventTime {
    
    [xtView eventName:@"Fixate" eventTime:eventTime];
}

- (void)leverDown:(NSData *)eventData eventTime:(NSNumber *)eventTime {
    
    [xtView eventName:@"Lever" eventTime:eventTime];
}

- (void)reset:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    [xtView reset:[eventTime longValue]];
}

- (void) sampleZero:(NSData *)eventData eventTime:(NSNumber *)eventTime {

   [xtView sampleZeroTimeMS:[eventTime longValue]];
}

- (void)sample01:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    short samples[2];
    
	[eventData getBytes:&samples];
    [xtView sampleChannel:0 value:samples[0]];
    [xtView sampleChannel:1 value:samples[1]];
}

- (void)spike:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    TimestampData spike;
    
	[eventData getBytes:&spike];
    [xtView spikeChannel:spike.channel time:spike.time];
}

- (void) spikeZero:(NSData *)eventData eventTime:(NSNumber *)eventTime {

   [xtView spikeZeroTimeMS:[eventTime longValue]];
}

- (void)stimulusOff:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	[xtView stimulusBarColor:[NSColor whiteColor] eventTime:eventTime];
}

- (void)stimulusOn:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	[xtView stimulusBarColor:[NSColor grayColor] eventTime:eventTime];
}

- (void) trialEnd:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    long eotCode;
    
	[eventData getBytes:&eotCode];
	[xtView eventName:[LLStandardDataEvents trialEndName:eotCode] eventTime:eventTime];
}

- (void) trialStart:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    [xtView eventName:@"Trial start" eventTime:eventTime];
}

@end
