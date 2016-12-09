//
//  LabJackU6MonitorSettings.h
//  Lablib
//
//  Copyright (c) 2016. All rights reserved.
//

@interface LabJackU6MonitorSettings : NSWindowController {

@private
	NSString *IDString;
    id monitor;
    
	IBOutlet NSButton	 	*resetButton;
    IBOutlet NSButton	 	*warnDriftButton;
	IBOutlet NSTextField	*driftLimitField;
}

- (id)initWithID:(NSString *)ID monitor:(id)monitorID;
- (NSString *)uniqueKey:(NSString *)commonKey;

- (IBAction)changeDoWarnDrift:(id)sender;
- (IBAction)changeDriftLimit:(id)sender;
- (IBAction)resetCounters:(id)sender;

@end
