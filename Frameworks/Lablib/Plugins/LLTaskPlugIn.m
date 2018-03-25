//
//  LLTaskPlugIn.m
//  Lablib
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "LLTaskPlugIn.h"

@implementation LLTaskPlugIn

- (void)activate;
{
    self.active = YES;
}

- (void)deactivate:(id)sender;
{
    self.active = NO;
}

- (void)dealloc;
{
    [monkeySoundDict release];
    [mouseSoundDict release];
    free(self.currentEyesDeg);
    self.collectorTimer = nil;
    self.controlPanel = nil;
    self.dataController = nil;
    self.dataDoc = nil;
    self.defaults = nil;
    self.eyeCalibrator = nil;
    self.eyeLeftCalibrator = nil;
    self.eyeRightCalibrator = nil;
    self.falseHits = nil;
    self.matlabEngine = nil;
    self.monitorController = nil;
    self.name = nil;
    self.socket = nil;
    self.stimWindow = nil;
    self.stateSystem = nil;
    self.synthDataDevice = nil;
    self.lastDataCollectionDate = nil;
    self.settingsController = nil;
    self.observerKeys = nil;
    self.host = nil;
    [super dealloc];
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
    self.mode = newMode;
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
        _writingDataFile = NO;
        _name = @"Unnamed Task PlugIn";
        _observerKeys = [[LLObserverKeys alloc] init];
        _currentEyesDeg = malloc(2 * sizeof(NSPoint));
        _usesGit = NO;
   }
    return self;
}

- (void)initializationDidFinish;
{
}

- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
{
    NSString *soundFileName;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"KNSoundTypeSelection"]) {
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

    switch ([[NSUserDefaults standardUserDefaults] integerForKey:@"KNSoundTypeSelection"]) {
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

// We block the Run command until matlab has finished launching

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;
{
    return (menuItem.action != @selector(doRunStop:)) || !self.matlabEngine.launching;
}


@end
