//
//  LLDataDevice.h 
//  Lablib
//
//  Created by John Maunsell on 9/26/05.
//  Copyright 2005-2006. All rights reserved.
//

#ifndef _LLDataDevice_
#define _LLDataDevice_

#import <Lablib/LLStandardDataEvents.h>

// We need a forward declaration of LLDataDeviceController, because it references LLDataDevice in its header

@class LLDataDeviceController;

@interface LLDataDevice : NSObject {

    unsigned long    digitalInputBits;
    unsigned long    sampleChannels;
    unsigned long    timestampChannels;
    NSMutableArray   *samplePeriodMS;
    NSMutableArray   *timestampPeriodMS;
}

@property (NS_NONATOMIC_IOSONLY, retain) LLDataDeviceController *controller;
@property (NS_NONATOMIC_IOSONLY) BOOL dataEnabled;
@property (NS_NONATOMIC_IOSONLY) short deviceIndex;
@property (NS_NONATOMIC_IOSONLY) BOOL devicePresent;
@property (nonatomic) BOOL deviceEnabled;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY, readonly) NSData **sampleData;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL shouldCreateAnotherDevice;
@property (NS_NONATOMIC_IOSONLY, readonly) NSData **timestampData;

- (void)configure;
- (unsigned short)digitalInputBits;
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
- (long)sampleChannels;
- (float)samplePeriodMSForChannel:(long)channel;
- (void)setDataDisabled;
- (void)setDataEnabled;
- (void)setDeviceEnabled;
- (void)setDeviceDisabled;
- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
- (BOOL)setTimestampPeriodMS:(float)newPeriodMS channel:(long)channel;
- (BOOL)setTimestampTicksPerMS:(long)newTicksPerMS channel:(long)channel;
- (void)startDevice;
- (void)stopDevice;
- (long)timestampChannels;
- (float)timestampPeriodMSForChannel:(long)channel;
- (long)timestampTicksPerMSForChannel:(long)channel;

@end

#endif // _LLDataDevice_
