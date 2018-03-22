//
//  LLSymbolView.h
//  Lablib
//
//  Created by John Maunsell on 8/16/17.
//
//

typedef NS_ENUM(NSInteger, SymbolStimState) {kStimBlank, kStimOff, kStimOn};

@interface LLSymbolView : NSView  {
@private
    NSBezierPath        *arcPath;
    NSBezierPath        *bluePath;
    SymbolStimState     blueStimState;
    NSBezierPath        *downLever;
    NSBezierPath        *redPath;
    SymbolStimState     redStimState;
    NSBezierPath        *upLever;
}

@property (nonatomic, assign) SymbolStimState leverState;

- (void)setRedState:(SymbolStimState)redState blueState:(SymbolStimState)blueState;

@end
