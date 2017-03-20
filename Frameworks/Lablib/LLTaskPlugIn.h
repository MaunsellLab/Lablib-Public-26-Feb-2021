//
//  LLTaskPlugIn.h
//  Lablib
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "LLDataDoc.h"
#import "LLDisplays.h"
#import "LLBinocCalibrator.h"
#import "LLDataDeviceController.h"
#import "LLMatlabEngine.h"
#import "LLMonitorController.h"
#import "LLNE500Pump.h"
#import "LLNIDAQ.h"
#import "LLSockets.h"
#import "LLStateSystem.h"
#import "LLStimWindow.h"
#import "LLSynthDataDevice.h"
#import "LLUserDefaults.h"

@interface LLTaskPlugIn : NSObject {

	BOOL					active;
	NSTimer					*collectorTimer;
	NSPoint					currentEyeDeg;
	NSPoint					currentEyesDeg[kEyes];
	LLDataDoc				*dataDoc;
	LLDataDeviceController	*dataController;
	LLUserDefaults			*defaults;
	DisplayModeParam		displayMode;
	LLBinocCalibrator		*eyeCalibrator;
	id						host;
	BOOL					initialized;
    NSDate                  *lastDataCollectionDate;
    BOOL                    leverDown;
    LLMatlabEngine          *matlabEngine;
	long					mode;
	LLMonitorController		*monitorController;
    LLNE500Pump             *rewardPump;
    LLSockets               *socket;
	LLStateSystem			*stateSystem;
	LLStimWindow			*stimWindow;
	LLSynthDataDevice		*synthDataDevice;
	BOOL					writingDataFile;
}

@property (assign) LLNE500Pump *rewardPump;

- (void)activate;
- (BOOL)active;
- (NSTimer *)collectorTimer;
- (NSPoint)currentEyeDeg;
- (NSPoint *)currentEyesDeg;
- (LLDataDeviceController *)dataController;
- (LLDataDoc *)dataDoc;
- (IBAction)deactivate:(id)sender;
- (LLUserDefaults *)defaults;
- (LLBinocCalibrator *)eyeCalibrator;
- (LLEyeCalibrator *)eyeLeftCalibrator;
- (LLEyeCalibrator *)eyeRightCalibrator;
- (BOOL)handleEvent:(NSEvent *)theEvent;
- (BOOL)handlesEvents;
- (BOOL)initialized;
- (void)initializationDidFinish;
- (NSDate *)lastDataCollectionDate;
- (BOOL)leverDown;
- (LLMatlabEngine *)matlabEngine;
- (long)mode;
- (LLMonitorController *)monitorController;
- (NSString *)name;
- (DisplayModeParam)requestedDisplayMode;
- (void)setDataDeviceController:(LLDataDeviceController *)controller;
- (void)setDataDocument:(LLDataDoc *)doc;
- (void)setDefaults:(LLUserDefaults *)newDefaults;
- (void)setEyeCalibrator:(LLBinocCalibrator *)calibrator;
- (void)setHost:(id)newHost;
- (void)setInitialized:(BOOL)state;
- (void)setLastDataCollectionDate:(NSDate *)newDate;
- (void)setMatlabEngine:(LLMatlabEngine *)newEngine;
- (void)setMode:(long)mode;
- (void)setMonitorController:(LLMonitorController *)controller;
- (void)setSocket:(LLSockets *)newSocket;
- (void)setStimWindow:(LLStimWindow *)newStimWindow;
- (void)setSynthDataDevice:(LLSynthDataDevice *)device;
- (void)setWritingDataFile:(BOOL)state;
- (LLSockets *)socket;
- (LLStateSystem *)stateSystem;
- (LLStimWindow *)stimWindow;
- (LLSynthDataDevice *)synthDataDevice;
- (BOOL)writingDataFile;

@end
