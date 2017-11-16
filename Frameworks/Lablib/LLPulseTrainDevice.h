/*
 *  LLPulseTrainDevice.h
 *  Lablib
 *  
 *  Protocol specifying required methods for a pulse train object
 *
 *  Created by John Maunsell on Aug 29 2008
 *  Copyright (c) 2008. All rights reserved.
 *
 */

#define kMaxChannels        16
typedef NS_ENUM(unsigned int, PulseTypes) {kVoltagePulses = 0, kCurrentPulses, kPulseTypes};

typedef struct {
    long    pulseType;
    float   amplitude;                    // amplitude in uA or V.
    long    DAChannel;
    BOOL    doPulseMarkers;
    BOOL    doGate;
    long    durationMS;
    float   frequencyHZ;
    float   fullRangeV;
    long    gateBit;
    long    gatePorchMS;                // time that gates leads and trails stimulus
    BOOL    pulseBiphasic;
    long    pulseMarkerBit;
    long    pulseWidthUS;
    float   UAPerV;
} PulseTrainData;

@protocol LLPulseTrainDevice <NSObject>

@property (NS_NONATOMIC_IOSONLY, readonly) NSData **sampleData;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL samplesReady;
@property (NS_NONATOMIC_IOSONLY, readonly) float samplePeriodUS;
- (BOOL)setTrainArray:(NSArray *)trainArray;
- (BOOL)setTrainParameters:(PulseTrainData *)pTrain;
- (void)stimulate;

@end
