//
//  LLTaskPlugIn.m
//  Lablib
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "LLTaskPlugIn.h"

@implementation LLTaskPlugIn

@synthesize nidaq;
@synthesize rewardPump;
@synthesize trialStartTimeS;
@synthesize settingsController;

- (void)activate;
{
    self.active = YES;
}

//- (NSTimer *)collectorTimer;
//{
//    return collectorTimer;
//}
//
- (NSPoint)currentEyeDeg;
{
    return currentEyeDeg;
}

- (NSPoint *)currentEyesDeg;
{
    return currentEyesDeg;
}

- (void)deactivate:(id)sender;
{
    self.active = NO;
}

- (void)dealloc;
{
    [monkeySoundDict release];
    [mouseSoundDict release];
    [self.dataDoc release];
    [defaults release];
    [eyeCalibrator release];
    [stimWindow release];
    [synthDataDevice release];
    [lastDataCollectionDate release];
    [settingsController release];
    [self.host release];
    [super dealloc];
}

- (LLUserDefaults *)defaults;
{
    return defaults;
}

- (IBAction)doRunStop:(id)sender;
{
    long newMode;

    switch ([taskStatus mode]) {
        case kTaskIdle:
            newMode = kTaskRunning;
            break;
        case kTaskRunning:
            newMode = kTaskStopping;
            break;
        case kTaskStopping:
        default:
            newMode = kTaskIdle;
            break;
    }
    [self setMode:newMode];
}


- (LLBinocCalibrator *)eyeCalibrator;
{
    return eyeCalibrator;
}

- (LLEyeCalibrator *)eyeLeftCalibrator;
{
    return [eyeCalibrator calibratorForEye:kLeftEye];
}

- (LLEyeCalibrator *)eyeRightCalibrator;
{
    return [eyeCalibrator calibratorForEye:kRightEye];
}

// Overwrite this method to handle OS events.  It should return YES if it consumes the event,
// and must return NO otherwise;

- (BOOL)handleEvent:(NSEvent *)theEvent;
{
    return NO;
}

// Overwrite this method to return YES if your plugin wants to receive OS events

- (BOOL)handlesEvents;
{
    return NO;
}

- (instancetype)init;
{
    if ((self = [super init])) {
        monkeySoundDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"200Hz100msSq", @"broke",
                           @"Correct", @"correct", @"Wrong", @"failed", @"6C", @"fixon", @"7G", @"fixate",
                           @"5C", @"stimon", @"5C", @"stimoff", @"Wrong", @"wrong", nil];
        mouseSoundDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"MouseWrong", @"broke",
                          @"MouseCorrect", @"correct", @"MouseFailed", @"failed", @"MouseWaitForLever", @"fixon",
                          @"MouseLeverDown", @"fixate", @"5C", @"stimon", @"5C", @"stimoff", @"MouseWrong",
                          @"wrong", nil];
        self.writingDataFile = NO;
        self.name = @"Unnamed Task PlugIn";
    }
    return self;
}

- (BOOL)initialized;
{
    return initialized;
}

- (void)initializationDidFinish;
{
}

- (NSDate *)lastDataCollectionDate;
{
    return lastDataCollectionDate;
}

- (BOOL)leverDown;
{
    return leverDown;
}

- (LLMatlabEngine *)matlabEngine;
{
    return matlabEngine;
}

- (long)mode;
{
    return mode;
}

- (LLMonitorController *)monitorController;
{
    return monitorController;
}

- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
{
    NSString *soundFileName;

    if ([defaults boolForKey:key]) {
        switch ([defaults integerForKey:@"KNSoundTypeSelection"]) {
            case kMonkeySounds:
                soundFileName = monkeySoundDict[soundName.lowercaseString];
                break;
            case kMouseSounds:
                soundFileName = mouseSoundDict[soundName.lowercaseString];
                break;
            default:
                soundFileName = nil;
                break;
        }
        if (soundFileName != nil) {
            [self stopSoundFileNamed:soundFileName];      // won't play again if it's current playing
            [[NSSound soundNamed:soundFileName] play];
        }
        else {
            NSLog(@"LLTaskPlugin:playSoundName: Unrecognized sound name %@", soundName);
        }
    }
}

- (DisplayModeParam)requestedDisplayMode;
{
    displayMode.widthPix = 0;                                // 0 signifies, don't care: video is left unchanged
    displayMode.heightPix = 0;
    displayMode.pixelBits = 0;
    displayMode.frameRateHz = 0;
    return displayMode;
}

- (void)setDefaults:(LLUserDefaults *)newDefaults;
{
    [defaults release];
    defaults = newDefaults;
    [defaults retain];
}

- (void)setEyeCalibrator:(LLBinocCalibrator *)calibrator;
{
    [eyeCalibrator release];
    eyeCalibrator = calibrator;
    [eyeCalibrator retain];
}

- (void)setInitialized:(BOOL)state;
{
    initialized = state;
}

- (void)setLastDataCollectionDate:(NSDate *)newDate;
{
    NSDate *theDate;
    
    theDate = lastDataCollectionDate;
    lastDataCollectionDate = [newDate retain];
    [theDate release];
}

- (void)setMatlabEngine:(LLMatlabEngine *)newEngine;
{
    [matlabEngine release];
    matlabEngine = newEngine;
    [matlabEngine retain];
}

- (void)setMode:(long)newMode;
{
    mode = newMode;
}

- (void)setMonitorController:(LLMonitorController *)controller;
{
    monitorController = controller;
}

- (void)setSocket:(LLSockets *)newSocket;
{
    [socket release];
    socket = newSocket;
    [socket retain];
}

- (void)setStimWindow:(LLStimWindow *)newStimWindow;
{
    [stimWindow release];
    stimWindow = newStimWindow;
    [stimWindow retain];
}

- (void)setSynthDataDevice:(LLSynthDataDevice *)device;
{
    [synthDataDevice release];
    synthDataDevice = device;
    [synthDataDevice retain];
}

- (LLSockets *)socket;
{
    return socket;
}

- (LLStateSystem *)stateSystem;
{
    return stateSystem;
}

- (LLStimWindow *)stimWindow;
{
    return stimWindow;
}

- (void)stopSoundFileNamed:(NSString *)soundFileName;
{
    NSSound *sound = [NSSound soundNamed:soundFileName];

    if (sound.playing) {
        [sound stop];
    }
}

- (void)stopSoundNamed:(NSString *)soundName;
{
    NSString *soundFileName;

    switch ([defaults integerForKey:@"KNSoundTypeSelection"]) {
        case kMonkeySounds:
            soundFileName = monkeySoundDict[soundName.lowercaseString];
            break;
        case kMouseSounds:
            NSLog(@"Mouse Sounds");
            soundFileName = mouseSoundDict[soundName.lowercaseString];
            break;
        default:
            NSLog(@"LLTaskPlugin: playSoundNamed: unrecognized sounds type");
            soundFileName = nil;
            break;
    }
    [self stopSoundFileNamed:soundFileName];
}

- (LLSynthDataDevice *)synthDataDevice;
{
    return synthDataDevice;
}

@end
