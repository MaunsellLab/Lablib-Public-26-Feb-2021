//
//  StateSystem.h
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "Experiment.h"

#define		kFixOnSound				@"6C"
#define		kFixateSound			@"7G"
#define		kStimOnSound			@"5C"
#define		kStimOffSound			@"5C"
#define 	kCorrectSound			@"Correct"
#define 	kNotCorrectSound		@"NotCorrect"

enum {kFirst, kSecond, kIntervals};

typedef struct {
	long	stimulusType;
	long	stimulusIndex;
	float   stimulusValue;
	long	stimulusInterval;
	float   respAziDeg;
	float   respEleDeg;
} TrialDesc;

extern long 			eotCode;			// End Of Trial code
extern LLEyeWindow		*fixWindow;
extern long				intervalIndex;
extern BOOL				leverIsDown;
extern LLScheduleController *scheduler;
extern LLEyeWindow		*respWindows[kIntervals];
extern TrialDesc		trial;

@interface StateSystem : NSObject {

    LLStateSystem	*controller;
	long			stimType;
@public
    LLState			*blocked;
    LLState			*endtrial;
    LLState			*fixon;
    LLState			*gap;
    LLState			*idle;
    LLState			*intertrial;
    LLState			*intervalOne;
    LLState			*intervalTwo;
    LLState			*poststim;
    LLState			*prestim;
    LLState			*react;
    LLState			*saccade;
    LLState			*starttrial;
    LLState			*start;
    LLState			*stop;
	LLState			*targetsOn;
}

- (BOOL)running;
- (BOOL)startWithCheckIntervalMS:(double)checkMS;	// start the system running
- (void)stop;										// stop the system

@end

extern StateSystem	*stateSystem;

