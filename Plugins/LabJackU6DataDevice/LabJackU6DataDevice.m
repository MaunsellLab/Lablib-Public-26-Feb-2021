//
//  LabJackU6DataDevice.m
//  Lablib
//
//  Copyright 2016. All rights reserved.
//

/* Detailed information about the low-level LabJack calls used here can be found at:
 
 https://labjack.com/support/datasheets/u3/low-level-function-reference/feedback
 
 The starting place for this code was porting over the plugin from MWorks, which was converted to
 Obj-C and Lablib format.  The first pass for a working LLDataDevice will be to have a task plugin
 that communicates directly with the LLDataDevice, as with the SDRDigitalOut.h digital output device
 in SignalDetection3.  This will closely follow the model used in the MWorks plugin regarding commands
 and data. Even in this version, setDataDevice: method calls will be made and serviced, but that will
 do little more than reset variables and ensure the device is ready.
 
 Once that version is up and running, it should be possible to extend the behavior of the device to allow
 for it to service the conventional data stream -- setting sampling intervals, number of active channels,
 etc.  Initially that will only need to be for DIO, but AIO should be a relatively simple extension in the
 future.
 
 Once the DIO is working OK, it should be relatively straightforward to have setDataEnabled: to start
 periodic sampling (or streaming) of digital values, and converting those samples into timestamps. Certainly
 that could be done with periodic sampling at whatever frequency the USB can support (200-1k Hz?), eventually
 it might be possible to stream, although I don't know how the streaming will interact with asynchronous 
 digital output that will be needed. */

//#import <eyelink_core/eyelink.h>
//#import <eyelink_core/core_expt.h>
#import <Lablib/LLPluginController.h>
#import <Lablib/LLSystemUtil.h>
#import "LabJackU6DataDevice.h"
#import "LabJackU6Settings.h"
#import "u6.h"

// From libusb.h

#define kBufferLength       2048
#define kDebounceS          0.005
#define kMaxAllowedTimeS    0.005
#define kUpdatePeriodUS     15000

// Digital output: Use a 12-bit word; EIO0-7, CIO0-2, convenience coding as follows:

#define LJU6_REWARD_FIO         0
#define LJU6_LEVER1_FIO         1
#define LJU6_LEVER1SOLENOID_FIO 2
#define LJU6_LASERTRIGGER_FIO   3
#define LJU6_LEVER2_FIO         4
#define LJU6_LEVER2SOLENOID_FIO 5
#define LJU6_COUNTER_FIO        6
#define LJU6_STROBE_FIO         7           // Strobe bit for digital output on EIO and CIO


typedef struct libusb_device_handle libusb_device_handle;

extern int libusb_reset_device(libusb_device_handle *dev);

static const char ljPortDir[3] = {                          // 0 input, 1 output
      (char)((0x01 << LJU6_REWARD_FIO)
           | (0x01 << LJU6_LEVER1SOLENOID_FIO)
           | (0x01 << LJU6_LEVER2SOLENOID_FIO)
           | (0x01 << LJU6_LASERTRIGGER_FIO)
           | (0x00 << LJU6_LEVER1_FIO)
           | (0x00 << LJU6_LEVER2_FIO)
           | (0x01 << LJU6_STROBE_FIO)),
    (char)0xff,                                             // EIO
    (char)0x0f};                                            // CIO


//#define kUseLLDataDevices        // needed for versioning

@implementation LabJackU6DataDevice

BOOL firstTrialSample;
long ELTrialStartTimeMS;

+ (NSInteger)version;
{
	return kLLPluginVersion;
}

- (void)configure;
{
    LabJackU6Settings *settings;
    
    if ((settings = [[LabJackU6Settings alloc] init]) != nil) {
        [settings runPanel];
        [settings release];
     }
}

- (void)dealloc;
{
    doingDealloc = YES;
    
/* ?????? must put these nodes back in and change them to proper scheduling
 
    if (pulseScheduleNode != NULL) {        //shared_ptr so this tells us if it points to anything
        [pulseScheduleNodeLock lock];
        [pulseScheduleNode cancel];
        [pulseScheduleNode reset];          // free the shared_ptr
        [pulseScheduleNodeLock unlock];
    }
  */
    // Couldn't we just close all the DO ports?
    
    [self ljU6WriteDO:LJU6_REWARD_FIO state:0];      // close juice solenoid
 /*   if (pollScheduleNode != NULL) {
        [pollScheduleNodeLock lock];
        [pollScheduleNode cancel];
        [pollScheduleNode reset]; // drop shared_ptr
        usleep(LJU6_DITASK_UPDATE_PERIOD_US * 2);  // wait for the last ones to finish
        [pollScheduleNodeLock unlock];
    } */
    
    if (ljHandle == NULL) {
        return;
    }
    [deviceLock lock];
    closeUSBConnection(ljHandle);
    usleep(10000);                              // wait 10 ms for it to go down
    ljHandle = NULL;
    [deviceLock unlock];
//	[dataLock unlock];
	[dataLock release];
	[deviceLock release];
	[monitor release];
	[super dealloc];
}

