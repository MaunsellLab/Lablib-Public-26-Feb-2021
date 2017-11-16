//
//  LLDataDevice.h 
//  Lablib
//
//  Created by John Maunsell on 9/26/05.
//  Copyright 2005-2006. All rights reserved.
//

#import "LLStandardDataEvents.h"

@interface LLDataDevice : NSObject {

    id                controller;
    BOOL            dataEnabled;
    BOOL            deviceEnabled;
    BOOL            devicePresent;
    short            deviceIndex;
    unsigned long    digitalInputBits;
    unsigned long    sampleChannels;
    unsigned long    timestampChannels;
    NSMutableArray    *samplePeriodMS;
    NSMutableArray  *timestampPeriodMS;
}

- (void)configure;
- (BOOL)dataEnabled;
- (BOOL)deviceEnabled;
@property (NS_NONATOMIC_IOSONLY) short deviceIndex;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL devicePresent;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned short digitalInputBits;
- (void)digitalOutputBits:(unsigned long)bits;
- (void)digitalOutputBitsOff:(unsigned long)bits;
- (void)digitalOutputBitsOn:(unsigned long)bits;
- (void)disableAllChannels;
- (void)disableSampleChannel:(long)channel;
- (void)disableSampleChannels:(NSNumber *)bitPattern;
- (void)disableTimestampChannel:(long)channel;
- (void)disableTimestampChannels:(NSNumber *)bitPattern;
- (void)enableSampleChannel:(unsigned long)channel;
- (void)enableSampleChannels:(NSNumber *)bitPattern;
- (void)enableTimestampChannel:(long)channel;
- (void)enableTimestampChannels:(NSNumber *)bitPattern;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY, readonly) long sampleChannels;
@property (NS_NONATOMIC_IOSONLY, readonly) NSData **sampleData;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSArray *samplePeriodMS;
- (float)samplePeriodMSForChannel:(long)channel;
- (void)setController:(id)theController;
- (void)setDataEnabled:(NSNumber *)state;
- (void)setDeviceEnabled:(NSNumber *)state;
- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
- (BOOL)setTimestampPeriodMS:(float)newPeriodMS channel:(long)channel;
- (BOOL)setTimestampTicksPerMS:(long)newTicksPerMS channel:(long)channel;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldCreateAnotherDevice;
- (void)startDevice;
- (void)stopDevice;
@property (NS_NONATOMIC_IOSONLY, readonly) long timestampChannels;
@property (NS_NONATOMIC_IOSONLY, readonly) NSData **timestampData;
- (float)timestampPeriodMSForChannel:(long)channel;
- (long)timestampTicksPerMSForChannel:(long)channel;

@end
