//
//  TargetsOnState.m
//  Experiment
//
//  Created by John Maunsell on Fri Feb 13 2004.
//  Copyright (c) 2004. All rights reserved.
//

#import "TargetsOnState.h"
#import "UtilityFunctions.h"


@implementation TargetsOnState

- (void)stateAction {

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	long nontargetContrast = [defaults integerForKey:nontargetContrastKey];

	[dataDoc putEvent:@"targetsOn"];
	[stimulusWindow setTargets:YES contrast0:(trial.stimulusInterval == 0) ? 100 : nontargetContrast
					contrast1:(trial.stimulusInterval == 1) ? 100 : nontargetContrast];
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:tooFastMSKey]];
}

- (NSString *)name {

    return @"TargetsOn";
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
		return stateSystem->react;
	}
	return Nil;
}

@end
