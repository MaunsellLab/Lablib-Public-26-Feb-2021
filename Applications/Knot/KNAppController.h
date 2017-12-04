//
//  KNAppController.h
//  Knot
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003-2017. All rights reserved.
//
#import <Appkit/NSApplication.h>
#import <Lablib/LLGitController.h>
#import "KNSummaryController.h"
#import "LLMatlabEngine.h"

@interface KNAppController : NSApplication <NSApplicationDelegate> {

	NSWindowController		*aboutPanel;					// About this application panel 
    LLTaskPlugIn 			*currentTask;
    LLDataDoc				*dataDoc;						// LLDataDoc for data events
	LLUserDefaults			*defaults;
	LLDataDeviceController	*dataDeviceController;
	LLBinocCalibrator		*eyeCalibration;
	BOOL					initialized;
    LLMatlabEngine          *matlabEngine;
	LLMouseDataDevice		*mouseDataDevice;
	LLMonitorController		*monitorController;
    LLNIDAQ                 *nidaq;
	LLPluginController		*pluginController;
    LLNE500Pump             *rewardPump;
    LLSockets               *socket;
	LLStimWindow			*stimWindow;
    KNSummaryController		*summaryController;
	LLSynthDataDevice		*synthDataDevice;
	
    IBOutlet NSTextField    *calibration0Text;
    IBOutlet NSTextField    *calibration1Text;
    IBOutlet NSTextField    *pluginDefaultDataText;
    IBOutlet NSMenuItem     *pluginPrefMenuItem;
    IBOutlet NSWindow       *preferencesDialog;
	IBOutlet NSMenuItem		*recordDontRecordMenuItem;		// Menu item for recording or not
	IBOutlet NSMenu			*taskMenu;
    IBOutlet NSPopUpButton  *soundTypeMenu;
}

@property (NS_NONATOMIC_IOSONLY, copy) NSString *currentDataKey;
@property (NS_NONATOMIC_IOSONLY, retain) LLGitController *gitController;

- (void)activateCurrentTask;
- (void)configurePlugins;
- (void)deactivateCurrentTask;
- (void)loadDataDevicePlugins;
- (void)postDataParamEvents;

- (IBAction)changeDataSource:(id)sender;
- (IBAction)doAO0CalibrationBrowse:(id)sender;
- (IBAction)doAO1CalibrationBrowse:(id)sender;
- (void)doCalibrationBrowseForChannel:(long)channel;
- (IBAction)doPluginController:(id)sender;
- (IBAction)doPluginDefaultData:(id)sender;
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
