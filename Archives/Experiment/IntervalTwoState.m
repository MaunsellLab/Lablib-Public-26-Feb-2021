//
//  IntervalTwoState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "IntervalTwoState.h"
#import "UtilityFunctions.h"

@implementation IntervalTwoState

- (void)stateAction {

	float normalizedValue, stimulusValue;
	StimTrainData *pTrain;
	
	long intervalMS = [[NSUserDefaults standardUserDefaults] integerForKey:intervalMSKey];

	stimulusValue = (trial.stimulusInterval == kSecondInterval) ? trial.stimulusValue : 0;
	switch (trial.stimulusType) {
	case kElectricalStimulus:
		pTrain = stimTrainParameters(stimulusValue);
		[stimTrainDevice setTrainParameters:pTrain];
		[stimTrainDevice stimulate];
		expireTime = [LLSystemUtil timeFromNow:intervalMS];
		normalizedValue = stimulusValue / 
						[[NSUserDefaults standardUserDefaults] floatForKey:maxCurrentKey];
		break;
	case kVisualStimulus:
	default:
		[stimulusWindow runContrast:stimulusValue duration:intervalMS];
		normalizedValue = stimulusValue / 
						[[NSUserDefaults standardUserDefaults] floatForKey:maxContrastKey];
	}

	[dataDoc putEvent:@"intervalTwo" withData:&stimulusValue];	
    [synthDataSource setSpikeRateHz:spikeRateFromStimValue(normalizedValue) atTime:[LLSystemUtil getTimeS]];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
		[[NSSound soundNamed:
				[NSString stringWithFormat:@"200Hz%dmsSq", MAX(100, MIN(intervalMS, 500) / 100 * 100)]] play];
	}
}

- (NSString *)name {

    return @"IntervalTwo";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if ([defaults boolForKey:fixateKey] &&  ![fixWindow inWindowDeg:currentEyeDeg]) {
		eotCode = kEOTBroke;
		return stateSystem->endtrial;
	}
	if (((trial.stimulusType == kElectricalStimulus) && [LLSystemUtil timeIsPast:expireTime]) || 
						(trial.stimulusType == kVisualStimulus && !stimulusOn)) {
		return stateSystem->poststim;
	}
    return Nil;
}


@end
