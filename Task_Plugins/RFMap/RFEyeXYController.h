//
//  RFEyeXYController.h
//  Fixate Task
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

@interface RFEyeXYController : NSWindowController <LLDrawable> {

	NSBezierPath			*calBezierPath[kEyes];
	NSColor					*calColor[kEyes];
	NSPoint					currentEyeDeg[kEyes];
 	NSAffineTransform		*degToUnits[kEyes];
    NSMutableData			*eyeXSamples[kEyes];
    NSMutableData			*eyeYSamples[kEyes];
	NSRect					eyeWindowRectDeg;
	NSColor					*fixWindowColor;
    BOOL					inWindow;
    NSLock					*sampleLock;
    NSAffineTransform		*unitsToDeg[kEyes];
   
    IBOutlet LLEyeXYView 	*eyePlot;
    IBOutlet NSScrollView 	*scrollView;
    IBOutlet NSSlider		*slider;
    IBOutlet NSPanel		*optionsSheet;
}

- (IBAction)centerDisplay:(id)sender;
- (IBAction)changeZoom:(id)sender;
- (IBAction)doOptions:(id)sender;
- (IBAction)endOptionSheet:(id)sender;
- (void)deactivate;
- (void)setEyePlotValues;
- (void)setScaleFactor:(double)factor;

@end
