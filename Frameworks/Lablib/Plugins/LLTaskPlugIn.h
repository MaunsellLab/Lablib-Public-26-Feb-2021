//
//  LLTaskPlugIn.h
//  Lablib
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2018. All rights reserved.
//

#import "LLControlPanel.h"
#import "LLDataDoc.h"
#import "LLDisplays.h"
#import "LLBinocCalibrator.h"
#import "LLDataDeviceController.h"
#import "LLFalseHits.h"
#import "LLMatlabEngine.h"
#import "LLMonitorController.h"
#import "LLObserverKeys.h"
#import "LLNE500Pump.h"
#import "LLNIDAQ.h"
#import "LLSettingsController.h"
#import "LLSockets.h"
#import "LLStateSystem.h"
#import "LLStimWindow.h"
#import "LLSynthDataDevice.h"
#import "LLTaskStatus.h"
#import "LLUserDefaults.h"

//@class LLMatlabEngine;

typedef NS_ENUM(NSInteger, SoundTypes) {
    kMonkeySounds,
    kMouseSounds
};

#define kBrokeSound     @"200Hz100msSq"     //Different sound for wrong and broke trials
#define kCorrectSound   @"Correct"
#define kFailedSound    @"Wrong"
#define kFixOnSound     @"6C"
#define kFixateSound    @"7G"
#define kStimOnSound    @"5C"
#define kStimOffSound   @"5C"
#define kWrongSound     @"Wrong"

@interface LLTaskPlugIn : NSObject {

    DisplayModeParam        displayMode;
    NSDictionary            *monkeySoundDict;
    NSDictionary            *mouseSoundDict;
    LLTaskStatus            *taskStatus;

    IBOutlet NSMenuItem     *runStopMenuItem;
}

@property (NS_NONATOMIC_IOSONLY) BOOL active;
@property (NS_NONATOMIC_IOSONLY, retain) NSTimer *collectorTimer;
@property (NS_NONATOMIC_IOSONLY, retain) LLControlPanel *controlPanel;
@property (NS_NONATOMIC_IOSONLY) NSPoint currentEyeDeg;
@property (NS_NONATOMIC_IOSONLY) NSPoint *currentEyesDeg;
@property (NS_NONATOMIC_IOSONLY, strong) LLDataDeviceController *dataController;
@property (NS_NONATOMIC_IOSONLY, retain) LLDataDoc *dataDoc;
@property (NS_NONATOMIC_IOSONLY, retain) LLUserDefaults *defaults;
@property (NS_NONATOMIC_IOSONLY, strong) LLBinocCalibrator *eyeCalibrator;
@property (NS_NONATOMIC_IOSONLY, strong) LLEyeCalibrator *eyeLeftCalibrator;
@property (NS_NONATOMIC_IOSONLY, strong) LLEyeCalibrator *eyeRightCalibrator;
@property (NS_NONATOMIC_IOSONLY, retain) LLFalseHits *falseHits;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL handlesEvents;
@property (NS_NONATOMIC_IOSONLY, retain) id host;
@property (NS_NONATOMIC_IOSONLY) BOOL initialized;
@property (NS_NONATOMIC_IOSONLY, retain) NSDate *lastDataCollectionDate;
@property (NS_NONATOMIC_IOSONLY) BOOL leverDown;
@property (NS_NONATOMIC_IOSONLY, strong) LLMatlabEngine *matlabEngine;
@property (NS_NONATOMIC_IOSONLY) long mode;
@property (NS_NONATOMIC_IOSONLY, strong) LLMonitorController *monitorController;
@property (NS_NONATOMIC_IOSONLY, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY, assign) LLNIDAQ *nidaq;
@property (NS_NONATOMIC_IOSONLY, retain) LLObserverKeys *observerKeys;
@property (NS_NONATOMIC_IOSONLY, assign) LLNE500Pump *rewardPump;
@property (NS_NONATOMIC_IOSONLY, retain) LLSettingsController *settingsController;
@property (NS_NONATOMIC_IOSONLY, retain) LLSockets *socket;
@property (NS_NONATOMIC_IOSONLY, retain) LLStateSystem *stateSystem;
@property (NS_NONATOMIC_IOSONLY, retain) LLStimWindow *stimWindow;
@property (NS_NONATOMIC_IOSONLY, retain) LLSynthDataDevice *synthDataDevice;
@property (NS_NONATOMIC_IOSONLY, assign) double trialStartTimeS;
@property (NS_NONATOMIC_IOSONLY) BOOL usesGit;
@property (NS_NONATOMIC_IOSONLY) BOOL writingDataFile;


- (void)activate;
- (IBAction)deactivate:(id)sender;
- (IBAction)doRunStop:(id)sender;
- (BOOL)handleEvent:(NSEvent *)theEvent;
- (void)initializationDidFinish;
- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
- (DisplayModeParam)requestedDisplayMode;
- (void)stopSoundFileNamed:(NSString *)soundFileName;
- (void)stopSoundNamed:(NSString *)soundName;
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

@end