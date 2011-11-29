//
//  BlockedState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "BlockedState.h"

@implementation BlockedState

- (void)stateAction {

	[dataDoc putEvent:@"blocked"];
//	schedule(&bNode, (PSCHED)&blockedTones, PRISYS - 1, 400, -1, NULL);
	expireTime = [LLSystemUtil timeFromNow:[defaults integerForKey:acquireMSKey]];
}

- (NSString *)name {

    return @"Blocked";
}

- (LLState *)nextState {

	if (![defaults boolForKey:fixateKey] || ![fixWindow inWindowDeg:currentEyeDeg]) {
		return stateSystem->fixon;
    }
	if ([taskMode isIdle]) {
		eotCode = kEOTQuit;
		return stateSystem->endtrial;
	}
	if ([LLSystemUtil timeIsPast:expireTime]) {
		eotCode = kEOTIgnored;
		return stateSystem->endtrial;
	}
    return Nil; 
}

@end
