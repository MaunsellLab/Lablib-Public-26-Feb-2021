//
//  LLPowerCalibrator.h
//  Lablib
//
//  Created by John Maunsell on 10/29/08.
//  Copyright 2008. All rights reserved.
//


@interface LLPowerCalibrator : NSWindowController <NSWindowDelegate> {

	IBOutlet NSArrayController	*arrayController;
    long                        entries;
    float                       *mWatts;
    float                       *volts;
    
}

@property (readonly) BOOL calibrated;

- (id)initWithFile:(NSString *)fileName;
- (float)maximumMW;
- (float)maximumV;
- (float)minimumMW;
- (float)minimumV;
- (float)voltageForMW:(float)targetMW;

@end