- (void)debounceState:(BOOL *)thisState lastState:(BOOL *)lastState lastTimeS:(double *)lastTransitionTimeS;
{
    double timeNowS;
    
    if (*lastTransitionTimeS == 0) {                    // first call, count current state as valid
        *lastState = *thisState;
        *lastTransitionTimeS = [LLSystemUtil getTimeS];
    }
    else if (*thisState != *lastState) {
        timeNowS = [LLSystemUtil getTimeS];
        if (timeNowS - *lastTransitionTimeS < kDebounceS) {
            *thisState = *lastState;                    // discard changes during deadtime
        }
        else {
            *lastState = *thisState;                    // record and report the transition
            *lastTransitionTimeS = timeNowS;
        }
    }
}

- (void)digitalOutputBits:(unsigned long)bits;
{
    if (ljHandle != NULL) {
        [deviceLock lock];
        if ([self ljU6WriteStrobedWord:bits]) {
            digitalOutputBits = bits;
        }
        else {
            NSLog(@"LabJackU6DataDevice digitalOutputBits: error writing digital word");
        }
        [deviceLock unlock];
    }
}

- (void)digitalOutputBitsOff:(unsigned long)bits;
{
    [self digitalOutputBits:(digitalOutputBits & ~bits)];
}

- (void)digitalOutputBitsOn:(unsigned long)bits;
{
    [self digitalOutputBits:(digitalOutputBits | bits)];
}

- (id)init;
{
	if ((self = [super init]) != nil) {
		

/*		lXData = [[NSMutableData alloc] init];
		lYData = [[NSMutableData alloc] init];
		lPData = [[NSMutableData alloc] init];
		rXData = [[NSMutableData alloc] init];
		rYData = [[NSMutableData alloc] init];
		rPData = [[NSMutableData alloc] init];
*/
        digitalOutputBits = 0;
        pollThread = nil;
		deviceEnabled = NO;
		dataEnabled = NO;
		devicePresent = NO;
		LabJackU6SamplePeriodS = 0.002;
			
		dataLock = [[NSLock alloc] init];
		deviceLock = [[NSLock alloc] init];

        deviceEnabled = NO;
        ljHandle = (void *)openUSBConnection(-1);                           // Open first available U6 on USB
        if (ljHandle == NULL) {
            NSLog(@"LabJackU6DataDevice init: Failed to find LabJackU6 hardware. Connected to USB?");
            devicePresent = NO;
            return self;
        }
        NSLog(@"LabJackU6 Data Device initialized");
        devicePresent = YES;
        monitor = [[LabJackU6Monitor alloc] initWithID:@"LabJackU6" description:@"LabJackU6 Monitor"];

        [self setupU6PortsAndRestartIfDead];
        lever1Solenoid = lever2Solenoid = 0;
        if (![self ljU6WriteDO:LJU6_LEVER1SOLENOID_FIO state:lever1Solenoid]) {
            return self;
        }
        if (![self ljU6WriteDO:LJU6_LEVER2SOLENOID_FIO state:lever2Solenoid]) {
            return self;
        }
        pulseOn = pulseDuration = laserTrigger = strobedDigitalWord = 0;
        if (![self ljU6WriteDO:LJU6_REWARD_FIO state:pulseOn]) {
            return self;
        }
        if (![self ljU6WriteDO:LJU6_LASERTRIGGER_FIO state:laserTrigger]) {
            return self;
        }
        if (![self ljU6WriteDO:LJU6_STROBE_FIO state:strobedDigitalWord]) {
            return self;
        }
//		nextSampleTimeS += [[samplePeriodMS objectAtIndex:0] floatValue] * LabJackU6SamplePeriodS;
    }
    return self;
}

- (void)laserDO:(BOOL)state;
{
    [deviceLock lock];
    if ([self ljU6WriteDO:LJU6_LASERTRIGGER_FIO state:state] != YES) {
        NSLog(@"%@", [NSString stringWithFormat:
                      @"writing lever 1 solenoid state; device likely to be broken (state %d)", state]);
    }
    [deviceLock unlock];
}

- (void)leverSolenoidDO:(BOOL)state channel:(long)channel;
{
    [deviceLock lock];
    if ([self ljU6WriteDO:channel state:state] != YES) {
        NSLog(@"%@", [NSString stringWithFormat:
                      @"writing lever 1 solenoid state; device likely to be broken (state %d)", state]);
    }
    [deviceLock unlock];
}

- (void)strobedDigitalWordDO:(unsigned int)digWord;
{
    [self digitalOutputBits:digWord];
}

// Configure LabJack ports.  Callers must lock

