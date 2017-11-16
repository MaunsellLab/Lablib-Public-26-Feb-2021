//
//  LabJackU6Settings.m
//  LabJackU6DataDevice
//
//  Copyright (c) 2016. All rights reserved.
//

#import "LabJackU6Settings.h"

@implementation LabJackU6Settings

- (instancetype)init;
{
    if ((self =  [super initWithWindowNibName:@"LabJackU6Settings"])) {
        [self window];                    // Force window to load
    }
    return self;
}

- (IBAction)ok:(id)sender;
{
    [NSApp stopModal];
}

- (void)runPanel;
{
    [NSApp runModalForWindow:self.window];
    [self.window orderOut:self];
}

@end
