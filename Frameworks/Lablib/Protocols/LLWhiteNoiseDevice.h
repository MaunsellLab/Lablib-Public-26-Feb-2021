/*
 *  LLWhiteNoiseDevice.h
 *  Lablib
 *  
 *  Protocol specifying required methods for a white noise object
 *
 *  Created by John Maunsell on July 28, 2020
 *  Copyright (c) 2020-2020. All rights reserved.
 *
 */

#import "LLNoiseProfile.h"

#define kMaxChannels        16

typedef struct {
    long    DAChannel;
    BOOL    doPulseMarkers;
    BOOL    doGate;
    long    durationMS;
    float   frequencyHZ;                //NEED TO GET RID OF THIS PARAMETER
    float   fullRangeV;
    long    gateBit;
    long    gatePorchMS;                // time that gates leads and trails stimulus
    float   pulseAmpV;                  // pulse amplitude in volts
    long    pulseMarkerBit;
    long    pulseWidthMS;
} WhiteNoiseData;

@protocol LLWhiteNoiseDevice <NSObject>

@property (readonly) NSData **sampleData;
@property (readonly) BOOL samplesReady;
@property (readonly) float samplePeriodUS;
- (BOOL)setNoiseArray:(NSArray *)noiseArray;
- (BOOL)setNoiseParameters:(WhiteNoiseData *)pNoise;
- (BOOL)makeStimUsingProfile:(LLNoiseProfile *)profile meanPowerMW:(float)meanPowerMW;

- (void)stimulate;

@end