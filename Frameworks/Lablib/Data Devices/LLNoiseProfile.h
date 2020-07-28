//
//  LLNoiseProfile.h
//  Lablib
//
//  This class supports the specification of microstimulation noise profiles
//
//  Created by John Maunsell on September 9, 2019
//  Copyright 2019-2020. All rights reserved.

@import AppKit;

@interface LLNoiseProfile : NSObject {

}

@property float maxStimDurMS;           // duration of post-ramp stimulus
@property long numTrainSamples;         // number of samples in the output train
@property float preRampDurMS;           // duration of ramp up of the stimulus
@property float pulseDurMS;             // duration of unit pulses
@property (retain) NSData *pulseTrain;  // values for NIDAQ to output
@property (retain) NSData *pulseTimesMS;    // start times of the transitions in the noise stimulus
@property (retain) NSData *pulsePowersMW;   // powers of the pulses in the noise stimulus
@property (retain) NSData *pulseVoltage;    // voltage of the pulses in the noise stimulus
@property float zeroTimeMS;             // time in output sequence to assign to zero

- (void)makeTrainWithRate:(Float64)samplesPerMS offV:(Float64)offV onV:(Float64)onV
                    offMW:(Float64)offMW onMW:(Float64)onMW;

@end
