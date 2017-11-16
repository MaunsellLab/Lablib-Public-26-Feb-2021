//
//  LLMonitorController.m
//  Lablib
//
//  Created by John Maunsell on Sat Jun 14 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLMonitorController.h"
#import "LLSystemUtil.h"

NSString *LLMonitorUpdated = @"LL Report Updated";

@implementation LLMonitorController

- (void)addMonitor:(id <LLMonitor>)monitor;
{
    if (monitor == nil) {                       // do nothing if the monitor isn't valid
        return;
    }
    if (monitors.count == 0) {
        [monitorMenu removeAllItems];
    }
    if ([monitorMenu indexOfItemWithTitle:[monitor IDString]] != -1) {
        [LLSystemUtil runAlertPanelWithMessageText:self.className informativeText:[NSString stringWithFormat:
                @"Attempting to add monitor \"%@|' a second time. (You are probably failing to remove it when the plugin is deallocated.)",
                [monitor IDString]]];
        exit(0);
    }
    [monitorMenu insertItemWithTitle:[monitor IDString] atIndex:monitors.count];
    [monitors addObject:monitor];
}

// Respond to a new monitor being selected from the pop-up menu

- (IBAction)changeMonitor:(id)sender {

    [self refresh:self];
}

- (IBAction)configureMonitor:(id)sender {

    if ([monitors[monitorMenu.indexOfSelectedItem] isConfigurable]) {
        [monitors[monitorMenu.indexOfSelectedItem] configure];
    }
}

- (IBAction)freeze:(id)sender {

    frozen = [sender intValue];
    [sender setTitle:(frozen) ? @"Unfreeze" : @"Freeze"];
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [monitors release];
    [super dealloc];
}

- (instancetype)init {
    
    if ((self =  [super initWithWindowNibName:@"LLMonitorController"]) != nil) {
        self.windowFrameAutosaveName = @"LLMonitorController";
        [self window];
        monitors = [[NSMutableArray alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                selector:@selector(monitorUpdated:) name:LLMonitorUpdated object:nil];
    } 
    return self;
}
    
// Get new reports from the selected monitor

- (IBAction)refresh:(id)sender {

    NSAttributedString *textString;
    id <LLMonitor> monitor;
    NSString *datestr;
    
    if ((monitors.count > 0) && [monitors[monitorMenu.indexOfSelectedItem] isConfigurable]) {
        [configureButton setEnabled:YES];
    }
    else {
        [configureButton setEnabled:NO];
    }
    datestr = [LLSystemUtil formattedDateString:[NSDate date] format:@"Updated %H:%M:%S %d %b %Y"];                                 // Update the header field
//    datestr = [[NSCalendarDate calendarDate]                                 // Update the header field
//                descriptionWithCalendarFormat:@"Updated %H:%M:%S %d %b %Y"];
    headerField.stringValue = datestr;
    if (monitors.count == 0) {                                            // No monitors yet
        textString = [[NSAttributedString alloc] initWithString:@"\n\n(No monitors have been assigned)"];
        [textString autorelease];
    }
    else {
        monitor = monitors[monitorMenu.indexOfSelectedItem];
        textString = [monitor report];
    }
    [text.textStorage setAttributedString:textString]; 
}

- (void)monitorUpdated:(NSNotification *)notification;
{
    id<LLMonitor> monitor = notification.object;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!frozen && (monitor == monitors[monitorMenu.indexOfSelectedItem])) {
            [self refresh:self];
        }
    });
}

- (void)removeMonitorWithID:(NSString *)IDString;
{
    NSEnumerator *enumerator = [monitors objectEnumerator];
    id <LLMonitor> monitor;
    
    while (monitor = [enumerator nextObject]) {
        if ([[monitor IDString] isEqualToString:IDString]) {
            [monitorMenu removeItemWithTitle:IDString];
            [monitors removeObject:monitor];
            break;
        }
    }
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

- (IBAction)showWindow:(id)sender {

    BOOL valid = monitors.count > 0;
    
    monitorMenu.enabled = valid;
    freezeButton.enabled = valid;
    refreshButton.enabled = valid;
    [self refresh:self];
    [super showWindow:sender];
}

@end