- (BOOL)ljU6ConfigPorts;
{
    uint8 sendDataBuff[7], errorCode, errorFrame;
    long error;
    long aEnableTimers[] = {0, 0, 0, 0};                // configure timers (none)
    long aTimerModes[] = {0, 0, 0, 0};
    double aTimerValues[] = {0.0, 0.0, 0.0, 0.0};
    long aEnableCounters[] = {0, 1};                    // use Counter1
   
    if (ljHandle == NULL) {
        return NO;
    }
    
    // Setup FIO as constants specify; EIO always output; CIO mask is hardcoded
    
    sendDataBuff[0] = 29;       // PortDirWrite
    sendDataBuff[1] = 0xff;     // update mask for FIO: update all
    sendDataBuff[2] = 0xff;     // update mask for EIO
    sendDataBuff[3] = 0x0f;     // update mask for CIO (only 4 bits)
    sendDataBuff[4] = ljPortDir[0];
    sendDataBuff[5] = ljPortDir[1];
    sendDataBuff[6] = ljPortDir[2];
    
    if (ehFeedback(ljHandle, sendDataBuff, 7, &errorCode, &errorFrame, NULL, 0) < 0) {
        NSLog(@"bug: ehFeedback error, see stdout");
        return NO;
    }
    if (errorCode) {
        NSLog(@"%@", [NSString stringWithFormat:@"ehFeedback: error with command, errorCode was %d", errorCode]);
        return NO;
    }
    if ((error = eTCConfig(ljHandle, aEnableTimers, aEnableCounters, LJU6_COUNTER_FIO, LJ_tc48MHZ, 0, aTimerModes,
                               aTimerValues, 0, 0)) != 0) {
        NSLog(@"%@", [NSString stringWithFormat:@"eTCConfig failed, error code was %ld", error]);
        return NO;
    }
    return YES;
}

- (long)ljU6ReadPorts:(unsigned int *)fioState EIOState:(unsigned int *)eioState CIOState:(unsigned int *)cioState;
{
    uint8 sendDataBuff[3], recDataBuff[7];
    uint8 errorCode, errorFrame;
    
    sendDataBuff[0] = 26;       //IOType is PortStateRead
    sendDataBuff[1] = 55;       //IOType is Counter1
    sendDataBuff[2] = 0;        //  - Don't reset counter
    
    if (ehFeedback(ljHandle, sendDataBuff, 3, &errorCode, &errorFrame, recDataBuff, 7) < 0)
        return -1L;
    if (errorCode) {
        return (long)errorCode;
    }
    *fioState = recDataBuff[0];
    *eioState = recDataBuff[1];
    *cioState = recDataBuff[2];
    
    // Unpack counter value
    uint32 counterValue;
    for (size_t i = 0; i < 4; i++) {
        ((uint8 *)(&counterValue))[i] = recDataBuff[3 + i];
    }
    counterValue = CFSwapInt32LittleToHost(counterValue);  // Convert to host byte order
    return 0L;
}

- (BOOL)ljU6WriteDO:(long)channel state:(long)state;
{
    uint8 sendDataBuff[2], errorCode, errorFrame;
    BOOL result;
    
    if (ljHandle == NULL) {
        return NO;
    }
    sendDataBuff[0] = 11;                                     // IOType is BitStateWrite
    sendDataBuff[1] = channel + 128 * ((state > 0) ? 1 : 0);  // IONumber(bits 0-4) + State (bit 7)
    [deviceLock lock];
    result = ehFeedback(ljHandle, sendDataBuff, 2, &errorCode, &errorFrame, NULL, 0);
    [deviceLock unlock];
    if (result < 0) {
        NSLog(@"ljU6WriteDO: ehFeedback error, see stdout");
        return NO;
    }
    if (errorCode) {
        NSLog(@"%@", [NSString stringWithFormat:@"ljU6WriteDO: error with command, errorcode was %d", errorCode]);
        return NO;
    }
    return YES;
}

