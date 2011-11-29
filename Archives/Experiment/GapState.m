//
//  GapState.m
//  Experiment
//
//  Created by John Maunsell on Fri Dec 26 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "GapState.h"
#import "UtilityFunctions.h"

@implementation GapState

- (void)stateAction {

	[dataDoc putEvent:@"gap"];
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:gapMSKey]];
    [synthDataSource setSpikeRateHz:spikeRateFromStimValue(0.0) atTime:[LLSystemUtil getTimeS]];
}

- (NSString *)name {

    return @"Gap";
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
		return stateSystem->intervalTwo;
	}
	return Nil;
}


@end
