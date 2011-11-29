//
//  ReactState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "ReactState.h"


@implementation ReactState

- (void)stateAction {

	double prob100, alpha, beta, factor;
	
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:responseTimeMSKey] -
                    [defaults integerForKey:tooFastMSKey]];
					
// Here we instruct the fake monkey to respond, using appropriate psychophysics.

	alpha = 10.0;
	beta = 2.0;
	prob100 = 100.0 - 50.0 * exp(-exp(log(trial.stimulusValue / alpha) * beta));
	factor = ((rand() % 100) < prob100) ? 1 : -1;
    [synthDataSource setEyeTargetOn:
			NSMakePoint(factor * trial.respAziDeg, factor * trial.respEleDeg)];
}

- (NSString *)name {

    return @"React";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {							// switched to idle
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if (![defaults boolForKey:fixateKey]) {
		eotCode = kEOTCorrect;
		return stateSystem->endtrial;
	}
	else {
		if (![fixWindow inWindowDeg:currentEyeDeg]) {   // started a saccade
			return stateSystem->saccade;
		}
	}
	if ([LLSystemUtil timeIsPast:expireTime]) {
		eotCode = kEOTFailed;
		return stateSystem->endtrial;
	}
    return nil;
}

@end
