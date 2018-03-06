//
//  LLEyeLinkDataDevice.m
//  Lablib
//
//  Created by Jon Hendry on 9/18/07.
//  Copyright 2007. All rights reserved.
//
// August 21, 2015, Working version for Rig 1

#import <eyelink_core/eyelink.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#import <eyelink_core/core_expt.h>
#pragma clang diagnostic pop
#import <Lablib/LLPluginController.h>
#import <Lablib/LLSystemUtil.h>
#import "LLEyeLinkDataDevice.h"

//#define kUseLLDataDevices        // needed for versioning

@implementation LLEyeLinkDataDevice

@synthesize dataEnabled = _dataEnabled;
@synthesize deviceEnabled = _deviceEnabled;
@synthesize devicePresent = _devicePresent;

volatile int shouldKillThread = 0;
BOOL firstTrialSample;
long ELTrialStartTimeMS;

void handler(int signal) {
    stop_recording();
    printf("received signal: %d\n",signal);
    [[NSApplication sharedApplication] terminate:nil];
}

+ (NSInteger)version;
{
    return kLLPluginVersion;
}

- (void)dealloc;
{
    if (eyelink_is_connected()) {
        set_offline_mode();                    // place EyeLink tracker in off-line (idle) mode
        eyecmd_printf("close_data_file");    // close data file
        eyelink_close(1);                     // disconnect from tracker
    }
    close_eyelink_system();                    // shut down system (MUST do before exiting)
    [dataLock lock];
    [lXData release];
    [lYData release];
    [lPData release];
    [rXData release];
    [rYData release];
    [rPData release];
    [dataLock unlock];
    [dataLock release];
    [deviceLock release];
    [monitor release];
    [super dealloc];
}

// If the link to the EyeLink computer is not opening, check that the IP address for the Mac port that connects to t
// the EyeLink has been set to Manual and 100.1.1.2 and subnet mask 255.255.255.0

- (instancetype)init;
{ 
    int index, error;

    if ((self = [super init]) != nil) {
        
        NSLog(@"EyeLink Device init");

        lXData = [[NSMutableData alloc] init];
        lYData = [[NSMutableData alloc] init];
        lPData = [[NSMutableData alloc] init];
        rXData = [[NSMutableData alloc] init];
        rYData = [[NSMutableData alloc] init];
        rPData = [[NSMutableData alloc] init];

        pollThread = nil;
        _deviceEnabled = _dataEnabled = NO;
        _devicePresent = YES;
        EyeLinkSamplePeriodS = 0.002;
            
        dataLock = [[NSLock alloc] init];
        deviceLock = [[NSLock alloc] init];

// The NSMutableArry samplePeriodMS contains one entry for each possible channel.  We initialize it for 6
// (X, Y, and P for left and right eyes).  Default to 500 Hz (2 ms) sampling.
        
        for (index = 0; index < kEyeLinkChannels; index++) {
            [samplePeriodMS addObject:@2.0F];
        }
        monitor = [[LLEyeLinkMonitor alloc] initWithID:@"EyeLink" description:@"EyeLink Eye Monitor"];
        
        nextSampleTimeS += [samplePeriodMS[0] floatValue] * EyeLinkSamplePeriodS;
                
        if ((index = open_eyelink_connection(0))) {
            _deviceEnabled = _devicePresent = NO;
        }
        else {
            _deviceEnabled = _devicePresent = YES;
            stop_recording();                           // make sure we're stopped
        }
        if (_deviceEnabled) {                            // find out which eyes are in play
            error = start_recording(0, 0, 1, 1);
            if (error != 0) {
                _deviceEnabled = _devicePresent = NO;
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
    if (bitPattern.unsignedLongValue >= (0x01 << (samplePeriodMS.count + 1))) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLEyeLinkDataDevice" informativeText:[NSString stringWithFormat:
                @"Request to disable non-existent channel for device %@ (only %lu channels)",
                [self name], (unsigned long)samplePeriodMS.count]];
        exit(0);
    }
    sampleChannels &= ~bitPattern.unsignedLongValue;
}

- (void)enableSampleChannels:(NSNumber *)bitPattern;
{
    if (bitPattern.unsignedLongValue >= (0x01 << (samplePeriodMS.count + 1))) { 
        [LLSystemUtil runAlertPanelWithMessageText:@"LLEyeLinkDataDevice" informativeText:[NSString stringWithFormat:
               @"Request to enable non-existent channel for device %@ (only %lu channels)",
               [self name], (unsigned long)samplePeriodMS.count]];
        exit(0);
    }
    sampleChannels |= bitPattern.unsignedLongValue;
}

- (NSString *)name;
{
    return @"EyeLink";
}

- (float)samplePeriodMSForChannel:(long)channel;
{
    if (channel >= samplePeriodMS.count) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLEyeLinkDataDevice" informativeText:[NSString stringWithFormat:
               @"Requested sample period %ld of %lu for device %@",
               channel, (unsigned long)samplePeriodMS.count, [self name]]];
        exit(0);
    }
    return [samplePeriodMS[channel] floatValue];
}

- (long)sampleChannels;
{
    return samplePeriodMS.count;
}

