//
//  StateSystem.m
//  Experiment
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "StateSystem.h"
#import "UtilityFunctions.h"

#import "BlockedState.h"
#import "EndtrialState.h"
#import "FixonState.h"
#import "GapState.h"
#import "IdleState.h"
#import "IntertrialState.h"
#import "PoststimState.h"
#import "PrestimState.h"
#import "ReactState.h"
#import "SaccadeState.h"
#import "StartState.h"
#import "StarttrialState.h"
#import "IntervalOneState.h"
#import "IntervalTwoState.h"
#import "StopState.h"
#import "TargetsOnState.h"

long 					eotCode;			// End Of Trial code
BOOL 					fixated;
LLEyeWindow				*fixWindow;
BOOL					hadLeverDown;
BOOL					leverIsDown;
LLEyeWindow				*respWindows[kIntervals];
LLScheduleController	*scheduler;
StateSystem				*stateSystem;
TrialDesc				trial;

@implementation StateSystem

- (void)dealloc {

    [blocked release]; 
    [endtrial release]; 
    [fixon release]; 
    [idle release]; 
    [gap release]; 
    [intertrial release]; 
    [prestim release]; 
    [poststim release]; 
    [react release]; 
    [saccade release]; 
    [start release]; 
    [starttrial release]; 
    [intervalOne release]; 
    [intervalTwo release]; 
    [stop release];
    [targetsOn release];
    
    [fixWindow release];
	[respWindows[kFirst] release];
	[respWindows[kSecond] release];
	[trialBlock release];
	[controller release];
	[scheduler release];
    [super dealloc];
}

- (id)init {

	long interval;
	
    if ((self = [super init]) != Nil) {

// create & initialize the state system's states

		blocked = [[BlockedState alloc] init];
        endtrial = [[EndtrialState alloc] init];
        fixon = [[FixonState alloc] init];
        gap = [[GapState alloc] init];
        idle = [[IdleState alloc] init];
        intertrial = [[IntertrialState alloc] init];
        intervalOne = [[IntervalOneState alloc] init];
        intervalTwo = [[IntervalTwoState alloc] init];
        poststim = [[PoststimState alloc] init];
        prestim = [[PrestimState alloc] init];
        react = [[ReactState alloc] init];
        saccade = [[SaccadeState alloc] init];
        start = [[StartState alloc] init];
        starttrial = [[StarttrialState alloc] init];
        stop =  [[StopState alloc] init];
        targetsOn =  [[TargetsOnState alloc] init];
		
		fixWindow = [[LLEyeWindow alloc] init];
		[fixWindow setWidthAndHeightDeg:[defaults floatForKey:fixWindowWidthKey]];
		for (interval = kFirst; interval < kIntervals; interval++) {
			respWindows[interval] = [[LLEyeWindow alloc] init];
			[respWindows[interval] setWidthAndHeightDeg:[defaults 
						floatForKey:respWindowWidthKey]];
		}

// Initialize the trialBlock that keeps track of trials and blocks

		trialBlock = [[LLTrialBlock alloc] 
				initWithTrialCount:[[NSUserDefaults standardUserDefaults] integerForKey:contrastsKey]
				triesCount:[defaults integerForKey:triesKey]
				blockCount:[defaults integerForKey:blockLimitKey]];
		scheduler = [[LLScheduleController alloc] init];
        controller = [[LLStateSystem alloc] initWithStartState:start stopState:stop];
//		[controller setLogging:YES];
        stateSystem = self;
		stimType = -1;
    }
    return self;
}

- (BOOL) running {

    return [controller running];
}

- (BOOL) startWithCheckIntervalMS:(double)checkMS {			// start the system running

    return [controller startWithCheckIntervalMS:checkMS];
}

- (void) stop {										// stop the system

    [controller stop];
}

// Methods related to data events follow:

// Respond to a change in the number of blocks

- (void) blockLimit:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	long limit;
	
	[eventData getBytes:&limit];
	[trialBlock setBlocks:limit];
}

- (void) contrastStimParams:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	StimParams stimParams;
	
	if (stimType >= 0 && stimType == kVisualStimulus) {
		[eventData getBytes:&stimParams];
        [trialBlock setTrialCount:stimParams.levels];
		[trialBlock reset];
	}
}

- (void) currentStimParams:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	StimParams stimParams;
	
	if (stimType >= 0 && stimType == kElectricalStimulus) {
		[eventData getBytes:&stimParams];
        [trialBlock setTrialCount:stimParams.levels];
		[trialBlock reset];
	}
}

// When the stimulus type changes, we need to change the number of trials per block
// and reset the counters.

- (void) stimulusType:(NSData *)eventData eventTime:(NSNumber *)eventTime {

    long newStimType;
	StimParams *pStimParams;
	
	[eventData getBytes:&newStimType];
    if (stimType != newStimType) {
        stimType = newStimType;
		pStimParams = getStimParams(stimType);
        [trialBlock setTrialCount:pStimParams->levels];
		[trialBlock reset];
	}
}

- (void) reset:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	[trialBlock reset];
	
// The indirect way of calling reset in the end trial state is used to avoid a circularity
// in header files refrences.

	[endtrial performSelector:@selector(reset)];
}

- (void) tries:(NSData *)eventData eventTime:(NSNumber *)eventTime {

	long tries;
	
	[eventData getBytes:&tries];
	[trialBlock setTriesCount:tries];
}

@end
