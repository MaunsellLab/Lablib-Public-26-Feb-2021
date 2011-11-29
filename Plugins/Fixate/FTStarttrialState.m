//
//  FTStarttrialState.m
//  Fixate Task
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "FTStarttrialState.h"

@implementation FTStarttrialState

- (void)stateAction {

	long longValue, interval;
	FixWindowData fixWindowData;

// Prepare structures describing the fixation and response windows;
	
	fixWindowData.index = [[task eyeCalibrator] nextCalibrationPosition];
	[[task synthDataDevice] setOffsetDeg:[[task eyeCalibrator] calibrationOffsetPointDeg]];			// keep synth data on offset fixation
    fixWindowData.windowDeg = [fixWindow rectDeg];
    fixWindowData.windowUnits = [[task eyeCalibrator] unitRectFromDegRect:fixWindowData.windowDeg];
	
    [[task dataController] setDataEnabled:[NSNumber numberWithBool:NO]];
	[[task dataController] readDataFromDevices];
	[[task collectorTimer] fire];
	longValue = 0;
	[[task dataDoc] putEvent:@"trialStart" withData:&longValue];
	longValue = kSamplePeriodMS;
	[[task dataDoc] putEvent:@"sampleZero" withData:&longValue];
	longValue = kTimestampTickMS;
	[[task dataDoc] putEvent:@"spikeZero" withData:&longValue];
    [[task dataController] setDataEnabled:[NSNumber numberWithBool:YES]];
	[[task dataDoc] putEvent:@"eyeCalibration" withData:[[task eyeCalibrator] calibrationData]];
	[[task dataDoc] putEvent:@"eyeWindow" withData:&fixWindowData];
}

- (NSString *)name {

    return @"Starttrial";
}

- (LLState *)nextState {

	if ([task mode] == kTaskIdle) {
		eotCode = kEOTQuit;
		return  [[task stateSystem] stateNamed:@"Endtrial"];
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoFixateKey] && 
			[fixWindow inWindowDeg:[task currentEyeDeg]]) {
		return [[task stateSystem] stateNamed:@"Blocked"];
	}
	else {
		return [[task stateSystem] stateNamed:@"Fixon"];
	} 
}

@end
