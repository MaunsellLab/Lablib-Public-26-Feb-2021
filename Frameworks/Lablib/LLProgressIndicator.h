//
//  LLProgressIndicator.h
//  Lablib
//
//  Created by John Maunsell on 3/28/06.
//  Copyright 2006. All rights reserved.
//

@interface LLProgressIndicator : NSWindowController {

    BOOL            cancelled;
    NSTimeInterval    nextTime;
    
    IBOutlet NSProgressIndicator    *indicator;
    IBOutlet NSTextField            *message;
}

@property (NS_NONATOMIC_IOSONLY, readonly) BOOL cancelled;
- (void)close;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL needsUpdate;
- (void)setDoubleValue:(double)doubleValue;
- (void)setIndeterminate:(BOOL)flag;
- (void)setMaxValue:(double)newMaxValue;
- (void)setMinValue:(double)newMinValue;
- (void)setText:(NSString *)string;
- (void)setTitle:(NSString *)string;

- (IBAction)cancel:(id)sender;

@end
