//
//  EndtrialState.h
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "StateSystem.h"

@interface EndtrialState : LLState {

@private
	long intervalCorrects[kIntervals][kMaxLevels];
	long intervalTotals[kIntervals][kMaxLevels];
}

- (void)reset;

@end
