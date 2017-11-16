#import "EventView.h"
#import "DataFile.h"

@implementation EventView

#define kXLimitPix     2048
#define kXMarginPix    2

- (void)centerViewOnLine:(long)line
{
    float newYOriginPix;
    NSSize scrollSize;

    scrollSize = self.enclosingScrollView.contentSize;
    newYOriginPix = line * lineHeightPix - scrollSize.height / 2;
    if (newYOriginPix < 0) {
        newYOriginPix = 0;
    }
    [self scrollPoint:NSMakePoint(0, newYOriginPix)]; 
}

- (void)drawRect:(NSRect)rect
{
    long line, topLine, bottomLine;
     
    [[NSColor whiteColor] set];
    [NSBezierPath fillRect:rect];
    [[NSColor blackColor] set]; 
    topLine = rect.origin.y /lineHeightPix;
    bottomLine = (rect.origin.y + rect.size.height) / lineHeightPix;
    if (bottomLine >= lines) {
        bottomLine = lines - 1;
    }
    for (line = topLine; line <= bottomLine; line++) {
        [[document eventString:line] drawAtPoint:NSMakePoint(kXMarginPix, line * lineHeightPix + lineDescenderPix)];
    }
}

- (BOOL)isFlipped
{
    return YES;
}

- (void) mouseDown:(NSEvent *)event
{
    NSPoint downPoint;
    
    downPoint = [self convertPoint:event.locationInWindow fromView:nil];
    [document eventSelectionChanged:(long)(downPoint.y / [document lineHeightPix]) clickCount:event.clickCount];
}

- (void)setDisplayableLines:(long)displayableLines;
{
    lines = displayableLines;
    lineHeightPix = [document lineHeightPix];
    lineDescenderPix = [document lineDescenderPix];
    self.frame = NSMakeRect(0, 0, kXLimitPix, (long)(lines * lineHeightPix - 1));
    [self setNeedsDisplay:YES];
}
@end
