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

#define     kBrokeSound                @"200Hz100msSq"     //Different sound for wrong and broke trials
#define     kCorrectSound            @"Correct"
#define     kFailedSound            @"Wrong"
#define        kFixOnSound                @"6C"
#define        kFixateSound            @"7G"
#define        kStimOnSound            @"5C"
#define        kStimOffSound            @"5C"
#define     kWrongSound             @"Wrong"

@interface LLTaskPlugIn : NSObject {

    BOOL                    active;
    NSTimer                    *collectorTimer;
    NSPoint                    currentEyeDeg;
    NSPoint                    currentEyesDeg[kEyes];
    LLDataDoc                *dataDoc;
    LLDataDeviceController    *dataController;
    LLUserDefaults            *defaults;
    DisplayModeParam        displayMode;
    LLBinocCalibrator        *eyeCalibrator;
    id                        host;
    BOOL                    initialized;
    NSDate                  *lastDataCollectionDate;
    BOOL                    leverDown;
    LLMatlabEngine          *matlabEngine;
    long                    mode;
    NSDictionary            *monkeySoundDict;
    LLMonitorController        *monitorController;
    NSDictionary            *mouseSoundDict;
    LLNIDAQ                 *nidaq;
    LLNE500Pump             *rewardPump;
    LLSockets               *socket;
    LLStateSystem            *stateSystem;
    LLStimWindow            *stimWindow;
    LLSynthDataDevice        *synthDataDevice;
    LLTaskStatus            *taskStatus;
    BOOL                    writingDataFile;
}

@property (nonatomic, assign) LLNIDAQ *nidaq;
@property (nonatomic, assign) LLNE500Pump *rewardPump;
@property (nonatomic, assign) double trialStartTimeS;
@property (nonatomic, retain) LLSettingsController *settingsController;

- (void)activate;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL active;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) NSTimer *collectorTimer;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint currentEyeDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint *currentEyesDeg;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLDataDeviceController *dataController;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLDataDoc *dataDoc;
- (IBAction)deactivate:(id)sender;
@property (NS_NONATOMIC_IOSONLY, strong) LLUserDefaults *defaults;
- (IBAction)doRunStop:(id)sender;
@property (NS_NONATOMIC_IOSONLY, strong) LLBinocCalibrator *eyeCalibrator;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLEyeCalibrator *eyeLeftCalibrator;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLEyeCalibrator *eyeRightCalibrator;
- (BOOL)handleEvent:(NSEvent *)theEvent;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL handlesEvents;
@property (NS_NONATOMIC_IOSONLY) BOOL initialized;
- (void)initializationDidFinish;
@property (NS_NONATOMIC_IOSONLY, copy) NSDate *lastDataCollectionDate;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL leverDown;
@property (NS_NONATOMIC_IOSONLY, strong) LLMatlabEngine *matlabEngine;
@property (NS_NONATOMIC_IOSONLY) long mode;
@property (NS_NONATOMIC_IOSONLY, strong) LLMonitorController *monitorController;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
@property (NS_NONATOMIC_IOSONLY, readonly) DisplayModeParam requestedDisplayMode;
- (void)setDataDeviceController:(LLDataDeviceController *)controller;
- (void)setDataDocument:(LLDataDoc *)doc;
- (void)setHost:(id)newHost;
@property (NS_NONATOMIC_IOSONLY, strong) LLSockets *socket;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLStateSystem *stateSystem;
@property (NS_NONATOMIC_IOSONLY, strong) LLStimWindow *stimWindow;
- (void)stopSoundFileNamed:(NSString *)soundFileName;
- (void)stopSoundNamed:(NSString *)soundName;
@property (NS_NONATOMIC_IOSONLY, strong) LLSynthDataDevice *synthDataDevice;
@property (NS_NONATOMIC_IOSONLY) BOOL writingDataFile;

@end
