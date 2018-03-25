//
//  LLPulseProfile.m
//  
//  This class supports the specification of microstimulation pulses
//
//  Created by John Maunsell on March 17, 2018
//  Copyright (c) 2018. All rights reserved.

#import "LLPulseProfile.h"

@implementation LLPulseProfile

- (instancetype)init;
{
    if ((self = [super init]) != nil) {
        _preDelayMS =  _preRampMS = _preDurationMS = _prePowerMW = 0.0;         // can't use self safely yet
        _pulseRampMS = _pulseDurationMS = _pulsePowerMW = 0.0;
        _postRampMS = _postDurationMS = _postPowerMW = 0.0;
        _endRampMS = _endPowerMW = 0.0;
    }
    return self;
}

- (float)totalDurationMS;
{
    return self.preDelayMS + self.preRampMS + self.preDurationMS + self.pulseRampMS + self.pulseDurationMS +
                    self.postRampMS + self.postDurationMS + self.endRampMS;
}

- (void)zeroAll;            // set the value of every parameter to zero.
{
    self.preDelayMS =  self.preRampMS = self.preDurationMS = self.prePowerMW = 0.0;
    self.pulseRampMS = self.pulseDurationMS = self.pulsePowerMW = 0.0;
    self.postRampMS = self.postDurationMS = self.postPowerMW = 0.0;
    self.endRampMS = self.endPowerMW = 0.0;
}

@end
