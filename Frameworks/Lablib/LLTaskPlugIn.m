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

- (LLDataDeviceController *)dataController;
{
	return dataController;
}

- (id<LLIODevice>)dataSource;
{
	return dataSource;
}

- (void)deactivate:(id)sender;
{
}

- (void)dealloc;
{
	[dataDoc release];
	[defaults release];
	[eyeCalibrator[kLeftEye] release];
	[eyeCalibrator[kRightEye] release];
	[stimWindow release];
	[synthDataDevice release];
	[synthDataSource release];
	[host release];
	[super dealloc];
}

- (LLUserDefaults *)defaults;
{
	return defaults;
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

- (LLEyeCalibrator *)eyeCalibrator;
{
	return eyeCalibrator[kLeftEye];
}

- (BOOL)initialized;
{
	return initialized;
}

- (void)initializationDidFinish;
{
}

- (LLEyeCalibrator *)leftEyeCalibrator;
{
	return eyeCalibrator[kLeftEye];
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

- (DisplayModeParam)requestedDisplayMode;
{
	displayMode.widthPix = 0;								// don't care 
	displayMode.heightPix = 0;								// don't care 
	displayMode.pixelBits = 0;								// don't care 
	displayMode.frameRateHz = 0;							// don't care 
	return displayMode;
}

- (LLEyeCalibrator *)rightEyeCalibrator;
{
	return eyeCalibrator[kRightEye];
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

- (void)setDataSource:(id<LLIODevice>)source;
{
	dataSource = source;
}

- (void)setDefaults:(LLUserDefaults *)newDefaults;
{
	[defaults release];
	defaults = newDefaults;
	[defaults retain];
}

- (void)setEyeCalibrator:(LLEyeCalibrator *)calibrator;
{
    [self setLeftEyeCalibrator:calibrator];
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

- (void)setMode:(long)newMode;
{
	mode = newMode;
}

- (void)setLeftEyeCalibrator:(LLEyeCalibrator *)calibrator;
{
	[eyeCalibrator[kLeftEye] release];
	eyeCalibrator[kLeftEye] = calibrator;
	[eyeCalibrator[kLeftEye] retain];
}

- (void)setMonitorController:(LLMonitorController *)controller;
{
	monitorController = controller;
}

- (void)setRightEyeCalibrator:(LLEyeCalibrator *)calibrator;
{
	[eyeCalibrator[kRightEye] release];
	eyeCalibrator[kRightEye] = calibrator;
	[eyeCalibrator[kRightEye] retain];
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

- (void)setSynthDataSource:(LLSynthIODevice *)source;
{
	[synthDataSource release];
	synthDataSource = source;
	[synthDataSource retain];
}

- (void)setWritingDataFile:(BOOL)state;
{
	writingDataFile = state;
}

- (LLStateSystem *)stateSystem;
{
	return stateSystem;
}

- (LLStimWindow *)stimWindow;
{
	return stimWindow;
}

- (LLSynthDataDevice *)synthDataDevice;
{
	return synthDataDevice;
}

- (LLSynthIODevice *)synthDataSource;
{
	return synthDataSource;
}

- (BOOL)writingDataFile;
{
	return writingDataFile;
}

@end
