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

#import <Lablib/LLNoiseProfile.h>

#define kMaxChannels        16

typedef struct {
    long    DAChannel;
    BOOL    doPulseMarkers;
    BOOL    doGate;
    long    durationMS;
    float   fullRangeV;
    long    gateBit;
    long    gatePorchMS;                // time that gates leads and trails stimulus
    float   pulseAmpMW;                 // pulse amplitude in volts
    float   pulseAmpV;                  // pulse amplitude in volts
    long    pulseMarkerBit;
    long    pulseWidthMS;
    long    rampDurMS;                  // length of ramp portion at the start of the noise
    long    zeroTimeMS;
} WhiteNoiseData;

@protocol LLWhiteNoiseDevice <NSObject>

@property (readonly) NSData **sampleData;
@property (readonly) BOOL samplesReady;
@property (readonly) float samplePeriodUS;

- (BOOL)setNoiseArray:(NSArray *)noiseArray;
- (BOOL)setNoiseParameters:(WhiteNoiseData *)pNoise;
- (void)stimulate;

@end
