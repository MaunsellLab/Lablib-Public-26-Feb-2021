//
//  LabJackU6DataDevice.h 
//  Lablib
//
//  Copyright 2016 All rights reserved.
//
#import <Lablib/LLDataDevice.h>
#import "LabJackU6Monitor.h"

typedef enum {kRXChannel = 0, kRYChannel, kRPChannel, kLXChannel, kLYChannel, kLPChannel, kLabJackU6Channels} LabJackU6Channel;

@interface LabJackU6DataDevice : LLDataDevice {

	int						eye_used;
	double					nextSampleTimeS;
	double					LabJackU6SamplePeriodS;
	double					sampleTimeS;
	double					monitorStartTimeS;
	double					lastReadDataTimeS;
	BOOL					justStartedLabJackU6;	
	NSMutableData			*sampleData[kLabJackU6Channels];
	NSMutableData			*lXData, *lYData, *lPData;
	NSMutableData			*rXData, *rYData, *rPData;
	NSLock					*dataLock;
	NSLock					*deviceLock;
	NSThread				*pollThread;
	LabJackU6Monitor		*monitor;
	LabJackU6MonitorValues	values;
}

- (void)disableSampleChannels:(NSNumber *)bitPattern;
- (void)enableSampleChannels:(NSNumber *)bitPattern;
- (NSString *)name;
- (long)sampleChannels;
- (NSData **)sampleData;
- (float)samplePeriodMSForChannel:(long)channel;
- (void)setDataEnabled:(NSNumber *)state;
- (void)setDeviceEnabled:(NSNumber *)state;
- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;

@end
