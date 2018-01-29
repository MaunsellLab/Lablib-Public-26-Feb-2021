/*
FTStimuli.m
Stimulus generation
December 26, 2004 John Maunsell
*/

#import "FTStimuli.h"
#import "FT.h"
#import <OpenGL/gl.h>

@implementation FTStimuli

- (void) dealloc;
{
    [fixSpot release];
    [super dealloc];
}

- (void)drawFixSpot;
{
    [task.stimWindow lock];
    task.stimWindow.scaleOffsetDeg = task.eyeCalibrator.offsetDeg;
    [task.stimWindow scaleDisplay];
    glClear(GL_COLOR_BUFFER_BIT);
    [fixSpot draw];
    [[NSOpenGLContext currentContext] flushBuffer];
    [task.stimWindow unlock];
}

- (void)erase;
{
    [task.stimWindow lock];
    glClearColor(0.5, 0.5, 0.5, 0);
    glClear(GL_COLOR_BUFFER_BIT);
    [[NSOpenGLContext currentContext] flushBuffer];
    [task.stimWindow unlock];
}

- (LLFixTarget *)fixSpot;
{
    return fixSpot;
}

- (instancetype)init;
{
    if ((self = [super init]) != nil) {
        fixSpot = [[LLFixTarget alloc] init];
        [fixSpot setState:YES];
        [[NSUserDefaults standardUserDefaults] registerDefaults:
                    @{FTFixForeColorKey: [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]]}];
        [[NSUserDefaults standardUserDefaults] registerDefaults:
                    @{FTFixBackColorKey: [NSArchiver archivedDataWithRootObject:[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:1.0]]}];

// For each of the entries in the settings dialog, set the fix spot
// to the current value and set up to receive report when the value changes.
 
        [fixSpot bindValuesToKeysWithPrefix:@"FT"];
        [fixSpot setBackOnRed:0.5 green:0.5 blue:0.5];
    }
    return self;
}
@end
