//
//  LLStimWindow.m
//  Lablib
//
//  Created by John Maunsell on Sun December 26, 2004.
//  Copyright (c) 2003-2006. All rights reserved.
//

#import "LLStimWindow.h"
#import "LLSystemUtil.h"
#define GL_SILENCE_DEPRECATION
#import <OpenGL/gl.h>

#define kDefaultDisplayIndex    1        // Index of stim display when more than one display
#define kMainDisplayIndex        0        // Index of main stimulus display
#define kPixelDepthBits            32        // Depth of pixels in stimulus window
#define kStimWindowFactor       5       // How much to reduce the size of stim window relative to display
#define    stimWindowSizePix        500        // Height and width of stim window on main display

#define kLLMidGray                0.5
#define kPI                        (atan(1) * 4)
#define kDegPerRadian            (180.0 / kPI)

#define kAdjusted(color, contrast)  (kLLMidGray + (color - kLLMidGray) / 100.0 * contrast)

@interface LLStimWindow()

@property BOOL visibleOnScreen;

@end

@implementation LLStimWindow

// We needed to add the following method when we went to 10.7 and changed from capturing the screen device to making
// a window that filled the screen.  When the dispay resolution is changed, the frame of the window needs to be changed.
// This is done, but the OS ends up posting an _adjustWindowToScreen event to the NSWindow, which makes it offset 
// its origin in some strange way.  Switching between tasks that didn't change the mode seemed to fix the offset 
// (through repeated changes to the window frame, but that was unacceptale. The following method intercepts the 
// event that is causing the problem.

- (void)_adjustWindowToScreen;
{
}

- (NSPoint)centerPointPix;
{
    NSRect r;
    
    r = [displays displayBounds:displayIndex];
    return NSMakePoint(NSMidX(r), NSMidY(r));
}

- (NSPoint)centerPointPixLLOrigin;
{
    NSRect r;
    
    r = [displays displayBoundsLLOrigin:displayIndex];
    return NSMakePoint(NSMidX(r), NSMidY(r));
}

- (void) dealloc;
{
    [monitor release];
    [displays release];
    [openGLLock release];
    [super dealloc];
}

- (NSPoint)degPointFromPixPoint:(NSPoint)pointPix;
{
    NSPoint pointDeg;
    NSSize displayDeg;
    long heightPix, widthPix;

    heightPix = self.contentView.bounds.size.height;
    widthPix = self.contentView.bounds.size.width;
    displayDeg = [displays displaySizeDeg:displayIndex];
    pointDeg.x = -displayDeg.width / 2.0 - scaleOffsetDeg.x + pointPix.x / widthPix * displayDeg.width;
    pointDeg.y = -displayDeg.height / 2.0 - scaleOffsetDeg.y + pointPix.y / heightPix * displayDeg.height;
    return pointDeg;
}

- (NSSize)degSizeFromPixSize:(NSSize)sizePix;
{
    NSSize sizeDeg;
    NSSize displayDeg;
    long heightPix, widthPix;
    heightPix = self.contentView.bounds.size.height;
    widthPix = self.contentView.bounds.size.width;
    displayDeg = [displays displaySizeDeg:displayIndex];
    sizeDeg.width = sizePix.width / widthPix * displayDeg.width;
    sizeDeg.height = sizePix.height / heightPix * displayDeg.height;
    return sizeDeg;
}

//- (DisplayParam)display;
//{
//    return display;
//}

- (long)displayIndex;
{
    return displayIndex;
}

- (DisplayParam *)displayParameters;
{
    return &display;
}

// Return a rectangle with the scale of the display in degrees

- (NSRect)displayRectDeg;
{
    NSSize displayDeg = [displays displaySizeDeg:displayIndex];    // get current display size
    
    return NSMakeRect(-displayDeg.width / 2.0 - scaleOffsetDeg.x, -displayDeg.height / 2.0 - scaleOffsetDeg.y, 
            displayDeg.width, displayDeg.height);
}

- (NSSize)displaySizeDeg;
{
    return [displays displaySizeDeg:displayIndex];
}

- (LLDisplays *)displays;
{
    return displays;
}

