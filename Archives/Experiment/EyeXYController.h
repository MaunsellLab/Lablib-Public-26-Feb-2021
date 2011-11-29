//
//  EyeXYController.h
//  Experiment
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

extern NSString	*eyeXYColorKey;
extern NSString *eyeXYHScrollKey;
extern NSString	*eyeXYMagKey;
extern NSString *eyeXYVScrollKey;
extern NSString	*eyeXYWindowVisibleKey;
extern NSString *fadeDotsKey;
extern NSString *dotLifeSKey;
extern NSString *dotSizeDegKey;
extern NSString *oneInNKey;

@interface EyeXYController : NSWindowController <LLDrawable> {

@private
	NSBezierPath			*calBezierPath;
	NSColor					*calColor;
	NSPoint					currentEyeDeg;
 	NSAffineTransform		*degToUnits;
	NSRect					eyeWindowRectDeg;
	NSColor					*fixWindowColor;
	BOOL					inTrial;
	NSColor					*respWindowColor;
	NSRect					respWindowRectDeg[2];
    long 					samplesToSave;
	TrialDesc				trial;
 	NSAffineTransform		*unitsToDeg;
   
	IBOutlet NSButton		*doGridButton;
	IBOutlet NSButton		*doTicksButton;
    IBOutlet NSTextField 	*dotLifeField;
    IBOutlet NSTextField 	*dotSizeField;
	IBOutlet NSButton		*drawCalButton;
    IBOutlet NSColorWell 	*eyeColorWell;
    IBOutlet LLEyeXYView 	*eyePlot;
    IBOutlet NSButton		*fadeDotsButton;
	IBOutlet NSTextField	*gridDegField;
    IBOutlet NSTextField 	*oneInNField;
    IBOutlet NSScrollView 	*scrollView;
    IBOutlet NSSlider		*slider;
	IBOutlet NSTextField	*tickDegField;
    IBOutlet NSPanel		*optionsSheet;
}

- (IBAction)centerDisplay:(id)sender;
- (IBAction)changeDoGrid:(id)sender;
- (IBAction)changeDoTicks:(id)sender;
- (IBAction)changeDotLife:(id)sender;
- (IBAction)changeDotSize:(id)sender;
- (IBAction)changeDrawCal:(id)sender;
- (IBAction)changeEyeColor:(id)sender;
- (IBAction)changeFadeDots:(id)sender;
- (IBAction)changeGridDeg:(id)sender;
- (IBAction)changeOneInN:(id)sender;
- (IBAction)changeTickDeg:(id)sender;
- (IBAction)changeZoom:(id)sender;
- (IBAction)doOptions:(id)sender;
- (IBAction)endOptionSheet:(id)sender;
- (void)handleScrollChange:(NSNotification *)note;
- (void)setEyePlotValues;
- (void)setScaleFactor:(double)factor;

@end
