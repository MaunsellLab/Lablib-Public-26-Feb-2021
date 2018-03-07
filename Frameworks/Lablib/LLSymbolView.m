//
//  LLSymbolView.m
//  Lablib
//
//  Created by John Maunsell on 8/16/17.
//
//

#import "LLSymbolView.h"

@implementation LLSymbolView

@synthesize leverState;

- (void)dealloc;
{
    [arcPath dealloc];
    [redPath dealloc];
    [bluePath dealloc];
    [downLever dealloc];
    [upLever dealloc];
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect;
{
    [self drawStim:redPath state:redStimState color:[NSColor colorWithCalibratedRed:1.0 green:0.1 blue:0.1 alpha:1]];
    [self drawStim:bluePath state:blueStimState color:[NSColor colorWithCalibratedRed:0.3 green:0.2 blue:1.0 alpha:1]];
    if (leverState == kStimBlank) {
        return;
    }
    [[NSColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1] set];
    [arcPath fill];
    [[NSColor blackColor] set];
    downLever.lineWidth = 2.0;
    if (leverState == kStimOn) {
        [downLever stroke];
    }
    else if (leverState == kStimOff) {
        [upLever stroke];
    }
}

- (void)drawStim:(NSBezierPath *)path state:(SymbolStimState)state color:(NSColor *)theColor;
{
    if (state == kStimBlank) {
        return;
    }
    if (state == kStimOn) {
        [theColor set];
        [path fill];
        [[NSColor blackColor] set];
        path.lineWidth = 0.5;
        [path stroke];
    }
    if (state == kStimOff) {
        [theColor set];
        path.lineWidth = 1.0;
        [path stroke];
    }
}

- (instancetype)initWithFrame:(NSRect)frame;
{
    NSRect theRect;
    NSPoint arcCenter;
    double angleDeg = 45.0;
    double angleRad = angleDeg / 90.0 * M_PI / 2.0;

    if ((self = [super initWithFrame:frame]) != nil) {
        blueStimState = redStimState = leverState = kStimBlank;
        theRect = self.bounds;
        theRect = NSInsetRect(theRect, 1, 1);
        theRect.size.width = theRect.size.height;

        redPath = [[NSBezierPath alloc] init];
        [redPath appendBezierPathWithOvalInRect:theRect];

        theRect.origin.x += theRect.size.width * 1.25;
        bluePath = [[NSBezierPath alloc] init];
        [bluePath appendBezierPathWithOvalInRect:theRect];

        theRect.origin.x += theRect.size.width * 1.25;
        arcCenter = NSMakePoint(theRect.origin.x, NSMaxY(theRect));
        upLever = [[NSBezierPath alloc] init];
        [upLever moveToPoint:arcCenter];
        [upLever relativeLineToPoint:NSMakePoint(theRect.size.width, 0)];
        downLever = [[NSBezierPath alloc] init];
        [downLever moveToPoint:arcCenter];
        [downLever relativeLineToPoint:NSMakePoint(theRect.size.width * cos(angleRad),
                                                   -theRect.size.width * sin(angleRad))];

        arcPath = [[NSBezierPath alloc] init];
        [arcPath moveToPoint:arcCenter];
        [arcPath appendBezierPathWithArcWithCenter:arcCenter radius:theRect.size.width
                                                                    startAngle:-angleDeg endAngle:0.0];
        [arcPath closePath];
    }
    return self;
}

- (void)setRedState:(SymbolStimState)redState blueState:(SymbolStimState)blueState;
{
    redStimState = redState;
    blueStimState = blueState;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay:YES];
    });
}

@end
