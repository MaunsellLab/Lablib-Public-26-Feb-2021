//
//  PrestimState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "PrestimState.h"

//#define 	kCalibrationDelayMS		150

@implementation PrestimState

- (void)stateAction {

	long preIntervalMS = [defaults integerForKey:preIntervalMSKey];
	
	if ([defaults boolForKey:fixateKey]) {				// fixation required && fixated
		[dataDoc putEvent:@"fixate"];
		[scheduler schedule:@selector(updateCalibration) toTarget:self withObject:Nil
				delayMS:preIntervalMS * 0.8];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
			[[NSSound soundNamed:kFixateSound] play];
		}
	}
	[dataDoc putEvent:@"preStimuli"];
	expireTime = [LLSystemUtil timeFromNow:preIntervalMS];
}

- (NSString *)name {

    return @"Prestim";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if ([defaults boolForKey:fixateKey] && ![fixWindow inWindowDeg:currentEyeDeg]) {
		eotCode = kEOTBroke;
		return stateSystem->endtrial;
	}
	if ([LLSystemUtil timeIsPast:expireTime]) {
		return stateSystem->intervalOne;
	}
	return Nil;
}

- (void)updateCalibration {

	if ([fixWindow inWindowDeg:currentEyeDeg]) {
		[eyeCalibration updateCalibration:currentEyeDeg];
	}
}

@end
