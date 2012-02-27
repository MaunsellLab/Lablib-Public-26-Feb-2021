//
//  LLEyeLinkDataDevice.m
//  Lablib
//
//  Created by Jon Hendry on 9/18/07.
//  Copyright 2007. All rights reserved.
//

#import <eyelink_core/eyelink.h>
#import <eyelink_core/core_expt.h>
#import <Lablib/LLPluginController.h>
#import <Lablib/LLSystemUtil.h>
#import "LLEyeLinkDataDevice.h"

enum {kXChannel = 0, kYChannel, kPChannel, kChannels};

//#define kUseLLDataDevices        // needed for versioning

@implementation LLEyeLinkDataDevice

volatile int shouldKillThread = 0;

void handler(int signal) {
	stop_recording();
	printf("received signal: %d\n",signal);
	[[NSApplication sharedApplication] terminate:nil];
}

+ (int)version;
{
	return kLLPluginVersion;
}

- (void)dealloc;
{
	if (eyelink_is_connected()) {
		set_offline_mode();					// place EyeLink tracker in off-line (idle) mode
		eyecmd_printf("close_data_file");    // close data file
		eyelink_close(1);					 // disconnect from tracker
	}
	close_eyelink_system();					// shut down system (MUST do before exiting)
	[dataLock lock];
	[xData release];
	[yData release];
	[pupilData release];
	[dataLock unlock];
	[dataLock release];
	[deviceLock release];
	[monitor release];
	[super dealloc];
}

- (id)init;
{ 
	int i, error;

	if ((self = [super init]) != nil) {
		
		NSLog(@"EyeLink Device init\n");

		xData = [[NSMutableData alloc] init];
		yData = [[NSMutableData alloc] init];
		pupilData = [[NSMutableData alloc] init];

		pollThread = nil;
		deviceEnabled = NO;
		dataEnabled = NO;
		devicePresent = YES;
		EyeLinkSamplePeriodS = 0.001;
			
		dataLock = [[NSLock alloc] init];
		deviceLock = [[NSLock alloc] init];
		
		[samplePeriodMS addObject:[NSNumber numberWithFloat:1.0F]];
		[samplePeriodMS addObject:[NSNumber numberWithFloat:1.0F]];
		[samplePeriodMS addObject:[NSNumber numberWithFloat:1.0F]];
		
		monitor = [[LLEyeLinkMonitor alloc] initWithID:@"EyeLink" description:@"EyeLink Eye Monitor"];
		
		nextSampleTimeS += [[samplePeriodMS objectAtIndex:0] floatValue] * EyeLinkSamplePeriodS;
				
		if ((i = open_eyelink_connection(0))) {
			deviceEnabled = devicePresent = NO;
		}
		else {
			deviceEnabled = devicePresent = YES;
			stop_recording();                           // make sure we're stopped
		}
		if (deviceEnabled) {                            // find out which eyes are in play
			error = start_recording(0, 0, 1, 1);
			if (error != 0) {
				deviceEnabled = devicePresent = NO;
			}
			else {
				eye_used = eyelink_eye_available();
				if (eye_used == BINOCULAR) {
					eye_used = LEFT_EYE;
				}		
				stop_recording();
			}
		}
	}
	return self;
}

- (id <LLMonitor>)monitor;
{
	return monitor;
}

- (void)disableSampleChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLEyeLinkDataDevice",  
				@"Request to disable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [samplePeriodMS count]);
		exit(0);
	}
	sampleChannels &= ~[bitPattern unsignedLongValue];
}

- (void)enableSampleChannels:(NSNumber *)bitPattern;
{
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) { 
		NSRunAlertPanel(@"LLEyeLinkDataDevice",  
				@"Request to enable non-existent channel for device %@ (only %d channels)",
				@"OK", nil, nil, [self name], [samplePeriodMS count]);
		exit(0);
	}
	sampleChannels |= [bitPattern unsignedLongValue];
}

- (NSString *)name;
{
	return @"EyeLink";
}

- (float)samplePeriodMSForChannel:(long)channel;
{
	if (channel >= [samplePeriodMS count]) {
		NSRunAlertPanel(@"LLEyeLinkDataDevice",  
				@"Requested sample period %d of %d for device %@",
				@"OK", nil, nil, channel, [samplePeriodMS count], [self name]);
		exit(0);
	}
	return [[samplePeriodMS objectAtIndex:channel] floatValue];
}

- (long)sampleChannels;
{
	return [samplePeriodMS count];
}

- (void)pollSamples
{
	int i = 0;
	short sample = 0;
	ISAMPLE oldSample, newSample;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	oldSample.time = 0;
	pollThread = [NSThread currentThread];
	
	while (YES) {
		if (shouldKillThread) {
			[pool release];
			pollThread = nil;
			[NSThread exit];
		}
		while ((i = eyelink_get_sample(&newSample))) {
			if (i && (newSample.time != oldSample.time)) {
				[dataLock lock];
				sample = (short)(newSample.gx[eye_used]);
				[xData appendBytes:&sample length:sizeof(sample)];
				sample = (short)(-newSample.gy[eye_used]);
				[yData appendBytes:&sample length:sizeof(sample)];
				sample = (short)(newSample.pa[eye_used]);
				[pupilData appendBytes:&sample length:sizeof(sample)];
				values.samples++;
				[dataLock unlock];
				oldSample = newSample;
			}
		}
		usleep(1000);										// sleep 1 ms			
	}
}

