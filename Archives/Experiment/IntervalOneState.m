//
//  IntervalOneState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "IntervalOneState.h" 
#import "UtilityFunctions.h"

@implementation IntervalOneState

- (void)stateAction {

	float stimulusValue, normalizedValue;
	StimTrainData *pTrain;
	
	long intervalMS = [[NSUserDefaults standardUserDefaults] integerForKey:intervalMSKey];
	 
	stimulusValue = (trial.stimulusInterval == kFirstInterval) ? trial.stimulusValue : 0;
	switch (trial.stimulusType) {
	case kElectricalStimulus:
		pTrain = stimTrainParameters(stimulusValue);
		[stimTrainDevice setTrainParameters:pTrain];
		[stimTrainDevice stimulate];
		expireTime = [LLSystemUtil timeFromNow:intervalMS];
		normalizedValue = stimulusValue / [[NSUserDefaults standardUserDefaults] floatForKey:maxCurrentKey];
		break;
	case kVisualStimulus:
	default:
		[stimulusWindow runContrast:stimulusValue duration:intervalMS];
		normalizedValue = stimulusValue / [[NSUserDefaults standardUserDefaults] floatForKey:maxContrastKey];
	}

	[dataDoc putEvent:@"intervalOne" withData:&stimulusValue];	
    [synthDataSource setSpikeRateHz:spikeRateFromStimValue(normalizedValue) atTime:[LLSystemUtil getTimeS]];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
		[[NSSound soundNamed:
				[NSString stringWithFormat:@"200Hz%dmsSq", MAX(100, MIN(intervalMS, 500) / 100 * 100)]] play];
	}
}

- (NSString *)name {

    return @"IntervalOne";
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
		return stateSystem->gap;
	}
    return Nil;
}


@end
