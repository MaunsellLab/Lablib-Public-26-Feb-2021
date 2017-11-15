//
//  LLPowerCalibrator.h
//  Lablib
//
//  Created by John Maunsell on 10/29/08.
//  Copyright 2008. All rights reserved.
//


@interface LLPowerCalibrator : NSWindowController <NSWindowDelegate> {

	IBOutlet NSArrayController	*arrayController;
    NSString                    *calibrationFolder;
    long                        entries;
    float                       *mWatts;
    float                       *volts;
    
}

@property (readonly) BOOL calibrated;

- (instancetype)initFromFile:(NSURL *)fileURL;
- (instancetype)initWithCalibrationFile:(NSString *)fileName;
- (float)maximumMW;
- (float)maximumV;
- (float)minimumMW;
- (float)minimumV;
- (float)voltageForMW:(float)targetMW;

@end
