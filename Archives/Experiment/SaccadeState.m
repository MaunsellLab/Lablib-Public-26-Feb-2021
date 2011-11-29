//
//  SaccadeState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "SaccadeState.h"


@implementation SaccadeState

- (void)stateAction {

	[dataDoc putEvent:@"saccade"];
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:saccadeTimeMSKey]];
}

- (NSString *)name {

    return @"Saccade";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if ([respWindows[trial.stimulusInterval] inWindowDeg:currentEyeDeg])  {
		eotCode = kEOTCorrect;
		return stateSystem->endtrial;
	}
	if ([respWindows[1 - trial.stimulusInterval] inWindowDeg:currentEyeDeg])  {
		eotCode = kEOTWrong;
		return stateSystem->endtrial;
	}
	if ([LLSystemUtil timeIsPast:expireTime]) {
		eotCode = kEOTFailed;
		return stateSystem->endtrial;
	}
    return nil;
}

@end