- (void)pollSamples
{
    int index = 0;
    short sample = 0;
    ISAMPLE oldSample, newSample;
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    @autoreleasepool {
        oldSample.time = 0;
        pollThread = [NSThread currentThread];

        while (YES) {
            if (shouldKillThread) {
    //            [pool release];
                pollThread = nil;
                [NSThread exit];
            }
            while ((index = eyelink_get_sample(&newSample))) {
                if (index && (newSample.time != oldSample.time)) {
                    [dataLock lock];
                    if (!firstTrialSample) {
                        ELTrialStartTimeMS = eyelink_tracker_msec();
                        NSLog(@"Current eyeLink time: %li",ELTrialStartTimeMS);
                        NSLog(@"EyeLink Sample Time stamp: %u", newSample.time);
                        NSLog(@"Difference: %li",ELTrialStartTimeMS-newSample.time);
                        NSLog(@"Number of samples in EL buffer: %i",eyelink_data_count(1,0));
                        firstTrialSample = YES;
                    }
                    sample = (short)(newSample.gx[RIGHT_EYE]);
                    [rXData appendBytes:&sample length:sizeof(sample)];
                    sample = (short)(-newSample.gy[RIGHT_EYE]);
                    [rYData appendBytes:&sample length:sizeof(sample)];
                    sample = (short)(newSample.pa[RIGHT_EYE]);
                    [rPData appendBytes:&sample length:sizeof(sample)];
                    sample = (short)(newSample.gx[LEFT_EYE]);
                    [lXData appendBytes:&sample length:sizeof(sample)];
                    sample = (short)(-newSample.gy[LEFT_EYE]);
                    [lYData appendBytes:&sample length:sizeof(sample)];
                    sample = (short)(newSample.pa[LEFT_EYE]);
                    [lPData appendBytes:&sample length:sizeof(sample)];
                    values.samples++;
                    [dataLock unlock];
                    oldSample = newSample;
                }
            }
            usleep(20000);                                        // sleep 20 ms
        }
    }
}

- (NSData **)sampleData;
{
    short index;
    NSMutableData *samples;
    NSArray *sampleArray;
    
    // Lock, then copy pointers to the sample data
    
    [dataLock lock];    
    sampleArray = @[lXData, lYData, lPData, rXData, rYData, rPData];
    
    //Now alloc/init new data instances and swap those in
    //(For performance reasons, it might be worthwhile to preallocate two sets of these, and swap them in and out)

    lXData = [[NSMutableData alloc] init];
    lYData = [[NSMutableData alloc] init];
    lPData = [[NSMutableData alloc] init];
    rXData = [[NSMutableData alloc] init];
    rYData = [[NSMutableData alloc] init];
    rPData = [[NSMutableData alloc] init];
    
    [dataLock unlock];
    
// Bundle the data pointers into an array.  If the channel is disabled, nil is returned.  If the 
// data length is zero, nil is returned.

    for (index = 0; index < kEyeLinkChannels; index++) {
        samples = sampleArray[index];
        if (!(sampleChannels & (0x1 << index))) {                   // disabled channel
            sampleData[index] = nil;                                // not enabled or no samples
        }
        else if (samples.length == 0) {                           // no data samples
            sampleData[index] = nil;                                // not enabled or no samples
        }
        else {
            sampleData[index] = samples;
        }
//        [samples autorelease];
    }
    return sampleData;
}

- (void)setDataEnabled:(BOOL)state;
{
    long maxSamplingRateHz = 1000;
    
    if (state && !self.dataEnabled) {                        // toggle from OFF to ON
        [deviceLock lock];
        if (maxSamplingRateHz != 0) {                                // no channels enabled
            sampleTimeS = EyeLinkSamplePeriodS;                        // one period complete on first sample
            justStartedEyeLink = YES;
            start_recording(0,0,1,0);                               // tell device to start recording
            [monitor initValues:&values];
            values.samplePeriodMS = EyeLinkSamplePeriodS * 1000.0;
            monitorStartTimeS = [LLSystemUtil getTimeS];
            lastReadDataTimeS = 0;
            _dataEnabled = YES;
            firstTrialSample = NO;
        }
        [deviceLock unlock];
    } 
    else if (!state && self.dataEnabled) {                    // toggle from ON to OFF
        values.cumulativeTimeMS = ([LLSystemUtil getTimeS] - monitorStartTimeS) * 1000.0;
        lastReadDataTimeS = 0;
        [deviceLock lock];
        stop_recording();
        [deviceLock unlock];
        values.sequences = 1;
        [monitor sequenceValues:values];
        _dataEnabled = NO;
    }
}

- (void)setDeviceEnabled:(BOOL)state;
{
    if (!state && self.deviceEnabled) {                        // Disable the device
        self.dataEnabled = NO;
        _deviceEnabled = NO;
        shouldKillThread = YES;
        while (pollThread != nil) {
            usleep(100);
        }
    }
    
    if (state && !self.deviceEnabled) {                        // Enable the device
        _deviceEnabled = YES;
        signal(SIGKILL, handler);
        signal(SIGQUIT, handler);
        signal(SIGILL, handler);
        signal(SIGABRT, handler);
        signal(SIGSEGV, handler);
        signal(SIGTERM, handler);
        if (pollThread == nil) {
            shouldKillThread = NO;
            [NSThread detachNewThreadSelector:@selector(pollSamples) toTarget:self withObject:nil];
            start_recording(0, 0, 1, 0);                    // Eyelink: link, not file, samples, no events
        }
    }
}

- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
{
    if (channel >= samplePeriodMS.count) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLEyeLinkDataDevice" informativeText:[NSString stringWithFormat:
                   @"Attempt to set sample period %ld of %lu for device %@",
                   channel, (unsigned long)samplePeriodMS.count, [self name]]];
        exit(0);
    }
    samplePeriodMS[channel] = @(newPeriodMS);
    return YES;
}

@end
