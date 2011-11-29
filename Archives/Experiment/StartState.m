//
//  StartState.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "StartState.h"
#import "UtilityFunctions.h"

@implementation StartState

- (void)stateAction {

	long lValue = 0;
	
	announceEvents();
    [dataDoc putEvent:@"reset" withData:&lValue];
}

- (NSString *)name {

    return @"Start";
}

- (LLState *)nextState {

	return stateSystem->idle;
}

@end
