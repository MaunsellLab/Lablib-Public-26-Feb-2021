//
//  OCIntertrialState.h
//  Experiment
//
//  Copyright (c) 2006. All rights reserved.
//

#import "OCStateSystem.h"

@interface OCIntertrialState : LLState {

	NSTimeInterval	expireTime;
}

- (BOOL)selectTrial;

@end
