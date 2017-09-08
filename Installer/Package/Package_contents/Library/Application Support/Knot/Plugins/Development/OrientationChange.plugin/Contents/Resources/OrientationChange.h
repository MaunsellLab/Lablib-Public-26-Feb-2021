//
//  OrientationChange.h
//  OrientationChange
//
//  Copyright 2006. All rights reserved.
//

#import "OC.h"
#import "OCStateSystem.h"
#import "OCEyeXYController.h"
#import "OCDigitalOut.h"

@interface OrientationChange:LLTaskPlugIn {

	NSMenuItem				*actionsMenuItem;
    NSWindowController 		*behaviorController;
	LLControlPanel			*controlPanel;
	NSPoint					currentEyeUnits;
    OCEyeXYController		*eyeXYController;				// Eye position display
	NSMenuItem				*settingsMenuItem;
    NSWindowController 		*summaryController;
	LLTaskStatus			*taskStatus;
    NSWindowController 		*xtController;

    IBOutlet NSMenu			*actionsMenu;
    IBOutlet NSMenu			*settingsMenu;
	IBOutlet NSMenuItem		*runStopMenuItem;
}
    
- (IBAction)doFixSettings:(id)sender;
- (IBAction)doJuice:(id)sender;

//- (OCDigitalOut *)digitalOut;
- (void)doJuiceOff;
- (IBAction)doReset:(id)sender;
- (IBAction)doRFMap:(id)sender;
- (IBAction)doRunStop:(id)sender;
- (IBAction)doStimSettings:(id)sender;
- (OCStimuli2 *)stimuli;
- (void)updateChangeTable;

@end
