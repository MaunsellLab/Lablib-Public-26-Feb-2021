//
//  LLIntervalMonitorSettings.m
//  Lablib
//
//  Created by John Maunsell on Thu Jul 31 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLIntervalMonitorSettings.h"
#import "LLIntervalMonitor.h"


@implementation LLIntervalMonitorSettings

- (IBAction)changeDoSuccessGreater:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doSuccessGreaterKey]];
}

- (IBAction)changeDoSuccessLess:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doSuccessLessKey]];
}

- (IBAction)changeDoWarnDisarm:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doWarnDisarmKey]];
}

- (IBAction)changeDoWarnGreater:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doWarnGreaterKey]];
}

- (IBAction)changeDoWarnLess:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doWarnLessKey]];
}

- (IBAction)changeDoWarnSequential:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:doWarnSequentialKey]];
}

- (IBAction)changeSuccessGreaterCount:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:successGreaterCountKey]];
}

- (IBAction)changeSuccessGreaterMS:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue]
				forKey:[self uniqueKey:successGreaterMSKey]];
}

- (IBAction)changeSuccessLessCount:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:successLessCountKey]];
}

- (IBAction)changeSuccessLessMS:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue]
				forKey:[self uniqueKey:successGreaterMSKey]];
}

- (IBAction)changeWarnGreaterCount:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:warnGreaterCountKey]];
}

- (IBAction)changeWarnGreaterMS:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue]
				forKey:[self uniqueKey:warnGreaterMSKey]];
}

- (IBAction)changeWarnLessCount:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:warnLessCountKey]];
}

- (IBAction)changeWarnLessMS:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue]
				forKey:[self uniqueKey:warnLessMSKey]];
}

- (IBAction)changeWarnSequentialCount:(id)sender {

	[[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] 
				forKey:[self uniqueKey:warnSequentialCountKey]];
}

- (void)dealloc {

	[IDString release];
	[super dealloc];
}

- (id)initWithID:(NSString *)ID {

	if ((self = [super initWithWindowNibName:@"LLIntervalMonitorSettings"]) != nil) {
		[ID retain];
		IDString = ID;
		[[self window] setTitle:IDString]; 			// Force window to load now
        [self setWindowFrameAutosaveName:[self uniqueKey:@"LLIntervalMonitorSettings"]];
	}
	return self;
}

- (void)showWindow:(id)sender {

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [successGreaterButton setIntValue:[defaults integerForKey:[self uniqueKey:doSuccessGreaterKey]]];
    [successGreaterCountField setIntValue:[defaults integerForKey:[self uniqueKey:successLessCountKey]]];
    [successGreaterMSField setIntValue:[defaults integerForKey:[self uniqueKey:successLessMSKey]]];

    [successLessButton setIntValue:[defaults integerForKey:[self uniqueKey:doSuccessLessKey]]];
    [successLessCountField setIntValue:[defaults integerForKey:[self uniqueKey:successGreaterCountKey]]];
    [successLessMSField setIntValue:[defaults integerForKey:[self uniqueKey:successGreaterMSKey]]];

    [warnDisarmButton setIntValue:[defaults integerForKey:[self uniqueKey:doWarnDisarmKey]]];
    [warnGreaterButton setIntValue:[defaults integerForKey:[self uniqueKey:doWarnGreaterKey]]];
    [warnLessButton setIntValue:[defaults integerForKey:[self uniqueKey:doWarnLessKey]]];
    [warnSequentialButton setIntValue:[defaults integerForKey:[self uniqueKey:doWarnSequentialKey]]];
	
    [warnGreaterCountField setIntValue:[defaults integerForKey:[self uniqueKey:warnGreaterCountKey]]];
    [warnGreaterMSField setIntValue:[defaults integerForKey:[self uniqueKey:warnGreaterMSKey]]];
    [warnLessCountField setIntValue:[defaults integerForKey:[self uniqueKey:warnLessCountKey]]];
    [warnLessMSField setIntValue:[defaults integerForKey:[self uniqueKey:warnLessMSKey]]];

	[super showWindow:sender];
}

// Because there may be many instances of some objects, we save using keys that are made
// unique by prepending the IDString

- (NSString *)uniqueKey:(NSString *)commonKey {

	return [NSString stringWithFormat:@"%@ %@", IDString, commonKey]; 
}


@end
