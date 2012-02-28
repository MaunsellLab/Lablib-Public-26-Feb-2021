//
//  LLSynthDataDevice.h
//  Lablib
//
//  Created by John Maunsell on Monday September 26, 2005.
//  Copyright (c) 2005. All rights reserved.
//

#import "LLDataDevice.h"
#import "LLEyeCalibrator.h"
#import "LLSynthDataSettings.h"
#import "LLSynthSaccade.h"

#define kLLSynthADChannels				8
#define kLLSynthDigitalBits				16
#define kLLSynthSamplePeriodMS			5.0
#define kLLSynthTimestampPeriodMS		1

extern NSString *LLSynthEyeBreakKey;
extern NSString *LLSynthEyeIgnoreKey;
extern NSString *LLSynthEyeIntervalKey;
extern NSString *LLSynthEyeNoiseKey;
extern NSString *LLSynthLeverBitKey;
extern NSString *LLSynthLeverLatencyKey;
extern NSString *LLSynthLeverIgnoreKey;
extern NSString *LLSynthLeverDownKey;
extern NSString *LLSynthLeverUpKey;
extern NSString *LLSynthM11Key;
extern NSString *LLSynthM12Key;
extern NSString *LLSynthM21Key;
extern NSString *LLSynthM22Key;
extern NSString *LLSynthSpikesKey;
extern NSString *LLSynthSpikesRandomKey;
extern NSString *LLSynthTXKey;
extern NSString *LLSynthTYKey;
extern NSString *LLSynthVBLKey;
extern NSString *LLSynthVBLRateKey;

@interface LLSynthDataDevice : LLDataDevice {

	NSUserDefaults		*defaults;
	NSAffineTransform	*degToUnits;
    LLEyeCalibrator 	*eyeCalibrator;
    NSPoint 			eyePosition;
    NSPoint				eyeTargetDeg;
    BOOL				eyeTargetPresent;
    double				lastLeverDownTimeS;
    double				lastLeverUpTimeS;
    double				lastSpikeTimeS;
 	long				lastSpontBreakCheckTimeS;
    double				lastSpontDownCheckTimeS;
    double				lastSpontUpCheckTimeS;
	double 				leverDownTimeS;
    double				leverUpTimeS;
    BOOL				leverIsDown;
    double				nextRateTimeS;
    double				nextSaccadeTimeS;
    double 				nextSampleTimeS;
    double				nextSpikeRateHz;
    double				nextSpikeTimeS;						// next time for periodic spike
    double 				nextVBLTimeS;						// next time for a vertical blank timestamp
	NSPoint				offsetDeg;
    BOOL				randomSpikes;
	LLSynthSaccade		*saccade;
	NSMutableData		*sampleData[kLLSynthADChannels];
    double				spikeRateHz;
	LLSynthDataSettings	*synthSettings;
	NSMutableData		*timestampData[kLLSynthDigitalBits];
	double				timestampRefS;
	NSAffineTransformStruct transform;
}

- (void)doLeverDown;
- (void)doLeverUp;
- (void)loadAffineTransform;
- (void)setEyeTargetOff;
- (void)setEyeTargetOn:(NSPoint)target;
- (void)setNextSaccadeTimeS:(double)nextTimeS;
- (void)setOffsetDeg:(NSPoint)newOffset;
- (void)setSpikePeriodic;
- (void)setSpikeRandom;
- (void)setSpikeRateHz:(double)rate atTime:(double)changeTimeS;
- (void)spikeData;
- (void)updateEyePosition:(double)timeNowS;
- (void)VBLData;

@end
