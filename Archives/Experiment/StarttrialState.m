//
//  StarttrialState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "StarttrialState.h"

@implementation StarttrialState

- (void)stateAction {

	long lValue, interval;
	FixWindowData fixWindowData, respWindowData[kIntervals];

// Prepare structures describing the fixation and response windows;
	
	fixWindowData.index = [eyeCalibration nextCalibrationPosition];
	[synthDataSource setOffsetDeg:[eyeCalibration offsetDeg]];			// keep synth data on offset fixation
    fixWindowData.windowDeg = [fixWindow rectDeg];
    fixWindowData.windowUnits = [eyeCalibration unitRectFromDegRect:fixWindowData.windowDeg];
	for (interval = kFirst; interval < kIntervals; interval++) {
		[respWindows[interval] setWidthAndHeightDeg:[defaults floatForKey:respWindowWidthKey]];
		respWindowData[interval].index = interval;
		respWindowData[interval].windowDeg = [respWindows[interval] rectDeg];
		respWindowData[interval].windowUnits = [eyeCalibration 
				unitRectFromDegRect:respWindowData[interval].windowDeg];
	}
	
	[dataSource setDataEnabled:NO];							// Stop/start to reset data timers
    [dataSource setDataEnabled:YES];
	[dataDoc putEvent:@"trialStart" withData:&trial.stimulusIndex];
	[dataDoc putEvent:@"trial" withData:&trial];
	lValue = kSamplePeriodMS;
	[dataDoc putEvent:@"sampleZero" withData:&lValue];
	lValue = kTimestampTickMS;
	[dataDoc putEvent:@"spikeZero" withData:&lValue];
	[dataDoc putEvent:@"eyeCalibration" withData:[eyeCalibration calibrationData]];
	[dataDoc putEvent:@"eyeWindow" withData:&fixWindowData];
	[dataDoc putEvent:@"responseWindow" withData:&respWindowData[kFirst]];
	[dataDoc putEvent:@"responseWindow" withData:&respWindowData[kSecond]];
}

- (NSString *)name {

    return @"Starttrial";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return  stateSystem->endtrial;
	}
	if ([defaults boolForKey:fixateKey] && [fixWindow inWindowDeg:currentEyeDeg]) {
		return stateSystem->blocked;
	}
	else {
		return stateSystem->fixon;
	} 
}

@end