- (BOOL)ljU6WriteStrobedWord:(unsigned long)inWord;
{
    uint8 outEioBits = inWord & 0xff;
    uint8 outCioBits = (inWord & 0xf00) >> 8;
    uint8 sendDataBuff[29];
    uint8 errorCode, errorFrame;
    
    if (inWord > 0xfff) {
        NSLog(@"error writing strobed word; value is larger than 12 bits (ignored)");
        return NO;
    }
    sendDataBuff[0] = 27;           // PortStateWrite, 7 bytes for this command -- load the word
    sendDataBuff[1] = 0x00;         // FIO: don't update
    sendDataBuff[2] = 0xff;         // EIO: update
    sendDataBuff[3] = 0x0f;         // CIO: update
    sendDataBuff[4] = 0x00;         // FIO: data
    sendDataBuff[5] = outEioBits;   // EIO: data
    sendDataBuff[6] = outCioBits;   // CIO: data
    
    sendDataBuff[7] = 5;            // WaitShort, 2 bytes for this command
    sendDataBuff[8] = 1;            // Time (128 us steps)
    
    sendDataBuff[9]  = 11;          // BitStateWrite, 2 bytes for this command -- stobe data ready
    sendDataBuff[10] = 7 | 0x80;    // first 4 bits: port # (FIO7); last bit, state
    
    sendDataBuff[11] = 5;           // WaitShort, 2 bytes for this command
    sendDataBuff[12] = 1;           // Time (128 us steps)
    
    sendDataBuff[13] = 27;          // PortStateWrite, 7 bytes for this command -- clear word and strobe
    sendDataBuff[14] = 0x80;        // FIO: update pin 7: 0x80
    sendDataBuff[15] = 0xff;        // EIO: update
    sendDataBuff[16] = 0x0f;        // CIO: update
    sendDataBuff[17] = 0x00;        // FIO: data
    sendDataBuff[18] = 0x00;        // EIO: data
    sendDataBuff[19] = 0x00;        // CIO: data
    
    // Note: fixed the ljPortDir mask for CIO.  This may remove the need for the following code.
    // But needs testing before removal, and only slows us down by 128us

    sendDataBuff[20] = 29;          // PortDirWrite - for some reason the above seems to reset the FIO input/output state
    sendDataBuff[21] = 0xff;        //  FIO: update
    sendDataBuff[22] = 0xff;        //  EIO: update
    sendDataBuff[23] = 0xff;        //  CIO: update
    sendDataBuff[24] = ljPortDir[0];//  FIO hardcoded above
    sendDataBuff[25] = ljPortDir[1];//  EIO hardcoded above
    sendDataBuff[26] = ljPortDir[2];//  CIO hardcoded above
    
    sendDataBuff[27] = 5;           // WaitShort   // 130424: w/o this 2 near-simul enc may result in 1st strobe still hi
    sendDataBuff[28] = 1;           // Time (128 us steps)
    
    
    if (ehFeedback(ljHandle, sendDataBuff, sizeof(sendDataBuff), &errorCode, &errorFrame, NULL, 0) < 0) {
        NSLog(@"ehFeedback error, see stdout");     // note we will get a more informative error on stdout
        return NO;
    }
    if (errorCode) {
        NSLog(@"%@", [NSString stringWithFormat:@"ehFeedback: error with command, errorcode was %d", errorCode]);
        return NO;
    }
    return YES;
}

- (id <LLMonitor>)monitor;
{
	return monitor;
}

- (void)disableSampleChannels:(NSNumber *)bitPattern;
{
    if (ljHandle == NULL) {
        return;
    }
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LabJackU6DataDevice" informativeText:[NSString stringWithFormat:
                @"Request to disable non-existent channel for device %@ (only %lu channels)",
                [self name], (unsigned long)[samplePeriodMS count]]];
		exit(0);
	}
	sampleChannels &= ~[bitPattern unsignedLongValue];
}

- (void)enableSampleChannels:(NSNumber *)bitPattern;
{
    if (ljHandle == NULL) {
        return;
    }
	if ([bitPattern unsignedLongValue] >= (0x01 << ([samplePeriodMS count] + 1))) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LabJackU6DataDevice" informativeText:[NSString stringWithFormat:
               @"Request to enable non-existent channel for device %@ (only %lu channels)",
               [self name], (unsigned long)[samplePeriodMS count]]];
		exit(0);
	}
	sampleChannels |= [bitPattern unsignedLongValue];
}

- (NSString *)name;
{
	return @"LabJackU6";
}

- (BOOL)readLeverDI:(BOOL *)outLever1 lever2:(BOOL *)outLever2;
{
    BOOL lever1State, lever2State;
    unsigned int fioState = 0L;
    unsigned int eioState = 0L;
    unsigned int cioState = 0L;
    
    static BOOL lastLever1State = NO;
    static BOOL lastLever2State = NO;
    static long unsigned slowCount = 0;
    static long unsigned allCount = 0;
    static double lastLever1TransitionTimeS = 0;
    static double lastLever2TransitionTimeS = 0;
    
    double elapsedTimeS, startTimeS, slowPercent;
    
    [deviceLock lock];
    startTimeS = [LLSystemUtil getTimeS];
    if ([self ljU6ReadPorts:&fioState EIOState:&eioState CIOState:&cioState] < 0) {
        [deviceLock unlock];
        NSLog(@"LabJackDataDevice readLeverDI: error reading DI, stopping IO ");
        [self setDataEnabled:NO];  // USB errors causing this, and the U6 isn't working anyway, so stop the threads
        return NO;
    }
    elapsedTimeS = [LLSystemUtil getTimeS] - startTimeS;
    [deviceLock unlock];
    allCount++;
    if (elapsedTimeS > kMaxAllowedTimeS) {
        slowCount++;
        if ((slowCount < 20) || (slowCount % 10 == 0)) {
            slowPercent = 100.0 * ((double)slowCount + 1) / ((double)allCount);
            NSLog(@"read port elapsed: this %.3fms, >%.0f ms %ld/%ld times (%4.3f%%)",
                     elapsedTimeS / 1000.0, kMaxAllowedTimeS / 1000.0, slowCount, allCount, slowPercent);
        }
    }
    lever1State = (fioState >> LJU6_LEVER1_FIO) & 0x01;
    lever2State = (fioState >> LJU6_LEVER2_FIO) & 0x01;
    [self debounceState:&lever1State lastState:&lastLever1State lastTimeS:&lastLever1TransitionTimeS];
    [self debounceState:&lever2State lastState:&lastLever2State lastTimeS:&lastLever2TransitionTimeS];
    *outLever1 = lever1State;
    *outLever2 = lever2State;
//    [deviceLock unlock];
    return(YES);
}

