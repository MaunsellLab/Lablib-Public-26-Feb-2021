//
//  FixonState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "FixonState.h"

@implementation FixonState

- (void)stateAction {

    [stimulusWindow setFixSpot:YES];
    [synthDataSource doLeverDown];
    [synthDataSource setEyeTargetOn:NSMakePoint(0, 0)];
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:acquireMSKey]];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
		[[NSSound soundNamed:kFixOnSound] play];
	}
}

- (NSString *)name {

    return @"Fixon";
}

- (LLState *)nextState {

	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if (![defaults boolForKey:fixateKey]) { 
		return stateSystem->prestim;
    }
	else if ([fixWindow inWindowDeg:currentEyeDeg])  {
		return stateSystem->prestim;
    }
	if ([LLSystemUtil timeIsPast:expireTime]) {
		eotCode = kEOTIgnored;
		return stateSystem->endtrial;
	}
	else {
		return Nil;
    }
}

@end
