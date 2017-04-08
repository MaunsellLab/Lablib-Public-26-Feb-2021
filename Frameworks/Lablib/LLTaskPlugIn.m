//
//  LLTaskPlugIn.m
//  Lablib
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "LLTaskPlugIn.h"

@implementation LLTaskPlugIn

@synthesize rewardPump;
@synthesize trialStartTimeS;

- (void)activate;
{
}

- (BOOL)active;
{
	return active;
}

- (LLDataDoc *)dataDoc;
{
	return dataDoc;
}

- (NSTimer *)collectorTimer;
{
	return collectorTimer;
}

- (NSPoint)currentEyeDeg;
{
	return currentEyeDeg;
}

- (NSPoint *)currentEyesDeg;
{
	return currentEyesDeg;
}

- (LLDataDeviceController *)dataController;
{
	return dataController;
}

- (void)deactivate:(id)sender;
{
}

- (void)dealloc;
{
	[dataDoc release];
	[defaults release];
	[eyeCalibrator release];
	[stimWindow release];
	[synthDataDevice release];
    [lastDataCollectionDate release];
	[host release];
	[super dealloc];
}

- (LLUserDefaults *)defaults;
{
	return defaults;
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

- (NSString *)name; 
{
	return @"Unnamed Task PlugIn";
}

- (void)playSoundNamed:(NSString *)soundName ifDefaultsKey:(NSString *)key;
{
    if ([defaults boolForKey:key]) {
        [self stopSoundNamed:soundName];                    // won't play again if it's current playing
        [[NSSound soundNamed:soundName] play];
    }
}

- (DisplayModeParam)requestedDisplayMode;
{
	displayMode.widthPix = 0;								// 0 signifies, don't care: video is left unchanged
	displayMode.heightPix = 0;
	displayMode.pixelBits = 0;
	displayMode.frameRateHz = 0;
	return displayMode;
}

- (void)setDataDocument:(LLDataDoc *)doc;
{
	[dataDoc release];
	dataDoc = doc;
	[dataDoc retain];
}

- (void)setDataDeviceController:(LLDataDeviceController *)controller;
{
	dataController = controller;
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

- (void)setHost:(id)newHost;
{
	[host release];
	host = newHost;
	[host retain];
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

- (void)setWritingDataFile:(BOOL)state;
{
	writingDataFile = state;
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

- (void)stopSoundNamed:(NSString *)soundName;
{
    NSSound *sound = [NSSound soundNamed:soundName];

    if ([sound isPlaying]) {
        [sound stop];
    }
}

- (LLSynthDataDevice *)synthDataDevice;
{
	return synthDataDevice;
}

- (BOOL)writingDataFile;
{
	return writingDataFile;
}

@end
