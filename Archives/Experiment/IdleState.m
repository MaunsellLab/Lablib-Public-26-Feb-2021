//
//  IdleState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "IdleState.h"

@implementation IdleState

- (void)stateAction {

	[dataSource setDataEnabled:NO];
}

- (NSString *)name {

    return @"Idle";
}

- (LLState *)nextState {

	if ([taskMode isEnding]) {
		return stateSystem->stop;
    }
	if (![taskMode isIdle]) {
		return stateSystem->intertrial;
    }
	else {
        return Nil;
    }
}

@end
