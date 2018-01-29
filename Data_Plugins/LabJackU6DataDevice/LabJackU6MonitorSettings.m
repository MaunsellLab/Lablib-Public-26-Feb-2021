//
//  LabJackU6MonitorSettings.m
//  Lablib
//
//  Copyright (c) 2016. All rights reserved.
//

#import "LabJackU6MonitorSettings.h"
#import "LabJackU6Monitor.h"

@implementation LabJackU6MonitorSettings

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

- (instancetype)initWithID:(NSString *)ID monitor:(id)monitorID {

    if ((self = [super initWithWindowNibName:@"LabJackU6MonitorSettings"]) != Nil) {
        [ID retain];
        IDString = ID;
        monitor = monitorID;
        self.window.title = IDString;             // Force window to load now
        self.windowFrameAutosaveName = [self uniqueKey:@"LabJackU6MonitorSettings"];
    }
    return self;
}

- (IBAction)resetCounters:(id)sender {

    [monitor resetCounters];
}

- (void)showWindow:(id)sender {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    warnDriftButton.intValue = (int)[defaults integerForKey:[self uniqueKey:doWarnDriftKey]];
    driftLimitField.intValue = (int)[defaults integerForKey:[self uniqueKey:driftLimitKey]];
    [super showWindow:sender];
}

// Because there may be many instances of some objects, we save using keys that are made
// unique by prepending the IDString

- (NSString *)uniqueKey:(NSString *)commonKey {

    return [NSString stringWithFormat:@"%@ %@", IDString, commonKey]; 
}


@end
