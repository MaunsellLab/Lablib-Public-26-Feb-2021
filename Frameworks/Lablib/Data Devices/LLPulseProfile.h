//
//  LLPulseProfile.h
//  Lablib
//
//  This class supports the specification of microstimulation pulses
//
//  Created by John Maunsell on March 17, 2018
//  Copyright (c) 2018. All rights reserved.

@interface LLPulseProfile : NSObject {

}

@property (NS_NONATOMIC_IOSONLY) float startPowerMW;

@property (NS_NONATOMIC_IOSONLY) float preDelayMS;
@property (NS_NONATOMIC_IOSONLY) float preRampMS;
@property (NS_NONATOMIC_IOSONLY) float preDurationMS;
@property (NS_NONATOMIC_IOSONLY) float prePowerMW;

@property (NS_NONATOMIC_IOSONLY) float pulseRampMS;
@property (NS_NONATOMIC_IOSONLY) float pulseDurationMS;
@property (NS_NONATOMIC_IOSONLY) float pulsePowerMW;

@property (NS_NONATOMIC_IOSONLY) float postRampMS;
@property (NS_NONATOMIC_IOSONLY) float postDurationMS;
@property (NS_NONATOMIC_IOSONLY) float postPowerMW;

@property (NS_NONATOMIC_IOSONLY) float endRampMS;
@property (NS_NONATOMIC_IOSONLY) float endPowerMW;

- (float)totalDurationMS;
- (void)zeroAll;

@end
