//
//  LLControlPanel.m
//  Lablib
//
//  Created by John Maunsell on 12/27/04.
//  Copyright 2018. All rights reserved.
//

#import "LLControlPanel.h"
#import "LLStandardDataEvents.h"

#define kTextDeltaPix    30

NSString *LLTaskModeButtonKey = @"LLTaskModeButton";
NSString *LLJuiceButtonKey = @"LLJuiceButton";
NSString *LLResetButtonKey = @"LLResetButton";

NSImage *playButton;
NSImage *stopButton;
NSImage *stoppingButton;

@implementation LLControlPanel

- (void)displayFileName:(NSString *)fileName;
{
    if (fileName.length > 0) {
        [self displayText:[NSString stringWithFormat:@"Saving Data to %@", fileName]];
    }
    else {
        [self displayText:@""];
    }
}

- (void)displayText:(NSString *)text;
{
    NSRect frameRect = self.window.frame;
    
    if (text.length == 0 && (NSHeight(frameRect) != originalHeightPix)) {
        frameRect = NSInsetRect(frameRect, 0, kTextDeltaPix);
        frameRect = NSOffsetRect(frameRect, 0, kTextDeltaPix);
        [self.window setFrame:frameRect display:YES animate:YES];
    }
    else if (text.length > 0) {
        if (NSHeight(frameRect) == originalHeightPix) {
            frameRect = NSInsetRect(frameRect, 0, -kTextDeltaPix);
            frameRect = NSOffsetRect(frameRect, 0, -kTextDeltaPix);
            [self.window setFrame:frameRect display:YES animate:YES];
        }
        fileNameDisplay.stringValue = text;
    }
}


- (IBAction)doTaskMode:(id)sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LLTaskModeButtonKey
        object:self];
}

- (IBAction)doJuice:(id)sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LLJuiceButtonKey
        object:self];
}

- (IBAction)doReset:(id)sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LLResetButtonKey
        object:self];
}

- (instancetype)init;
{
    NSString *imagePath;
    
    if ((self = [super initWithWindowNibName:@"LLControlPanel"]) != nil) {
        [self window];                            // Force the window to load now
        originalHeightPix = self.window.frame.size.height;
        if (playButton == nil) {
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"PlayButton" ofType:@"tif"];
            playButton = [[NSImage alloc] initWithContentsOfFile:imagePath];
        }
        if (stopButton == nil) {
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"StopButton" ofType:@"tif"];
            stopButton = [[NSImage alloc] initWithContentsOfFile:imagePath];
        }
        if (stoppingButton == nil) {
            imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"StoppingButton" ofType:@"tif"];
            stoppingButton = [[NSImage alloc] initWithContentsOfFile:imagePath];
        }
        self.window.delegate = self;
    }
    return self;
}

- (void)setResetButtonEnabled:(long)state;
{
    resetButton.enabled = state;
}

- (void)setTaskModeButtonEnabled:(long)state;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        taskModeButton.enabled = state;
    });
}

- (void)setTaskMode:(long)newMode;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        _taskMode = newMode;
        switch (_taskMode) {
        case kTaskRunning:
            [taskModeButton setTitle:NSLocalizedString(@"Stop", @"Stop")];
            [taskModeButton setToolTip:NSLocalizedString(@"Stop", @"Stop")];
            taskModeButton.image = stopButton;
            break;
        case kTaskStopping:
            [taskModeButton setTitle:NSLocalizedString(@"Stop", @"Stop")];
            [taskModeButton setToolTip:NSLocalizedString(@"Stop Now", @"Stop Now")];
            taskModeButton.image = stoppingButton;
            break;
        case kTaskIdle:
            [taskModeButton setTitle:NSLocalizedString(@"Run", @"Run")];
            [taskModeButton setToolTip:NSLocalizedString(@"Run", @"Run")];
            taskModeButton.image = playButton;
            break;
        default:
            break;
        }
    });
}

@end