- (NSData **)sampleData;
{
	int i;
	short sample, index;
//	long xChannel, yChannel, pChannel;
    NSMutableData *xDataCopy, *yDataCopy, *pupilDataCopy;
	
	[dataLock lock];
	
// We have the lock, so copy the pointers to the data
	
    xDataCopy = xData;
	yDataCopy = yData;
	pupilDataCopy = pupilData;
	
	//Now alloc/init new data instances and swap those in
	//(For performance reasons, it might be worthwhile to preallocate two sets of these, and swap them in and out)

	xData = [[NSMutableData alloc] init];
	yData = [[NSMutableData alloc] init];
	pupilData = [[NSMutableData alloc] init];
	
// Now unlock
	
    [dataLock unlock];
	
//	xChannel = 0;		//[defaults integerForKey:LLSynthEyeXKey];   //FIXME
//	yChannel = 1;		//[defaults integerForKey:LLSynthEyeYKey];	 //FIXME
//	pChannel = 2;
	
// Bundle the data into an array.  If the channel is disabled, nil is returned.  If the 
// data length is zero, nil is returned.

	for (index = 0; index < kChannels; index++) {
		if (!(sampleChannels & (0x1 << index)) || [xDataCopy length] == 0) {
			sampleData[index] = nil;
			continue;
		}
		if (index == kXChannel) {
			sampleData[index] = [xDataCopy autorelease];
		}
		else if (index == kYChannel) {
			sampleData[index] = [yDataCopy autorelease];
		}
		else if (index == kPChannel){
			sampleData[index] = [pupilDataCopy autorelease];
		}
	}
	return sampleData;
}

- (void)setDataEnabled:(NSNumber *)state;
{
    int available, error;
	long channel;
	double channelPeriodMS;
	long maxSamplingRateHz = 1000;
	
	if ([state boolValue] && !dataEnabled) {						// toggle from OFF to ON
        [deviceLock lock];
		if (maxSamplingRateHz != 0) {							    // no channels enabled
			sampleTimeS = EyeLinkSamplePeriodS;						// one period complete on first sample
			justStartedEyeLink = YES;
			//[deviceLock lock];
			start_recording(0,0,1,0);                               // tell device to start recording
			//[deviceLock unlock];
			[monitor initValues:&values];
			values.samplePeriodMS = EyeLinkSamplePeriodS * 1000.0;
			monitorStartTimeS = [LLSystemUtil getTimeS];
			lastReadDataTimeS = 0;
			dataEnabled = YES;
		}
        [deviceLock unlock];
	} 
	else if (![state boolValue] && dataEnabled) {					// toggle from ON to OFF
		values.cumulativeTimeMS = ([LLSystemUtil getTimeS] - monitorStartTimeS) * 1000.0;
		lastReadDataTimeS = 0;
		[deviceLock lock];
		stop_recording();
		[deviceLock unlock];
        values.sequences = 1;
		[monitor sequenceValues:values];
		dataEnabled = NO;
	}
}

- (void)setDeviceEnabled:(NSNumber *)state;
{
    int error;
    
	if (![state boolValue] && deviceEnabled) {						// Disable the device
		[self setDataEnabled:NO];
        deviceEnabled = NO;
		shouldKillThread = YES;
		while (pollThread != nil) {
			usleep(100);
		}
		//stop_recording();
//		signal(SIGKILL, SIG_DFL);
//		//signal(SIGINT, SIG_DFL);
//		signal(SIGQUIT, SIG_DFL);
//		signal(SIGILL, SIG_DFL);
//		signal(SIGABRT, SIG_DFL);
//		signal(SIGSEGV, SIG_DFL);
//		signal(SIGTERM, SIG_DFL);
	}
	
	if ([state boolValue] && !deviceEnabled) {						// Enable the device
		deviceEnabled = YES;
		signal(SIGKILL, handler);
		//signal(SIGINT, handler);
		signal(SIGQUIT, handler);
		signal(SIGILL, handler);
		signal(SIGABRT, handler);
		signal(SIGSEGV, handler);
		signal(SIGTERM, handler);
		if (pollThread == nil) {
			shouldKillThread = NO;
			[NSThread detachNewThreadSelector:@selector(pollSamples) toTarget:self withObject:nil];
			error = start_recording(0, 0, 1, 0);                    // Eyelink: link, not file, samples, no events
		}
	}
}

- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
{
	if (channel >= [samplePeriodMS count]) {
		NSRunAlertPanel(@"LLEyeLinkDataDevice",  
				@"Attempt to set sample period %d of %d for device %@",
				@"OK", nil, nil, channel, [samplePeriodMS count], [self name]);
		exit(0);
	}
	[samplePeriodMS replaceObjectAtIndex:channel 
					withObject:[NSNumber numberWithFloat:newPeriodMS]];
	return YES;
}

@end