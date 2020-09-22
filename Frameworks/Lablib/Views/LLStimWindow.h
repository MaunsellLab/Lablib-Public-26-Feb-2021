//
//  LLStimWindow.h
//  Lablib
//
//  Created by John Maunsell on Sun May 04 2003.
//  Copyright (c) 2004. All rights reserved.
//

#import <Lablib/LLDisplays.h>
#import <Lablib/LLIntervalMonitor.h>

@interface LLStimWindow : NSWindow <NSWindowDelegate> { 

@protected
    NSRect                  contentBounds;
    double                    contrast;
    DisplayParam            display;
    long                    displayIndex;
    LLDisplays                *displays;
    long                    durationMS;
    BOOL                    fullscreen;
    LLIntervalMonitor         *monitor;
    NSLock                    *openGLLock;
    NSPoint                    scaleOffsetDeg;
    NSOpenGLContext         *stimOpenGLContext;
    BOOL                    stimulating;
}

@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint centerPointPix;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint centerPointPixLLOrigin;
- (NSPoint)degPointFromPixPoint:(NSPoint)pointPix;
- (NSSize)degSizeFromPixSize:(NSSize)sizePix;
@property (NS_NONATOMIC_IOSONLY, readonly) long displayIndex;
@property (NS_NONATOMIC_IOSONLY, readonly) DisplayParam *displayParameters;
@property (NS_NONATOMIC_IOSONLY, readonly) NSRect displayRectDeg;
@property (NS_NONATOMIC_IOSONLY, readonly) NSSize displaySizeDeg;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLDisplays *displays;
- (void)erase;
- (void)flushBuffer;
@property (NS_NONATOMIC_IOSONLY, readonly) float frameRateHz;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL fullscreen;
- (void)grayScreen;
- (instancetype)initWithDisplayIndex:(long)displayIndex contentRect:(NSRect)cRect;
- (void)lock;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLIntervalMonitor *monitor;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL mouseInside;
@property (NS_NONATOMIC_IOSONLY, readonly) NSPoint mouseLocationDeg; 
- (NSPoint)pixPointFromDegPoint:(NSPoint)pointDeg;
- (NSSize)pixSizeFromDegSize:(NSSize)sizeDeg;
- (void)scaleDisplay;
@property (NS_NONATOMIC_IOSONLY) NSPoint scaleOffsetDeg;
- (BOOL)setDisplayMode:(DisplayModeParam)mode;
- (void)showDisplayParametersPanel;
- (void)unlock;

@end
