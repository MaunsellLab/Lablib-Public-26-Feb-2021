//
//  LLStateSystem.m
//  Lablib
//
//  Created by John Maunsell on Sat Mar 29 2003.
//  Copyright (c) 2006. All rights reserved.
//

#import "LLStateSystem.h"

@implementation LLStateSystem

- (void)addState:(LLState *)state;
{
	if ([state name] == nil) {
		NSRunAlertPanel(@"LLStateSystem", @"Attempting to add a state without a valid name", nil, nil, nil);
		return;
	}
	else if ([[state name] isEqualToString:@"-- unnamed LLState --"]) {
		NSRunAlertPanel(@"LLStateSystem", @"Attempting to add a state that does not declare its name", nil, nil, nil);
		return;
	}
	else if ([states objectForKey:[state name]] != nil) {
		NSRunAlertPanel(@"LLStateSystem", @"Attempting to add a second state named %@", nil, nil, nil, [state name]);
		return;
	}
	[states setObject:state forKey:[state name]];
}

- (void)dealloc;
{
	[states release];
	[controller release];
    [super dealloc];
}

- (id)init;
{
	if ((self = [super init])) {
		states = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (BOOL)running;
{
    return [controller running];
}

- (void)setStartState:(LLState *)newStart andStopState:(LLState *)newStop;
{
	if (newStart == nil || newStop == nil) {
		NSRunAlertPanel(@"LLStateSystem", @"Attempting to set a nil start or stop state",
				nil, nil, nil);
	}
	else {
		if (controller == nil) {
			controller = [[LLStateSystemController alloc] initWithStartState:newStart stopState:newStop];
		}
		else {
			[controller setStartState:newStart stopState:newStop];
		}
	}
}

// start the system running

- (BOOL)startWithCheckIntervalMS:(double)checkMS;
{
	if (controller == nil) {
		if ([controller startState] == nil || [controller stopState] == nil) {
			NSRunAlertPanel(@"LLStateSystem", @"Attempting to start the state system valid setting start and stop states",
					nil, nil, nil);
			return NO;
		}
	}
    return [controller startWithCheckIntervalMS:checkMS];
}

- (LLState *)stateNamed:(NSString *)name;
{
	LLState *theState = [states objectForKey:name];
	
	if (theState == nil) {
		NSLog(@"LLStateSystem: Requested state named \"%@\" when none exists with that name", name);
	}
	return theState;
}

// stop the system

- (void)stop;
{
    [controller stop];
}

@end