- (float)samplePeriodMSForChannel:(long)channel;
{
    if (ljHandle == NULL) {
        return 0;
    }
	if (channel >= [samplePeriodMS count]) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LabJackU6DataDevice" informativeText:[NSString stringWithFormat:
               @"Requested sample period %ld of %lu for device %@",
               channel, (unsigned long)[samplePeriodMS count], [self name]]];
		exit(0);
	}
	return [[samplePeriodMS objectAtIndex:channel] floatValue];
}

- (long)sampleChannels;
{
    if (ljHandle == NULL) {
        return 0;
    }
	return [samplePeriodMS count];
}

- (void)pollSamples;
{
//	int index = 0;
//	short sample = 0;

//	ISAMPLE oldSample, newSample;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//	oldSample.time = 0;
	pollThread = [NSThread currentThread];
	while (YES) {
		if (shouldKillPolling) {
			[pool release];
			pollThread = nil;
			[NSThread exit];
		}
//		while ((index = eyelink_get_sample(&newSample))) {
//			if (index && (newSample.time != oldSample.time)) {
        [dataLock lock];
        [self readLeverDI:&lever1 lever2:&lever2];
//                if (!firstTrialSample) {
//                    ELTrialStartTimeMS = eyelink_tracker_msec();
//                    NSLog(@"Current LabJackU6 time: %li",ELTrialStartTimeMS);
//                    NSLog(@"LabJackU6 Sample Time stamp: %u", newSample.time);
//                    NSLog(@"Difference: %li",ELTrialStartTimeMS-newSample.time);
//                    NSLog(@"Number of samples in EL buffer: %i",eyelink_data_count(1,0));
//                    firstTrialSample = YES;
//                }
//				sample = (short)(newSample.gx[RIGHT_EYE]);
//				[rXData appendBytes:&sample length:sizeof(sample)];
//				sample = (short)(-newSample.gy[RIGHT_EYE]);
//				[rYData appendBytes:&sample length:sizeof(sample)];
//				sample = (short)(newSample.pa[RIGHT_EYE]);
//				[rPData appendBytes:&sample length:sizeof(sample)];				
//                sample = (short)(newSample.gx[LEFT_EYE]);
//				[lXData appendBytes:&sample length:sizeof(sample)];
//				sample = (short)(-newSample.gy[LEFT_EYE]);
//				[lYData appendBytes:&sample length:sizeof(sample)];
//				sample = (short)(newSample.pa[LEFT_EYE]);
//				[lPData appendBytes:&sample length:sizeof(sample)];
				values.samples++;
				[dataLock unlock];
//				oldSample = newSample;
//			}
//		}
		usleep(kUpdatePeriodUS);										// sleep 15 ms
	}
}

- (NSData **)sampleData;
{
//	short index;
//    NSMutableData *samples;
//	NSArray *sampleArray;
    
    // Lock, then copy pointers to the sample data
	
    if (ljHandle == NULL) {
        return nil;
    }
    
//	[dataLock lock];
//    sampleArray = [NSArray arrayWithObjects:lXData, lYData, lPData, rXData, rYData, rPData, nil];
//	
//	//Now alloc/init new data instances and swap those in
//	//(For performance reasons, it might be worthwhile to preallocate two sets of these, and swap them in and out)
//
//	lXData = [[NSMutableData alloc] init];
//	lYData = [[NSMutableData alloc] init];
//	lPData = [[NSMutableData alloc] init];
//	rXData = [[NSMutableData alloc] init];
//	rYData = [[NSMutableData alloc] init];
//	rPData = [[NSMutableData alloc] init];
//	
//    [dataLock unlock];
//	
//// Bundle the data pointers into an array.  If the channel is disabled, nil is returned.  If the 
//// data length is zero, nil is returned.
//
//	for (index = 0; index < kLabJackU6Channels; index++) {
//        samples = [sampleArray objectAtIndex:index];
//		if (!(sampleChannels & (0x1 << index))) {                   // disabled channel
//			sampleData[index] = nil;                                // not enabled or no samples
//        }
//        else if ([samples length] == 0) {                           // no data samples
//			sampleData[index] = nil;                                // not enabled or no samples
//		}
//        else {
//            sampleData[index] = samples;
//        }
//        [samples autorelease];
//	}
	return sampleData;
}

// This is the method is typically called at the start and end of every trial to toggle data collection.

