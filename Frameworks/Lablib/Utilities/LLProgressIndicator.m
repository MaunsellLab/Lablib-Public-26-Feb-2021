//
//  LLProgressIndicator.m
//  Lablib
//
//  Created by John Maunsell on 3/28/06.
//  Copyright 2006. All rights reserved.
//

#import "LLProgressIndicator.h"
#import "LLSystemUtil.h"

#define kUpdateIntervalMS    100

@implementation LLProgressIndicator

- (IBAction)cancel:(id)sender;
{
    cancelled = YES;
}

- (BOOL)cancelled;
{
    return cancelled;
}

- (void)close;
{
    [self.window close];
}

- (instancetype)init;
{
    if ((self = [super initWithWindowNibName:@"LLProgressIndicator"]) != nil) {
        self.windowFrameAutosaveName = @"LLProgressIndicator";
        [self window];
    }
    return self;
}

- (BOOL)needsUpdate;
{
    if (nextTime == 0 || [LLSystemUtil timeIsPast:nextTime]) {
        nextTime = [LLSystemUtil timeFromNow:kUpdateIntervalMS];
        return YES;
    }
    else {
        return NO;
    }
}

- (void)setDoubleValue:(double)doubleValue;
{
    indicator.doubleValue = doubleValue;
}

- (void)setIndeterminate:(BOOL)flag;
{
    indicator.indeterminate = flag;
}

- (void)setMaxValue:(double)newMaxValue;
{
    indicator.maxValue = newMaxValue;
}

- (void)setMinValue:(double)newMinValue;
{
    indicator.minValue = newMinValue;
}

- (void)setText:(NSString *)string;
{
    message.stringValue = string;
}

- (void)setTitle:(NSString *)string;
{
    self.window.title = string;
}

- (void)windowDidLoad;
{
    [indicator setIndeterminate:NO];
}

@end
