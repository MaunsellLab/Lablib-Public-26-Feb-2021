//  LabJackU6Monitor.m
//  Lablib
//
//  Copyright (c) 2016. All rights reserved.
//

#import "LabJackU6Monitor.h"
#import <Lablib/LLSystemUtil.h>

NSString *doWarnDriftKey = @"LL LabJackU6 Do Warn Drift";
NSString *driftLimitKey = @"LL LabJackU6 Drift Limit";

@implementation LabJackU6Monitor

- (void)checkWarnings;
{
    double labJackU6SampleTimeMS, CPUMS, driftParts;
    NSString *messageString;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    SEL selector = NSSelectorFromString(@"doAlarm:");

    if (![defaults boolForKey:[self uniqueKey:doWarnDriftKey]]) {
        return;
    }
    if (previous.samplePeriodMS == 0|| previous.sequences < 1) {
        return;
    }
	CPUMS = previous.cumulativeTimeMS;
	labJackU6SampleTimeMS = previous.samples * previous.samplePeriodMS;
	driftParts = ((labJackU6SampleTimeMS + CPUMS) / 2)/(CPUMS - labJackU6SampleTimeMS);
    if (fabs(driftParts) < [defaults integerForKey:[self uniqueKey:driftLimitKey]]) {
		NSLog(@"Warning: LabJackU6 clock drift is %d:%.0f relative to computer.", 
					driftParts >= 0 ? 1 : -1, driftParts);
		NSLog(@"previous.samples: %ld", previous.samples);
		NSLog(@"previous.samplePeriodMS: %f", previous.samplePeriodMS);
		NSLog(@"previous.sequences: %ld", previous.sequences);
		NSLog(@"previous.cumulativeTimeMS: %f", previous.cumulativeTimeMS);
        if (!alarmActive && ![[settings window] isVisible]) {
            messageString = [NSString stringWithFormat:@"Warning: LabJackU6 clock drift is %d:%.0f relative to computer.",
                             driftParts >= 0 ? 1 : -1, driftParts];
            [self performSelectorOnMainThread:selector withObject:messageString waitUntilDone:NO];
        }
	}
}

- (void)configure;
{
	[settings showWindow:self];
}

- (void)dealloc {

	[descriptionString release];
	[IDString release];
	[settings release];
	[super dealloc];
}

- (void)doAlarm:(NSString *)message;
{
    NSAlert *theAlert;

    alarmActive = YES;
    theAlert = [[NSAlert alloc] init];
    [theAlert setMessageText:[NSString stringWithFormat:@"LabJackU6Monitor (%@)", [self IDString]]];
    [theAlert addButtonWithTitle:NSLocalizedString(@"OK", @"OK")];
    [theAlert addButtonWithTitle:NSLocalizedString(@"Disarm Alarm", @"Disarm Hardward Alarm")];
    [theAlert addButtonWithTitle:NSLocalizedString(@"Change Settings", @"Change Hardware Alarm Settings")];
    [theAlert setInformativeText:message];
    switch ([theAlert runModal]) {
    case NSAlertSecondButtonReturn:						// disarm alarms
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[self uniqueKey:doWarnDriftKey]];
        break;
    case NSAlertThirdButtonReturn:
        [self configure];								// configure alarms
        break;
    case NSAlertFirstButtonReturn:						// OK button, do nothing
    default:
        break;
    }
    alarmActive = NO;
    [theAlert release];
}

- (NSString *)IDString {

	return IDString;
}

- (instancetype)initWithID:(NSString *)ID description:(NSString *)description {

    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) != Nil) {

// ID must be set up before doing the default settings

		[ID retain];
		IDString = ID;
		[description retain];
		descriptionString = description;

// Set up all the default settings

		defaultSettings = [[NSMutableDictionary alloc] init];
		[defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:[self uniqueKey:doWarnDriftKey]];
		[defaultSettings setObject:[NSNumber numberWithInt:100] forKey:[self uniqueKey:driftLimitKey]];
		[[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
		[defaultSettings release];

// Default settings should be done before initializing values

		settings = [[LabJackU6MonitorSettings alloc] initWithID:IDString monitor:self];
		[self initValues:&cumulative];
	}
    return self;
}

- (void)initValues:(LabJackU6MonitorValues *)pValues;
{
 	pValues->samples = pValues->sequences = 0;
    pValues->cumulativeTimeMS = 0.0;
}

- (BOOL)isConfigurable {

	return YES;
}

- (NSAttributedString *)report {

	NSMutableString *textString;
    NSDictionary *attr;

	textString = [[[NSMutableString alloc] initWithString:descriptionString] autorelease];

	if (cumulative.sequences == 0) {
		[textString appendString:@"\n\n(No data sequences have been compiled)"];
	}
	else {
		[textString appendString:[NSString stringWithFormat:@"\n\n%ld sampling sequences completed\n\n", 
			cumulative.sequences]];
		if (previous.samples > 0) {
			[textString appendString:@"Last Sequence:\n\n"];
			[textString appendString:[self valueString:&previous]];
		}
		[textString appendString:@"All Sequences:\n\n"];
		[textString appendString:[self valueString:&cumulative]];
	}
    attr = [[[NSDictionary alloc] initWithObjectsAndKeys:
                    [NSFont userFixedPitchFontOfSize:10], NSFontAttributeName,
                    nil] autorelease];
	return [[[NSAttributedString alloc] initWithString:textString attributes:attr] autorelease];
}

- (void)resetCounters {

    [self initValues:&cumulative];
	[[NSNotificationCenter defaultCenter] postNotificationName:LLMonitorUpdated object:self];
}

- (NSString *)valueString:(LabJackU6MonitorValues *)pValues {

    double labJackU6SampleTimeMS, CPUMS;
    NSMutableString *string = [[[NSMutableString alloc] init] autorelease];
    
    CPUMS = pValues->cumulativeTimeMS;
	labJackU6SampleTimeMS = pValues->samples * pValues->samplePeriodMS;
    [string appendString:[NSString stringWithFormat:
                @" Did %.0f ms of samples in %.0f ms (%.1f ms difference, 1:%.0f; ", 
                labJackU6SampleTimeMS, CPUMS, CPUMS - labJackU6SampleTimeMS, ((labJackU6SampleTimeMS + CPUMS) / 2)/(CPUMS - labJackU6SampleTimeMS)]];
	[string appendString:[NSString stringWithFormat:
                @"%.3f-%.3f ms period)\n\n Channel:", 
                pValues->cumulativeTimeMS / (pValues->samples + pValues->sequences), 
                pValues->cumulativeTimeMS / pValues->samples]];

    [string appendString:@"\n  Counts:"];

    [string appendString:@"\n   Per S:"];

    [string appendString:@"\n\n"];

    return [NSString stringWithString:string];
}

// Record the occurrence of an event.  This is the method that should be called 
// when the event being monitored occurs.

- (void)sequenceValues:(LabJackU6MonitorValues)current;
{
	previous = current;									// Save for the report
    cumulative.samplePeriodMS = current.samplePeriodMS;
     
	cumulative.sequences += current.sequences;
	cumulative.cumulativeTimeMS += current.cumulativeTimeMS;
	cumulative.samples += current.samples;
	[self checkWarnings];
	[[NSNotificationCenter defaultCenter] postNotificationName:LLMonitorUpdated object:self];
}

// Because there may be many instances of some objects, we save using keys that are made
// unique by prepending the IDString

- (NSString *)uniqueKey:(NSString *)commonKey {

	return [NSString stringWithFormat:@"%@ %@", IDString, commonKey]; 
}

@end
