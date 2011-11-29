//
//  PoststimState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "PoststimState.h"
#import "UtilityFunctions.h"

@implementation PoststimState

- (void)stateAction {

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[dataDoc putEvent:@"postStimuli"];
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:postIntervalMSKey]];
    [synthDataSource setSpikeRateHz:spikeRateFromStimValue(0.0) atTime:[LLSystemUtil getTimeS]];
}

- (NSString *)name {

    return @"Poststim";
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
		return stateSystem->targetsOn;
	}
	return Nil;
}

@end