- (void)setDataEnabled:(NSNumber *)state;
{
//	long maxSamplingRateHz = 1000;
	
    if (ljHandle == NULL) {
        return;
    }
	if ([state boolValue] && !dataEnabled) {						// toggle from OFF to ON
        [self setupU6PortsAndRestartIfDead];                        // check on hardware, restart if needed.
        [deviceLock lock];
        if (pollThread == nil) {
            shouldKillPolling = NO;
            [NSThread detachNewThreadSelector:@selector(pollSamples) toTarget:self withObject:nil];
        }

//        if (maxSamplingRateHz != 0) {							    // no channels enabled
//			sampleTimeS = LabJackU6SamplePeriodS;					// one period complete on first sample
//			justStartedLabJackU6 = YES;
//			[monitor initValues:&values];
//			values.samplePeriodMS = LabJackU6SamplePeriodS * 1000.0;
//			monitorStartTimeS = [LLSystemUtil getTimeS];
//			lastReadDataTimeS = 0;
//            firstTrialSample = NO;
//		}
		dataEnabled = YES;
        [deviceLock unlock];
	} 
	else if (![state boolValue] && dataEnabled) {					// toggle from ON to OFF
                                                                    //        [deviceLock lock]; // shouldn't need to lock -- just setting flag.
        shouldKillPolling = YES;
        while (pollThread != nil) {
            usleep(100);
        }
//        [deviceLock unlock];
		values.cumulativeTimeMS = ([LLSystemUtil getTimeS] - monitorStartTimeS) * 1000.0;
		lastReadDataTimeS = 0;
        values.sequences = 1;
		[monitor sequenceValues:values];
		dataEnabled = NO;
    }
}

- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
{
    if (ljHandle == NULL) {
        return NO;
    }
	if (channel >= [samplePeriodMS count]) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LabJackU6DataDevice" informativeText:[NSString stringWithFormat:
                   @"Attempt to set sample period %ld of %lu for device %@",
                   channel, (unsigned long)[samplePeriodMS count], [self name]]];
//		NSRunAlertPanel(@"LabJackU6DataDevice", @"Attempt to set sample period %ld of %lu for device %@",
//				@"OK", nil, nil, channel, (unsigned long)[samplePeriodMS count], [self name]);
		exit(0);
	}
	[samplePeriodMS replaceObjectAtIndex:channel 
					withObject:[NSNumber numberWithFloat:newPeriodMS]];
	return YES;
}

- (BOOL)setupU6PortsAndRestartIfDead;
{
    BOOL result = YES;
    
    if (ljHandle == NULL) {
        return NO;
    }
    [deviceLock lock];
    // Do physical port setup
    if (![self ljU6ConfigPorts] && ![self ljU6ConfigPorts] && ![self ljU6ConfigPorts]) {
        NSLog(@"LJU6 found dead, restarting");
        libusb_reset_device((libusb_device_handle *)ljHandle);          // patched usb library uses ReEnumerate
        closeUSBConnection(ljHandle);
        sleep(5.0); // histed: MaunsellMouse1 - 0.1s not enough, 0.2 works, add padding
        NSLog(@"Sleeping for 5.0 s after restarting LJU6");
        if ( (ljHandle = openUSBConnection(-1)) == NULL) {
            NSLog(@"Error: could not reopen USB U6 device after reset; U6 will not work now.");
            result = NO;
        }
        if (![self ljU6ConfigPorts]) {
            NSLog(@"Error configuring U6 after restart, U6 will not work now.  Check for patched version of libusb with reenumerate call.\n");
            result = NO;  // no cleanup needed
        }
    }
    [deviceLock unlock];
    return result;
}

@end


