//
//  LLNoiseProfile.m
//  
//  This class supports the specification of microstimulation noise profiles
//
//  Created by John Maunsell on March 17, 2018
//  Copyright 2018-2020. All rights reserved.

#import "LLNoiseProfile.h"
#import "LLNIDAQ.h"
#import "LLSystemUtil.h"

@implementation LLNoiseProfile

- (instancetype)init;
{
    if ((self = [super init]) != nil) {
    }
    return self;
}

- (void)makeTrainWithRate:(Float64)samplesPerMS offV:(Float64)offV onV:(Float64)onV
                    offMW:(Float64)offMW onMW:(Float64)onMW;
{
    long sample, channel, numChannelSamples, pulseNum, zeroSample, rampEndSample, pulseIndex, pulsePhaseMS, *timesMS;
    float *voltages, *powersMW, factor;
    Float64 *pT, *trainValues;

    numChannelSamples = (self.zeroTimeMS + self.maxStimDurMS) * samplesPerMS + 1;
    if (numChannelSamples < kAOChannels) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLNoiseProfile" informativeText:
                                    @"Values correspond to zero duration train" terminateAfter:YES];
        return;
    }
    self.numTrainSamples = numChannelSamples * kAOChannels;
    if (self.numTrainSamples <= kAOChannels) {                      // nothing to do
        return;
    }
    trainValues = malloc(self.numTrainSamples * sizeof(Float64));   // allocate memory for train
    timesMS = malloc(numChannelSamples * sizeof(long));             // allocate memory for pulse times
    voltages = malloc(numChannelSamples * sizeof(float));           // allocate memory for pulse voltages
    powersMW = malloc(numChannelSamples * sizeof(float));           // allocate memory for pulse powers
    zeroSample = self.zeroTimeMS * samplesPerMS;                    // sample at start of visual stimulus
    rampEndSample = self.preRampDurMS * samplesPerMS;               // sample at end of ramp
    pulsePhaseMS = rand() % (long)self.pulseDurMS;                  // random pulse phase (to nearest ms)
    pulseIndex = 0;
    timesMS[pulseIndex] = -zeroSample / samplesPerMS;
    pulseNum = floor((timesMS[pulseIndex] + pulsePhaseMS) / self.pulseDurMS);
    if (rand() % 2) {
        voltages[pulseIndex] = onV;
        powersMW[pulseIndex] = onMW;
    }
    else {
        voltages[pulseIndex] = offV;
        powersMW[pulseIndex] = offMW;
    };
    factor = MIN(1.0, self.pulseDurMS / 2.0 * samplesPerMS / rampEndSample);
    voltages[pulseIndex] *= factor;
    powersMW[pulseIndex] *= factor;
//    NSLog(@"%ld: time: %ld voltage %.2f power %.2f", pulseIndex, timesMS[pulseIndex], voltages[pulseIndex], powersMW[pulseIndex]);
    for (sample = 0, pT = trainValues; sample < numChannelSamples - 1; sample++) {
        if (floor(((sample - zeroSample) / samplesPerMS + pulsePhaseMS) / self.pulseDurMS) != pulseNum) {
            pulseIndex++;
            timesMS[pulseIndex] = (sample - zeroSample) / samplesPerMS;
            pulseNum = floor((timesMS[pulseIndex] + pulsePhaseMS) / self.pulseDurMS);
            if (rand() % 2) {
                voltages[pulseIndex] = onV;
                powersMW[pulseIndex] = onMW;
            }
            else {
                voltages[pulseIndex] = offV;
                powersMW[pulseIndex] = offMW;
            };
            if (sample < rampEndSample) {
                factor = MIN(1.0, (sample + self.pulseDurMS / 2.0 * samplesPerMS) / rampEndSample);
                voltages[pulseIndex] *= factor;
                powersMW[pulseIndex] *= factor;
            }
//            NSLog(@"%ld: time: %ld voltage %.2f power %.2f", pulseIndex, timesMS[pulseIndex], voltages[pulseIndex], powersMW[pulseIndex]);
        }
        *pT++ = voltages[pulseIndex];
        for (channel = 1; channel < kAOChannels; channel++) {
            *pT++ = 0.0;                                            // we're not using the other channels
        }
    }
    *pT++ = offV;
    for (channel = 1; channel < kAOChannels; channel++) {
        *pT++ = 0.0;                                                // we're not using the other channels
    }

    // Sometimes we fail to fill all the bins, so we fix that here.
    while (pulseIndex < floor((self.zeroTimeMS + self.maxStimDurMS) / self.pulseDurMS + 1)) {
        timesMS[pulseIndex] = timesMS[pulseIndex - 1];
        voltages[pulseIndex] = voltages[pulseIndex - 1];
        powersMW[pulseIndex] = powersMW[pulseIndex - 1];
        pulseIndex++;
    }
    self.pulseTimesMS = [[NSData alloc] initWithBytes:timesMS length:(pulseIndex - 1) * sizeof(long)];
    self.pulseVoltage = [[NSData alloc] initWithBytes:voltages length:(pulseIndex - 1) * sizeof(float)];
    self.pulsePowersMW = [[NSData alloc] initWithBytes:powersMW length:(pulseIndex - 1) * sizeof(float)];
    self.pulseTrain = [[NSData alloc] initWithBytes:trainValues length:self.numTrainSamples * sizeof(Float64)];
    free(timesMS);
    free(voltages);
    free(powersMW);
    free(trainValues);
}

@end
