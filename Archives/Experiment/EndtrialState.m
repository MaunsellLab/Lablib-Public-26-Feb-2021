//
//  EndtrialState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "EndtrialState.h"
#import "UtilityFunctions.h"
#import "AppController.h"

#define kMinRewardMS	10
#define kMinTrials		4

@implementation EndtrialState

- (long)juiceMS {
	
	long juiceMS, interval, stimIndex;
	double fractions[kIntervals];
	
	juiceMS = [[NSUserDefaults standardUserDefaults] integerForKey:rewardKey];
	stimIndex = trial.stimulusIndex;
	if (MIN(intervalTotals[kFirst][stimIndex], intervalTotals[kSecond][stimIndex]) >= kMinTrials) {
		for (interval = 0; interval < kIntervals; interval++) {
			fractions[interval] = 
				intervalCorrects[interval][stimIndex] / (double)intervalTotals[interval][stimIndex];
		}
		if (trial.stimulusInterval == 0) {
			juiceMS = (1.0 - fractions[kFirst] + fractions[kSecond]) * juiceMS + kMinRewardMS;
		}
		else{
			juiceMS = (1.0 + fractions[kFirst] - fractions[kSecond]) * juiceMS + kMinRewardMS;
		}
	}
	return juiceMS;
}

- (void)stateAction {

	long trialCertify, value;
	
//	cancelSchedule(bNode);
    [stimulusWindow setFixSpot:NO];
    [stimulusWindow setTargets:NO contrast0:nil contrast1:nil];
	[stimulusWindow erase];
	[dataDoc putEvent:@"stimulusOff" withData:&trial.stimulusIndex];
	
// The computer may have failed to create the display correctly.  We check that now
// If the computer failed, the monkey will still get rewarded for correct trial,
// but the trial will be done over.  Other computer checks can be added here.

	trialCertify = nil;
	if (![[stimulusWindow monitor] success]) {
		trialCertify |= (0x1 << kCertifyVideoBit);
	}
	switch (eotCode) {
	case kEOTCorrect:
		intervalCorrects[trial.stimulusInterval][trial.stimulusIndex]++;
		intervalTotals[trial.stimulusInterval][trial.stimulusIndex]++;
		[appController doJuice:self];							// reward in any case
		if (trialCertify == nil) {
			[trialBlock countCurrentTrial:YES];
		}
		break;
	case kEOTWrong:
		intervalTotals[trial.stimulusInterval][trial.stimulusIndex]++;
		if (trialCertify == nil) {
			[trialBlock countCurrentTrial:NO];
		}
		//  FALL THROUGH
	default:
		if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
			[[NSSound soundNamed:kNotCorrectSound] play];
		}
		break;
	}
	value = [trialBlock trialsDoneCurrentBlock];
	[dataDoc putEvent:@"blockTrialsDone" withData:(void *)&value];
	value = [trialBlock blocksDone];
	[dataDoc putEvent:@"blocksDone" withData:(void *)&value];
	[dataDoc putEvent:@"trialCertify" withData:(void *)&trialCertify];
	[dataDoc putEvent:@"trialEnd" withData:(void *)&eotCode];
    [synthDataSource setSpikeRateHz:2.5 atTime:[LLSystemUtil getTimeS]];
    [synthDataSource setEyeTargetOff];
    [synthDataSource doLeverUp];
	if (resetFlag) {
		reset();
        resetFlag = NO;
	}
    if ([taskMode isStopping]) {						// Requested to stop
        [taskMode setMode:kTaskIdle];
	}
}

- (NSString *)name {

    return [NSString stringWithFormat:@"Endtrial (%@)", 
				[LLStandardDataEvents trialEndName:eotCode]];
}

- (LLState *)nextState {

//	if (stimOn) {
//		return 0;
//    }
	if ([taskMode isIdle]) {
		return stateSystem->idle;
    }
	else {
		return stateSystem->intertrial;
	}
}

- (void)reset {
	
	long interval, level;
	
	for (interval = 0; interval < kIntervals; interval++) {
		for (level = 0; level < kMaxLevels; level++) {
			intervalCorrects[interval][level] = intervalTotals[interval][level] = 0.0;
		}
	}
}

@end
