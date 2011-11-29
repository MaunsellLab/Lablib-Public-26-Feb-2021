//
//  IntertrialState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "IntertrialState.h"
#import "UtilityFunctions.h"
#import "AppController.h"

@implementation IntertrialState

- (void)stateAction {

	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:intertrialMSKey]];
	eotCode = kEOTCorrect;			// Default eot code is correct
	trial.stimulusIndex = [trialBlock nextTrialIndex];
	if (trial.stimulusIndex < 0) {		// no trials remaining
		[taskMode setMode:kTaskIdle];
		return;
	}
	
	trial.stimulusType = [[NSUserDefaults standardUserDefaults] integerForKey:stimTypeKey];
	trial.stimulusValue = valueFromIndex(trial.stimulusIndex, getStimParams(trial.stimulusType));
	trial.stimulusInterval = rand() % 2;

// update the fixtation and response windows

    [fixWindow setWidthAndHeightDeg:[defaults floatForKey:fixWindowWidthKey]];
	[respWindows[kFirst] setAzimuthDeg:[defaults floatForKey:respWindow0AziKey]];
	[respWindows[kFirst] setElevationDeg:[defaults floatForKey:respWindow0EleKey]];
	[respWindows[kSecond] setAzimuthDeg:[defaults floatForKey:respWindow1AziKey]];
	[respWindows[kSecond] setElevationDeg:[defaults floatForKey:respWindow1EleKey]];

	trial.respAziDeg = [respWindows[trial.stimulusInterval] azimuthDeg];
	trial.respEleDeg = [respWindows[trial.stimulusInterval] elevationDeg];
}

- (NSString *)name {

    return @"Intertrial";
}

- (LLState *)nextState {

    if ([taskMode isIdle]) {
        eotCode = kEOTQuit;
        return stateSystem->endtrial;
    }
    else if ([LLSystemUtil timeIsPast:expireTime]) {
        return stateSystem->starttrial;
    }
    return Nil;
}

@end