- (void)erase;
{
    [self lock];
    glClear(GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    [[NSOpenGLContext currentContext] flushBuffer];
    [self unlock];
}

- (void)flushBuffer;
{
    [[NSOpenGLContext currentContext] flushBuffer];
}

- (float)frameRateHz;
{
    return [displays frameRateHz:displayIndex];
}

- (BOOL)fullscreen;
{
    return fullscreen;
}

- (void)grayScreen;
{
    if (self.visibleOnScreen) {
        [self lock];
        glClearColor(kLLMidGray, kLLMidGray, kLLMidGray, 0);
        glClear(GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
        [[NSOpenGLContext currentContext] flushBuffer];
        glFinish();
        [self unlock];
    }
    else {
        NSLog(@"LLStimWindow: grayScreen: Screen not visible");
    }
}

- (instancetype)initWithDisplayIndex:(long)dIndex contentRect:(NSRect)cRect;
{
    NSRect dRect;
    NSSize stimWindowSize;
    const GLint swapParam = 1;
    NSOpenGLPixelFormatAttribute windowedAttrib[] = {
        NSOpenGLPFANoRecovery, NSOpenGLPFAAccelerated, NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAColorSize, (NSOpenGLPixelFormatAttribute) 24,
        NSOpenGLPFAAlphaSize, (NSOpenGLPixelFormatAttribute) 8,
        NSOpenGLPFADepthSize, (NSOpenGLPixelFormatAttribute) 0,
        NSOpenGLPFAStencilSize, (NSOpenGLPixelFormatAttribute) 8,
        NSOpenGLPFAAccumSize, (NSOpenGLPixelFormatAttribute) 0,
        0                       // must be null terminated
                                //        NSOpenGLPFAWindow, (NSOpenGLPixelFormatAttribute) 0
    };
    NSOpenGLPixelFormat *fmt;

    if (dIndex < 0) {
        return nil;
    }
    switch (dIndex) {
        case 0:                                        // only one display, create stimulus window on it
            self = [super initWithContentRect:cRect
                    styleMask:NSTitledWindowMask | NSMiniaturizableWindowMask | NSResizableWindowMask
                    backing:NSBackingStoreBuffered defer:NO];
            break;
        case 1:                                                 // more than one screen, we're using the second one
        default:                                                //   regardless of the number of screens
            self = [super initWithContentRect:cRect styleMask:NSBorderlessWindowMask
                    backing:NSBackingStoreBuffered defer:NO];
            fullscreen = YES;                                   // flag fullscreen mode
            self.level = NSMainMenuWindowLevel + 1;          // move window to front of all windows
            break;
    }
    displayIndex = dIndex;                          // with self initialized, we can now use instance variables
    openGLLock = [[NSLock alloc] init];
    displays = [[LLDisplays alloc] init];
    display = [displays displayParameters:displayIndex];    // get the stimulus display parameters
    if (fullscreen) {
        if ([displays setDisplayMode:displayIndex size:CGSizeMake(display.widthPix, display.heightPix)
                            bitDepth:display.pixelBits frameRate:display.frameRateHz]) {
            [displays dumpCurrentDisplayMode:(int)displayIndex];
        }
    }
    else {
        dRect = [displays displayBoundsLLOrigin:displayIndex];
        stimWindowSize.width = dRect.size.width / kStimWindowFactor;
        stimWindowSize.height = dRect.size.height / kStimWindowFactor;
        self.contentAspectRatio = stimWindowSize;
        [self setTitle:NSLocalizedString(@"Stimulus", @"Stimulus Window Title")];
    }
    self.delegate = self;                // set up to receive delegate messages (for resize)
    fmt = [[[NSOpenGLPixelFormat alloc] initWithAttributes:windowedAttrib] autorelease];
    if (fmt == nil) {
        NSLog(@"Cannot create NSOpenGLPixelFormat");
        [self autorelease];
        return nil;
    }
    self.contentView = [[[NSOpenGLView alloc] initWithFrame:NSMakeRect(0, 0, display.widthPix, display.heightPix)
                                                  pixelFormat:fmt] autorelease];
    stimOpenGLContext = [self.contentView openGLContext];
    [stimOpenGLContext makeCurrentContext];
    [stimOpenGLContext setValues:&swapParam forParameter:NSOpenGLCPSwapInterval];
    [self makeKeyAndOrderFront:nil];
//    [self grayScreen];
    contentBounds = self.contentView.bounds;
    monitor = [[LLIntervalMonitor alloc] initWithID:@"Stimulus" description:@"Stimulus frame intervals"];
    [monitor setTargetIntervalMS:1000.0 / display.frameRateHz];
    return self;
}

- (LLIntervalMonitor *)monitor;
{
    return monitor;
}

// We get an NSOpenGLBalanceCurrentContext() error if we try to access self.contentView before the window has
// appeared on the screen.  Check that the window is visible.

- (void)lock;
{
    if (!self.visibleOnScreen) {
        return;
    }
    [openGLLock lock];
    [stimOpenGLContext makeCurrentContext];
    if ([NSThread isMainThread]) {
        if (self.contentView) {
            [self.contentView lockFocusIfCanDraw];
        }
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            if (self.contentView) {
                [self.contentView lockFocusIfCanDraw];
            }
        });
    }
}

// Returns whether the mouse is current in the window

- (BOOL)mouseInside;
{
    return NSPointInRect(self.mouseLocationOutsideOfEventStream, contentBounds);
}

// Return the current moust location, scaled to degree

- (NSPoint)mouseLocationDeg;
{
    NSPoint mousePix, mouseDeg;
    NSSize displayDeg;
    long heightPix, widthPix;

    mousePix = self.mouseLocationOutsideOfEventStream;
    displayDeg = [displays displaySizeDeg:displayIndex];
    heightPix = self.contentView.bounds.size.height;
    widthPix = self.contentView.bounds.size.width;
    mouseDeg.x = -displayDeg.width / 2.0 - scaleOffsetDeg.x + mousePix.x / widthPix * displayDeg.width;
    mouseDeg.y = -displayDeg.height / 2.0 - scaleOffsetDeg.y + mousePix.y / heightPix * displayDeg.height;
    return mouseDeg;
}