/*


#define LJU6_EMPIRICAL_DO_LATENCY_MS 1   // average when plugged into a highspeed hub.  About 8ms otherwise

BEGIN_NAMESPACE_MW


 // helper function declarations
void debounce_bit(unsigned int *thisState, unsigned int *lastState, MWTime *lastTransitionTimeUS, boost::shared_ptr <Clock> clock);


const std::string LabJackU6Device::PULSE_DURATION("pulse_duration");
const std::string LabJackU6Device::PULSE_ON("pulse_on");
const std::string LabJackU6Device::LEVER1("lever1");
const std::string LabJackU6Device::LEVER2("lever2");
const std::string LabJackU6Device::LEVER1_SOLENOID("lever1_solenoid");
const std::string LabJackU6Device::LEVER2_SOLENOID("lever2_solenoid");
const std::string LabJackU6Device::LASER_TRIGGER("laser_trigger");
const std::string LabJackU6Device::STROBED_DIGITAL_WORD("strobed_digital_word");
const std::string LabJackU6Device::COUNTER("counter");


 // Notes to self MH 100422
 This is how we do setup and cleanup
 * Constructor [called at plugin load time]
 Sets instant variables
 * core calls attachPhysicalDevice()
 -> variableSetup()
 * startup()  [called by core; once, I think]
 * startDeviceIO()  [called by core; every trial]
 * stopDeviceIO()   [called by core; every trial]
 * shutdown() [called by core; once, I think]
 * Destructor
 -> detachPhysicalDevice
 
 What we do:
 Constructor [sets up instance variables]
 
 *

 // Object functions


void LabJackU6Device::describeComponent(ComponentInfo &info) {
    IODevice::describeComponent(info);
    
    info.setSignature("iodevice/labjacku6");
    
    info.addParameter(PULSE_DURATION);
    info.addParameter(PULSE_ON, "false");
    info.addParameter(LEVER1, "false");
    info.addParameter(LEVER2, "false");
    info.addParameter(LEVER1_SOLENOID, "false");
    info.addParameter(LEVER2_SOLENOID, "false");
    info.addParameter(LASER_TRIGGER, "false");
    info.addParameter(STROBED_DIGITAL_WORD, "0");
    info.addParameter(COUNTER, "0");
}


// Constructor for LabJackU6Device
LabJackU6Device::LabJackU6Device(const ParameterValueMap &parameters) :
IODevice(parameters),
scheduler(Scheduler::instance()),
pulseDuration(parameters[PULSE_DURATION]),
pulseOn(parameters[PULSE_ON]),
lever1(parameters[LEVER1]),
lever2(parameters[LEVER2]),
lever1Solenoid(parameters[LEVER1_SOLENOID]),
lever2Solenoid(parameters[LEVER2_SOLENOID]),
laserTrigger(parameters[LASER_TRIGGER]),
strobedDigitalWord(parameters[STROBED_DIGITAL_WORD]),
counter(parameters[COUNTER]),
deviceIOrunning(false),
ljHandle(NULL),
lastLever1Value(-1),  // -1 means always report first value
lastLever2Value(-1),  // -1 means always report first value
lastLever1TransitionTimeUS(0),
lastLever2TransitionTimeUS(0)
{
    if (VERBOSE_IO_DEVICE >= 2) {
        mprintf(M_IODEVICE_MESSAGE_DOMAIN, "LabJackU6Device: constructor");
    }
    
    doingDealloc = NO;
    
    openlog("LGU6Plugin", LOG_NDELAY, LOG_USER);
}


// Schedule function, never scheduled if LabJack is not initialized

void *endPulse(const boost::weak_ptr<LabJackU6Device> &gp) {
    
    boost::shared_ptr <Clock> clock = Clock::instance();
    if (VERBOSE_IO_DEVICE >= 2) {
        mprintf("LabJackU6Device: endPulse callback at %lld us", clock->getCurrentTimeUS());
    }
    boost::shared_ptr<LabJackU6Device> sp = gp.lock();
    sp->pulseDOLow();
    return(NULL);
}


void LabJackU6Device::pulseDOHigh(int pulseLengthUS) {
    boost::shared_ptr <Clock> clock = Clock::instance();
    // Takes and releases pulseScheduleNodeLock
    // Takes and releases driver lock
    
    // Set the DO high first
    boost::mutex::scoped_lock lock(ljU6DriverLock);  //printf("lock DOhigh\n"); fflush(stdout);
    if (ljHandle == NULL) {
        return;
    }
    if (VERBOSE_IO_DEVICE >= 2) {
        mprintf("LabJackU6Device: setting pulse high %d ms (%lld)", pulseLengthUS / 1000, clock->getCurrentTimeUS());
    }
    MWTime t1 = clock->getCurrentTimeUS();  // to check elapsed time below
    if (ljU6WriteDO(ljHandle, LJU6_REWARD_FIO, 1) == false) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "bug: writing digital output high; device likely to not work from here on");
        return;
    }
    lock.unlock();      //printf("unlock DOhigh\n"); fflush(stdout);
    
    if (clock->getCurrentTimeUS() - t1 > 4000) {
        merror(M_IODEVICE_MESSAGE_DOMAIN,
               "LJU6: Writing the DO took longer than 4ms.  Is the device connected to a high-speed hub?  Pulse length is wrong.");
    }
    
    // Schedule endPulse call
    if (pulseLengthUS <= LJU6_EMPIRICAL_DO_LATENCY_MS+1) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "LJU6: requested pulse length %dms too short (<%dms), not doing digital IO",
               pulseLengthUS, LJU6_EMPIRICAL_DO_LATENCY_MS+1);
    } else {
        // long enough, do it
        boost::mutex::scoped_lock pLock(pulseScheduleNodeLock);
        boost::shared_ptr<LabJackU6Device> this_one = shared_from_this();
        pulseScheduleNode = scheduler->scheduleMS(std::string(FILELINE ": ") + getTag(),
                                                  (pulseLengthUS / 1000.0) - LJU6_EMPIRICAL_DO_LATENCY_MS,
                                                  0,
                                                  1,
                                                  boost::bind(endPulse, boost::weak_ptr<LabJackU6Device>(this_one)),
                                                  M_DEFAULT_IODEVICE_PRIORITY,
                                                  M_DEFAULT_IODEVICE_WARN_SLOP_US,
                                                  M_DEFAULT_IODEVICE_FAIL_SLOP_US,
                                                  M_MISSED_EXECUTION_DROP);
        //Here we use a weak_ptr, and turn into a shared_ ptr in endPulse, so that the existence of this task does not
        // prevent LJU6 object destruction.  In the destructor we kill the task and close the solenoid.
        // Could have done this in stopDeviceIO but that gets called every trial and juice offset could bleed over.
        //  MH 130629
        MWTime current = clock->getCurrentTimeUS();
        if (VERBOSE_IO_DEVICE >= 2) {
            mprintf("LabJackU6Device:  schedule endPulse callback at %lld us (%lld)", current, clock->getCurrentTimeUS());
        }
        highTimeUS = current;
    }
    
}

 
 long ehFeedback(HANDLE hDevice, uint8 *inIOTypesDataBuff, long inIOTypesDataSize, uint8 *outErrorcode, uint8 *outErrorFrame, uint8 *outDataBuff, long outDataSize)
 {
 uint8 *sendBuff, *recBuff;
 uint16 checksumTotal;
 int sendChars, recChars, i, sendDWSize, recDWSize, commandBytes, ret;
 
 ret = 0;
 commandBytes = 6;
 
 if (((sendDWSize = inIOTypesDataSize + 1) % 2) != 0)
    sendDWSize++;
 if(((recDWSize = outDataSize + 3) % 2) != 0)
    recDWSize++;
 
 sendBuff = malloc(sizeof(uint8)*(commandBytes + sendDWSize));
 recBuff = malloc(sizeof(uint8)*(commandBytes + recDWSize));
 
 if(sendBuff == NULL || recBuff == NULL) {
    ret = -1;
    goto cleanmem;
 }
 
 sendBuff[sendDWSize + commandBytes - 1] = 0;
 
 // Setting up Feedback command
 
sendBuff[1] = (uint8)(0xF8);  //Command byte
sendBuff[2] = sendDWSize / 2;   //Number of data words (.5 word for echo, 1.5
                              //words for IOTypes)
sendBuff[3] = (uint8)(0x00);  //Extended command number
sendBuff[6] = 0;    //Echo

for(i = 0; i < inIOTypesDataSize; i++)
    sendBuff[i+commandBytes+1] = inIOTypesDataBuff[i];

extendedChecksum(sendBuff, (sendDWSize+commandBytes));

//Sending command to U6
if( (sendChars = LJUSB_BulkWrite(hDevice, U6_PIPE_EP1_OUT, sendBuff, (sendDWSize+commandBytes))) < sendDWSize+commandBytes)
{
    if(sendChars == 0)
        printf("ehFeedback error : write failed\n");
        else
            printf("ehFeedback error : did not write all of the buffer\n");
            ret = -1;
            goto cleanmem;
}

//Reading response from U6
if( (recChars = LJUSB_BulkRead(hDevice, U6_PIPE_EP2_IN, recBuff, (commandBytes+recDWSize))) < commandBytes+recDWSize)
{
    if(recChars == -1)
    {
        printf("ehFeedback error : read failed\n");
        ret = -1;
        goto cleanmem;
    }
    else if(recChars < 8)
    {
        printf("ehFeedback error : response buffer is too small\n");
        for(i = 0; i < recChars; i++)
            printf("%d ", recBuff[i]);
        ret = -1;
        goto cleanmem;
    }
    else
        printf("ehFeedback error : did not read all of the expected buffer (received %d, expected %d )\n", recChars, commandBytes+recDWSize);
        }

checksumTotal = extendedChecksum16(recBuff, recChars);
if( (uint8)((checksumTotal / 256 ) & 0xff) != recBuff[5])
{
    printf("ehFeedback error : read buffer has bad checksum16(MSB)\n");
    ret = -1;
    goto cleanmem;
}

if( (uint8)(checksumTotal & 0xff) != recBuff[4])
{
    printf("ehFeedback error : read buffer has bad checksum16(LBS)\n");
    ret = -1;
    goto cleanmem;
}

if( extendedChecksum8(recBuff) != recBuff[0])
{
    printf("ehFeedback error : read buffer has bad checksum8\n");
    ret = -1;
    goto cleanmem;
}

if( recBuff[1] != (uint8)(0xF8) || recBuff[3] != (uint8)(0x00) )
{
    printf("ehFeedback error : read buffer has wrong command bytes \n");
    ret = -1;
    goto cleanmem;
}

*outErrorcode = recBuff[6];
*outErrorFrame = recBuff[7];

for(i = 0; i+commandBytes+3 < recChars && i < outDataSize; i++)
outDataBuff[i] = recBuff[i+commandBytes+3];

cleanmem:
free(sendBuff);
free(recBuff);
sendBuff = NULL;
recBuff = NULL;

return ret;
}

*/
