//
//  LLITCMonitorSettings.m
//  Lablib
//
//  Created by John Maunsell on Thu Jul 31 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLITCMonitorSettings.h"
#import "LLITCMonitor.h"

@implementation LLITCMonitorSettings

- (IBAction)changeDoWarnDrift:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue]
				forKey:[self uniqueKey:doWarnDriftKey]];
}

- (IBAction)changeDriftLimit:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:driftLimitKey]];
}

- (void)dealloc {

	[IDString release];
	[super dealloc];
}

- (id)initWithID:(NSString *)ID monitor:(id)monitorID {

	if ((self = [super initWithWindowNibName:@"LLITCMonitorSettings"]) != Nil) {
		[ID retain];
		IDString = ID;
        monitor = monitorID;
		[[self window] setTitle:IDString]; 			// Force window to load now
        [self setWindowFrameAutosaveName:[self uniqueKey:@"LLITCMonitorSettings"]];
	}
	return self;
}

- (IBAction)resetCounters:(id)sender {

    [monitor resetCounters];
}

- (void)showWindow:(id)sender {

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [warnDriftButton setIntValue:(int)[defaults integerForKey:[self uniqueKey:doWarnDriftKey]]];
    [driftLimitField setIntValue:(int)[defaults integerForKey:[self uniqueKey:driftLimitKey]]];
	[super showWindow:sender];
}

// Because there may be many instances of some objects, we save using keys that are made
// unique by prepending the IDString

- (NSString *)uniqueKey:(NSString *)commonKey {

	return [NSString stringWithFormat:@"%@ %@", IDString, commonKey]; 
}


@end