- (NSPoint)pixPointFromDegPoint:(NSPoint)pointDeg;
{
    NSPoint pointPix;
    NSSize displayDeg;
    long heightPix, widthPix;

    heightPix = self.contentView.bounds.size.height;
    widthPix = self.contentView.bounds.size.width;
    displayDeg = [displays displaySizeDeg:displayIndex];
    pointPix.x = widthPix / 2 + widthPix * (pointDeg.x + scaleOffsetDeg.x) / displayDeg.width;
    pointPix.y = heightPix / 2 + heightPix * (pointDeg.y + scaleOffsetDeg.y) / displayDeg.height;
    return pointPix;
}

- (NSSize)pixSizeFromDegSize:(NSSize)sizeDeg;
{
    NSSize sizePix;
    NSSize displayDeg;
    long heightPix, widthPix;
    heightPix = self.contentView.bounds.size.height;
    widthPix = self.contentView.bounds.size.width;
    displayDeg = [displays displaySizeDeg:displayIndex];
    sizePix.width = sizeDeg.width / displayDeg.width * widthPix;
    sizePix.height = sizeDeg.height / displayDeg.height * heightPix;
    return sizePix;
}

// Set the OpenGL scaling.  Assumes that the currentContext has been correctly set up.

- (void)setScaleOffsetDeg:(NSPoint)offsetDeg;
{
    scaleOffsetDeg = offsetDeg;
}

- (BOOL)setDisplayMode:(DisplayModeParam)newMode;
{
    
// First check whether we already have an acceptable display set up

    newMode.frameRateHz = (newMode.frameRateHz == 0) ? display.frameRateHz : newMode.frameRateHz;
    newMode.pixelBits = (newMode.pixelBits == 0) ? display.pixelBits : newMode.pixelBits;
    newMode.widthPix = (newMode.widthPix == 0) ? display.widthPix : newMode.widthPix;
    newMode.heightPix = (newMode.heightPix == 0) ? display.heightPix : newMode.heightPix;
    if (newMode.frameRateHz == display.frameRateHz &&  newMode.pixelBits == display.pixelBits &&
                    newMode.widthPix == display.widthPix && newMode.heightPix == display.heightPix) {
        return YES;                                             // already using this mode, do nothing
    }
    if (displayIndex != 0) {                                    // fullscreen display?
        [openGLLock lock];
        [displays setDisplayMode:displayIndex size:CGSizeMake(newMode.widthPix, newMode.heightPix) 
                   bitDepth:newMode.pixelBits frameRate:newMode.frameRateHz];
        [displays dumpCurrentDisplayMode:(int)displayIndex];
        display = [displays displayParameters:displayIndex];        // get new display parameters
        [monitor setTargetIntervalMS:1000.0 / display.frameRateHz];    // assign monitor new framerate
        [self setFrame:[displays displayBoundsLLOrigin:displayIndex] display:NO];
        [stimOpenGLContext makeCurrentContext];
        glViewport(0, 0, (int)display.widthPix, (int)display.heightPix);
        [openGLLock unlock];
    }
//    [self grayScreen];
    return YES;
}

- (void)scaleDisplay;
{
    NSSize displayDeg = [displays displaySizeDeg:displayIndex];    // get current display size;

// Set up the calibration, including the offset
// We do not need to lock, because this is called from within functions that lock.

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-displayDeg.width / 2.0 - scaleOffsetDeg.x, displayDeg.width / 2.0 - scaleOffsetDeg.x, 
            -displayDeg.height / 2.0 - scaleOffsetDeg.y, displayDeg.height / 2.0 - scaleOffsetDeg.y, -1.0, 1.0);
}

- (NSPoint)scaleOffsetDeg;
{
    return scaleOffsetDeg;
}

- (void)showDisplayParametersPanel {

    [displays showDisplayParametersPanel:displayIndex];
}

// Locking won't happen if lock is called before the window is ready.  Test whether the openGLLock is actually
// locked before doing the unlock.

- (void)unlock;
{
    if ([openGLLock tryLock]) {
        [openGLLock unlock];
        return;
    }
    glFlush();                                                        // flush any pending commands
    if ([NSThread isMainThread]) {
        [self.contentView unlockFocus];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^(void) {
            [self.contentView unlockFocus];
        });
    }
    [openGLLock unlock];
}

- (void)windowDidChangeOcclusionState:(NSNotification *)notification
{
    self.visibleOnScreen = self.occlusionState & NSWindowOcclusionStateVisible;
    if (self.visibleOnScreen) {
        [self grayScreen];
    }
}

-(NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
{
    display.widthPix = frameSize.width;
    display.heightPix = frameSize.height;
    [stimOpenGLContext makeCurrentContext];
    glViewport(0, 0, (GLint)display.widthPix, (GLint)display.heightPix);
    dispatch_async(dispatch_get_main_queue(), ^{
        contentBounds = self.contentView.bounds;
    });
    return frameSize;
}

@end
