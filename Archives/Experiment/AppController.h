//
//  AppController.h
//  Experiment
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "EyeXYController.h"
#import "MessageController.h"

@interface AppController : NSObject {
@private
	NSWindowController		*aboutPanel;					// About this application panel 
    NSWindowController 		*behaviorController;
    BOOL 					collectorShouldTerminate;
    BOOL 					collectorDidTerminate;
	LLIODeviceController 	*dataSourceController;
    StateSystem 			*experStateSystem;
    EyeXYController			*eyeXYController;				// Eye position display
    MessageController		*messageController;
	LLSettingsController	*settingsController;
    NSWindowController 		*spikeController;
    NSWindowController 		*summaryController;
    NSWindowController 		*xtController;
	
	IBOutlet NSPanel		*controlPanel;					// NSPanel for controls
	IBOutlet NSTextField	*fileNameDisplay;
	IBOutlet NSButton		*resetButton;
	IBOutlet NSMenuItem		*recordDontRecordMenuItem;		// Menu item for recording or not
	IBOutlet NSButton		*runStopButton;
	IBOutlet NSMenuItem		*runStopMenuItem;				// Menu item for running and stopping
	IBOutlet NSButton		*saveButton;
}

extern AppController		*appController;

- (void)collectData;
- (void)doJuiceOff;

- (IBAction)changeDataSource:(id)sender;
- (IBAction)changeSettings:(id)sender;
- (IBAction)doJuice:(id)sender;
- (IBAction)doRunStop:(id)sender;
- (IBAction)recordDontRecord:(id)sender;
- (IBAction)resetRequest:(id)sender;
- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showDisplayCalibratorPanel:(id)sender;
- (IBAction)showEyeCalibratorPanel:(id)sender;
- (IBAction)showReportPanel:(id)sender;

@end
