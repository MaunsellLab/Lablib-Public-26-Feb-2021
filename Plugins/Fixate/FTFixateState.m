//
//  FTFixateState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "FTFixateState.h"

@implementation FTFixateState

- (void)stateAction {

	long fixateMS = [[NSUserDefaults standardUserDefaults] integerForKey:FTFixateMSKey];
	
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoFixateKey]) {				// fixation required && fixated
		[[task dataDoc] putEvent:@"fixate"];
		[scheduler schedule:@selector(updateCalibration) toTarget:self withObject:Nil
				delayMS:fixateMS * 0.8];
		if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoSoundsKey]) {
			[[NSSound soundNamed:kFixateSound] play];
		}
	}
	[[task dataDoc] putEvent:@"fixate"];
	expireTime = [LLSystemUtil timeFromNow:fixateMS];
}

- (NSString *)name {

    return @"Fixate";
}

- (LLState *)nextState {

	if ([task mode] == kTaskIdle) {
		eotCode = kEOTQuit;
		return [[task stateSystem] stateNamed:@"Endtrial"];
	}
	if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoFixateKey] && 
						![fixWindow inWindowDeg:[task currentEyeDeg]]) {
		eotCode = kEOTBroke;
		return [[task stateSystem] stateNamed:@"Endtrial"];
	}
	if ([LLSystemUtil timeIsPast:expireTime]) {
		eotCode = kEOTCorrect;
		return [[task stateSystem] stateNamed:@"Endtrial"];
	}
	return nil;
}

- (void)updateCalibration {

	if ([fixWindow inWindowDeg:[task currentEyeDeg]]) {
		[[task eyeCalibrator] updateCalibration:[task currentEyeDeg]];
	}
}

@end
