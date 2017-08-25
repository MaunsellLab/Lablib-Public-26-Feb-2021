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
#import "LLSettingsController.h"
#import "LLSockets.h"
#import "LLStateSystem.h"
#import "LLStimWindow.h"
#import "LLSynthDataDevice.h"
#import "LLTaskStatus.h"
#import "LLUserDefaults.h"

typedef NS_ENUM(NSInteger, SoundTypes) {
    kMonkeySounds,
    kMouseSounds
};

#define 	kBrokeSound		        @"200Hz100msSq"     //Different sound for wrong and broke trials
#define 	kCorrectSound			@"Correct"
#define 	kFailedSound		    @"Wrong"
#define		kFixOnSound				@"6C"
#define		kFixateSound			@"7G"
#define		kStimOnSound			@"5C"
#define		kStimOffSound			@"5C"
#define 	kWrongSound             @"Wrong"

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
    NSDictionary            *monkeySoundDict;
	LLMonitorController		*monitorController;
    NSDictionary            *mouseSoundDict;
    LLNIDAQ                 *nidaq;
    LLNE500Pump             *rewardPump;
    LLSockets               *socket;
	LLStateSystem			*stateSystem;
	LLStimWindow			*stimWindow;
	LLSynthDataDevice		*synthDataDevice;
    LLTaskStatus			*taskStatus;
	BOOL					writingDataFile;
}

@property (nonatomic, assign) LLNIDAQ *nidaq;
@property (nonatomic, assign) LLNE500Pump *rewardPump;
@property (nonatomic, assign) double trialStartTimeS;
@property (nonatomic, retain) LLSettingsController *settingsController;

- (void)activate;
- (BOOL)active;
- (NSTimer *)collectorTimer;
- (NSPoint)currentEyeDeg;
- (NSPoint *)currentEyesDeg;
- (LLDataDeviceController *)dataController;
- (LLDataDoc *)dataDoc;
- (IBAction)deactivate:(id)sender;
- (LLUserDefaults *)defaults;
- (IBAction)doRunStop:(id)sender;
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
- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
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
- (void)stopSoundFileNamed:(NSString *)soundFileName;
- (void)stopSoundNamed:(NSString *)soundName;
- (LLSynthDataDevice *)synthDataDevice;
- (BOOL)writingDataFile;

@end
