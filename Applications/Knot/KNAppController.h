//
//  KNAppController.h
//  Knot
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003-2007. All rights reserved.
//
#import <Appkit/NSApplication.h>
#import "KNSummaryController.h"
#include <Lablib/LLMatlabEngine.h>

typedef uint16_t char16_t;                  // Matlab engine uses a type that isn't defined by CLANG
#include <engine.h>

@interface KNAppController : NSApplication <NSApplicationDelegate> {

	NSWindowController		*aboutPanel;					// About this application panel 
    LLTaskPlugIn 			*currentTask;
    
	LLDataDoc				*dataDoc;						// LLDataDoc for data events
	id<LLIODevice>			dataSource;
	LLUserDefaults			*defaults;
	LLDataDeviceController	*dataDeviceController;
	LLBinocCalibrator		*eyeCalibration;
	BOOL					initialized;
    LLMatlabEngine          *matlabEngine;
	LLMouseDataDevice		*mouseDataDevice;
	LLMonitorController		*monitorController;
	LLPluginController		*pluginController;
    LLNE500Pump             *rewardPump;
	LLSettingsController	*settingsController;
    LLSockets               *socket;
	LLStimWindow			*stimWindow;
    KNSummaryController		*summaryController;
	LLSynthDataDevice		*synthDataDevice;
	
	IBOutlet NSMenuItem		*recordDontRecordMenuItem;		// Menu item for recording or not
	IBOutlet NSMenu			*taskMenu;
}

- (void)activateCurrentTask;
- (void)configurePlugins;
- (void)deactivateCurrentTask;
- (void)loadDataDevicePlugins;
- (void)postDataParamEvents;

- (IBAction)changeDataSource:(id)sender;
- (IBAction)changeSettings:(id)sender;
- (IBAction)doPluginController:(id)sender;
- (IBAction)doTaskMenu:(id)sender;
- (IBAction)recordDontRecord:(id)sender;
- (IBAction)showAboutPanel:(id)sender;
- (IBAction)showDisplayCalibratorPanel:(id)sender;
- (IBAction)showEyeCalibratorPanel:(id)sender;
- (IBAction)showMatlabWindow:(id)sender;
- (IBAction)showReportPanel:(id)sender;
- (IBAction)showRewardPumpWindow:(id)sender;
- (IBAction)showSocketsWindow:(id)sender;

@end
