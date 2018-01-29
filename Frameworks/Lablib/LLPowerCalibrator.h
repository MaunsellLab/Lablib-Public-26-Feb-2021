//
//  LLPowerCalibrator.h
//  Lablib
//
//  Created by John Maunsell on 10/29/08.
//  Copyright 2008. All rights reserved.
//


@interface LLPowerCalibrator : NSWindowController <NSWindowDelegate> {

    IBOutlet NSArrayController    *arrayController;
    NSString                    *calibrationFolder;
    long                        entries;
    float                       *mWatts;
    float                       *volts;
    
}

@property (readonly) BOOL calibrated;

- (instancetype)initFromFile:(NSURL *)fileURL;
- (instancetype)initWithCalibrationFile:(NSString *)fileName;
@property (NS_NONATOMIC_IOSONLY, readonly) float maximumMW;
@property (NS_NONATOMIC_IOSONLY, readonly) float maximumV;
@property (NS_NONATOMIC_IOSONLY, readonly) float minimumMW;
@property (NS_NONATOMIC_IOSONLY, readonly) float minimumV;
- (float)voltageForMW:(float)targetMW;

@end
