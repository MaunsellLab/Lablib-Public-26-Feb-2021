//
//  LLDataDevice.m
//  Lablib
//
//  Created by John Maunsell on 9/26/05.
//  Copyright 2005. All rights reserved.
//

#import "LLDataDevice.h"

@implementation LLDataDevice

- (void)configure;
{
}

- (BOOL)dataEnabled;
{
	return dataEnabled;
}

- (void)dealloc;
{
	[samplePeriodMS release];
	[timestampPeriodMS release];
	[super dealloc];
}

- (BOOL)deviceEnabled;
{
	return deviceEnabled;
}

// Report whether the hardware device exists on the current configuration

- (BOOL)devicePresent;
{
	return devicePresent;
}

- (unsigned short)digitalInputBits;
{
	return digitalInputBits;
}

- (short)deviceIndex;
{
	return deviceIndex;
}

- (void)digitalOutputBits:(unsigned long)bits;
{
}

- (void)digitalOutputBitsOff:(unsigned long)bits;
{
}

- (void)digitalOutputBitsOn:(unsigned long)bits;
{
}

- (void)disableAllChannels;
{
	sampleChannels = timestampChannels = 0;
}

- (void)disableSampleChannel:(long)channel;
{
	[self disableSampleChannels:[NSNumber numberWithUnsignedLong:(0x01 << channel)]];
}

- (void)disableSampleChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLDataDevice",  
				@"Request to disable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [samplePeriodMS count]);
		exit(0);
	}
	sampleChannels &= ~[bitPattern unsignedLongValue];
}

- (void)disableTimestampChannel:(long)channel;
{
	[self disableTimestampChannels:[NSNumber numberWithUnsignedLong:(0x01 << channel)]];
}

- (void)disableTimestampChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([timestampPeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLDataDevice",  
				@"Request to disable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [timestampPeriodMS count]);
		exit(0);
	}
	timestampChannels &= ~[bitPattern unsignedLongValue];
}

- (void)enableSampleChannel:(unsigned long)channel;
{
	[self enableSampleChannels:[NSNumber numberWithUnsignedLong:(0x01 << channel)]];
}

- (void)enableSampleChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLDataDevice",  
				@"Request to enable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [samplePeriodMS count]);
		exit(0);
	}
	sampleChannels |= [bitPattern unsignedLongValue];
}

- (void)enableTimestampChannel:(long)channel;
{
	[self enableTimestampChannels:[NSNumber numberWithUnsignedLong:(0x01 << channel)]];
}

- (void)enableTimestampChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([timestampPeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLDataDevice",  
				@"Request to enable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [timestampPeriodMS count]);
		exit(0);
	}
	timestampChannels |= [bitPattern unsignedLongValue];
}

- (id)init;
{
	if ((self = [super init]) != nil) {
		samplePeriodMS = [[NSMutableArray alloc] init];
		timestampPeriodMS = [[NSMutableArray alloc] init];
	}
	return self;
}

- (NSString *)name;
{
	return @"Unnamed LLDataDevice";
}

- (NSArray *)samplePeriodMS;
{
	return samplePeriodMS;
}

- (float)samplePeriodMSForChannel:(long)channel;
{
	if (channel >= [samplePeriodMS count]) {
		NSRunAlertPanel(@"LLDataDevice",  
				@"Requested sample period %ld of %d for device %@",
				@"OK", nil, nil, channel, [samplePeriodMS count], [self name]);
		exit(0);
	}
	return [[samplePeriodMS objectAtIndex:channel] floatValue];
}

- (long)sampleChannels;
{
	return [samplePeriodMS count];
}

- (NSData **)sampleData;
{
	return  nil;
}

- (void)setController:(id)theController;
{
	controller = theController;
}

- (void)setDataEnabled:(NSNumber *)state;
{
	dataEnabled = [state boolValue];
}

- (void)setDeviceEnabled:(NSNumber *)state;
{
	deviceEnabled = [state boolValue];
	if (!deviceEnabled) {
		dataEnabled = NO;
	}
}

- (void)setDeviceIndex:(short)index;
{
	deviceIndex = index;
}

- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
{
	if (channel >= [samplePeriodMS count]) {
		NSRunAlertPanel(@"LLDataDevice",  
				@"Attempt to set sample period %ld of %d for device %@",
				@"OK", nil, nil, channel, [samplePeriodMS count], [self name]);
		exit(0);
	}
	[samplePeriodMS replaceObjectAtIndex:channel 
					withObject:[NSNumber numberWithFloat:newPeriodMS]];
	return YES;
}

- (BOOL)setTimestampPeriodMS:(float)newPeriodMS channel:(long)channel;
{
	if (channel >= [timestampPeriodMS count]) {
		NSRunAlertPanel(@"LLDataDevice",  
				@"Attempt to set timestamp period for channel %ld of %d for device %@",
				@"OK", nil, nil, channel, [timestampPeriodMS count], [self name]);
		exit(0);
	}
	[timestampPeriodMS replaceObjectAtIndex:channel 
					withObject:[NSNumber numberWithFloat:newPeriodMS]];
	return YES;
}

- (BOOL)setTimestampTicksPerMS:(long)ticksPerMS channel:(long)channel;
{
	if (channel >= [timestampPeriodMS count]) {
		NSRunAlertPanel(@"LLDataDevice",  
				@"Attempt to set timestamp period for channel %ld of %d for device %@",
				@"OK", nil, nil, channel, [timestampPeriodMS count], [self name]);
		exit(0);
	}
	[timestampPeriodMS replaceObjectAtIndex:channel 
					withObject:[NSNumber numberWithFloat:(1.0 / ticksPerMS)]];
	return YES;
}

- (long)timestampChannels;
{
	return [timestampPeriodMS count];
}

- (NSData **)timestampData;
{
	return nil;
}

- (float)timestampPeriodMSForChannel:(long)channel;
{
	if (channel >= [timestampPeriodMS count]) {
		if ([[self name] isEqualToString:@"None"]) {
			return(1);
		}
		NSRunAlertPanel(@"LLDataDevice",  
				@"Requested %d timestamp ticks per ms for channel %ld of device \"%@\"",
				@"OK", nil, nil, [timestampPeriodMS count], channel, [self name]);
		exit(0);
	}
	return [[timestampPeriodMS objectAtIndex:channel] floatValue];
}

- (long)timestampTicksPerMSForChannel:(long)channel;
{
	if (channel >= [timestampPeriodMS count]) {
		if ([[self name] isEqualToString:@"None"]) {
			return(1);
		}
		NSRunAlertPanel(@"LLDataDevice",  
				@"Requested %d timestamp ticks per ms for channel %ld of device \"%@\"",
				@"OK", nil, nil, [timestampPeriodMS count], channel, [self name]);
		exit(0);
	}
	return (long)(1.0 / [[timestampPeriodMS objectAtIndex:channel] floatValue]);
}

@end
