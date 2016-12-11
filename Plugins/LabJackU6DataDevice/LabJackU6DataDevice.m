//
//  LabJackU6DataDevice.m
//  Lablib
//
//  Copyright 2016. All rights reserved.
//

#import <eyelink_core/eyelink.h>
#import <eyelink_core/core_expt.h>
#import <Lablib/LLPluginController.h>
#import <Lablib/LLSystemUtil.h>
#import "LabJackU6DataDevice.h"
#import "LabJackU6Settings.h"
#import "u6.h"

// From libusb.h
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
	[dataLock unlock];
	[dataLock release];
	[deviceLock release];
	[monitor release];
	[super dealloc];
}

- (id)init;
{
	int index;

	if ((self = [super init]) != nil) {
		

/*		lXData = [[NSMutableData alloc] init];
		lYData = [[NSMutableData alloc] init];
		lPData = [[NSMutableData alloc] init];
		rXData = [[NSMutableData alloc] init];
		rYData = [[NSMutableData alloc] init];
		rPData = [[NSMutableData alloc] init];
*/
		pollThread = nil;
		deviceEnabled = NO;
		dataEnabled = NO;
		devicePresent = YES;
		LabJackU6SamplePeriodS = 0.002;
			
		dataLock = [[NSLock alloc] init];
		deviceLock = [[NSLock alloc] init];

        ljHandle = (void *)openUSBConnection(-1);                           // Open first available U6 on USB
        if (ljHandle == NULL) {
            NSLog(@"LabJackU6DataDevice init: Failed to open LabJackU6. Is it conncected to USB?");
            return self;
        }
        NSLog(@"LabJackU6 Data Device initialized");
        [self setupU6PortsAndRestartIfDead];
        monitor = [[LabJackU6Monitor alloc] initWithID:@"LabJackU6" description:@"LabJackU6 Monitor"];
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
		nextSampleTimeS += [[samplePeriodMS objectAtIndex:0] floatValue] * LabJackU6SamplePeriodS;
				
        NSLog(@"LabJackU6DataDevice: Since 10.10, the EyeLink API is generating a thread_policy_set error");
		if ((index = open_eyelink_connection(0))) {
			deviceEnabled = devicePresent = NO;
		}
		else {
			deviceEnabled = devicePresent = YES;
			stop_recording();                           // make sure we're stopped
		}
	}
	return self;
}

// Configure LabJack ports.  Callers must lock

- (BOOL)ljU6ConfigPorts;
{
    uint8 sendDataBuff[7], errorCode, errorFrame;
    long error;
    long aEnableTimers[] = { 0, 0, 0, 0 };              // configure counter
    long aEnableCounters[] = { 0, 1 };                  // Uuse Counter1
    long aTimerModes[] = { 0, 0, 0, 0 };
    double aTimerValues[] = { 0.0, 0.0, 0.0, 0.0 };
    
    
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

- (BOOL)ljU6WriteDO:(long)channel state:(long)state;
{
    uint8 sendDataBuff[2], errorCode, errorFrame;
    
    if (ljHandle == NULL) {
        return NO;
    }
    sendDataBuff[0] = 11;                                     // IOType is BitStateWrite
    sendDataBuff[1] = channel + 128 * ((state > 0) ? 1 : 0);  // IONumber(bits 0-4) + State (bit 7)
    if (ehFeedback(ljHandle, sendDataBuff, 2, &errorCode, &errorFrame, NULL, 0) < 0) {
        NSLog(@"ljU6WriteDO: ehFeedback error, see stdout");
        return NO;
    }
    if (errorCode) {
        NSLog(@"%@", [NSString stringWithFormat:@"ljU6WriteDO: error with command, errorcode was %d", errorCode]);
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

- (void)pollSamples
{
	int index = 0;
	short sample = 0;
	ISAMPLE oldSample, newSample;
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    if (ljHandle == NULL) {
        return;
    }
	oldSample.time = 0;
	pollThread = [NSThread currentThread];
	
	while (YES) {
		if (shouldKillThread) {
			[pool release];
			pollThread = nil;
			[NSThread exit];
		}
		while ((index = eyelink_get_sample(&newSample))) {
			if (index && (newSample.time != oldSample.time)) {
				[dataLock lock];
                if (!firstTrialSample) {
                    ELTrialStartTimeMS = eyelink_tracker_msec();
                    NSLog(@"Current LabJackU6 time: %li",ELTrialStartTimeMS);
                    NSLog(@"LabJackU6 Sample Time stamp: %u", newSample.time);
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
		usleep(20000);										// sleep 20 ms
	}
}

- (NSData **)sampleData;
{
	short index;
    NSMutableData *samples;
	NSArray *sampleArray;
    
    // Lock, then copy pointers to the sample data
	
    if (ljHandle == NULL) {
        return nil;
    }
	[dataLock lock];
    sampleArray = [NSArray arrayWithObjects:lXData, lYData, lPData, rXData, rYData, rPData, nil];
	
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

	for (index = 0; index < kLabJackU6Channels; index++) {
        samples = [sampleArray objectAtIndex:index];
		if (!(sampleChannels & (0x1 << index))) {                   // disabled channel
			sampleData[index] = nil;                                // not enabled or no samples
        }
        else if ([samples length] == 0) {                           // no data samples
			sampleData[index] = nil;                                // not enabled or no samples
		}
        else {
            sampleData[index] = samples;
        }
        [samples autorelease];
	}
	return sampleData;
}

- (void)setDataEnabled:(NSNumber *)state;
{
	long maxSamplingRateHz = 1000;
	
    if (ljHandle == NULL) {
        return;
    }
	if ([state boolValue] && !dataEnabled) {						// toggle from OFF to ON
        [deviceLock lock];
		if (maxSamplingRateHz != 0) {							    // no channels enabled
			sampleTimeS = LabJackU6SamplePeriodS;						// one period complete on first sample
			justStartedLabJackU6 = YES;
			//[deviceLock lock];
			start_recording(0,0,1,0);                               // tell device to start recording
			//[deviceLock unlock];
			[monitor initValues:&values];
			values.samplePeriodMS = LabJackU6SamplePeriodS * 1000.0;
			monitorStartTimeS = [LLSystemUtil getTimeS];
			lastReadDataTimeS = 0;
			dataEnabled = YES;
            firstTrialSample = NO;
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
    
    if (ljHandle == NULL) {
        return;
    }
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
			error = start_recording(0, 0, 1, 0);                    // LabJackU6: link, not file, samples, no events
		}
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
            return NO;
        }
        if (![self ljU6ConfigPorts]) {
            NSLog(@"Error configuring U6 after restart, U6 will not work now.  Check for patched version of libusb with reenumerate call.\n");
            return NO;  // no cleanup needed
        }
    }
    [deviceLock unlock];
    return YES;
}

@end


/* 
  *  -*- mode: c++; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*-
 
 *  LabJack U6 Plugin for MWorks
 *
 *  100421: Mark Histed created
 *    (based on Nidaq plugin code; Hendry, Maunsell)
 *  120708 histed - revised for two levers
 *
 *


#include <boost/bind.hpp>
#include "u6.h"
#include "LabJackU6Device.h"
#include <stdio.h>
#include <syslog.h>

#define kBufferLength   2048
#define kDIDeadtimeUS   5000
#define kDIReportTimeUS 5000



#define LJU6_EMPIRICAL_DO_LATENCY_MS 1   // average when plugged into a highspeed hub.  About 8ms otherwise

static const char ljPortDir[3] = {  // 0 input, 1 output
    (char)( (0x01 << LJU6_REWARD_FIO)
           | (0x01 << LJU6_LEVER1SOLENOID_FIO)
           | (0x01 << LJU6_LEVER2SOLENOID_FIO)
           | (0x01 << LJU6_LASERTRIGGER_FIO)
           | (0x00 << LJU6_LEVER1_FIO)
           | (0x00 << LJU6_LEVER2_FIO)
           | (0x01 << LJU6_STROBE_FIO) ),
    (char)0xff,     // EIO
    0x0f };   // CIO




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


void LabJackU6Device::leverSolenoidDO(bool state, long channel) {
    // Takes and releases driver lock
    
    boost::mutex::scoped_lock lock(ljU6DriverLock);
    
    if (ljU6WriteDO(ljHandle, channel, state) != true) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "bug: writing lever 1 solenoid state; device likely to be broken (state %d)", state);
    }
}

void LabJackU6Device::laserDO(bool state) {
    // Takes and releases driver lock
    
    boost::mutex::scoped_lock lock(ljU6DriverLock);
    
    if (ljU6WriteDO(ljHandle, LJU6_LASERTRIGGER_FIO, state) != true) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "bug: writing laser trigger state; device likely to be broken (state %d)", state);
    }
    
}

void LabJackU6Device::strobedDigitalWordDO(unsigned int digWord) {
    // Takes and releases driver lock
    
    boost::mutex::scoped_lock lock(ljU6DriverLock);
    
    LabJackU6Device::ljU6WriteStrobedWord(ljHandle, digWord); // error checking done inside here; will call merror
    
}


bool LabJackU6Device::readLeverDI(bool *outLever1, bool *outLever2)
// Takes the driver lock and releases it
{
    boost::shared_ptr <Clock> clock = Clock::instance();
    
    unsigned int lever1State = 0L;
    unsigned int lever2State = 0L;
    
    unsigned int fioState = 0L;
    unsigned int eioState = 0L;
    unsigned int cioState = 0L;
    
    static unsigned int lastLever1State = 0xff;
    static unsigned int lastLever2State = 0xff;
    static long unsigned slowCount = 0;
    static long unsigned allCount = 0;
    
    double pct;
    
    boost::mutex::scoped_lock lock(ljU6DriverLock);
    
    if (ljHandle == NULL || !this->getActive()) {
        return false;
    }
    
    
    MWTime st = clock->getCurrentTimeUS();
    if (ljU6ReadPorts(ljHandle, &fioState, &eioState, &cioState) < 0 ) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "Error reading DI, stopping IO and returning FALSE");
        stopDeviceIO();  // We are seeing USB errors causing this, and the U6 doesn't work anyway, so might as well stop the threads
        return false;
    }
    MWTime elT = clock->getCurrentTimeUS()-st;
    allCount = allCount+1;
    
    
    if (elT > kDIReportTimeUS) {
        ++slowCount;
        if ((slowCount < 20) || (slowCount % 10 == 0)) {
            pct = 100.0*((double)slowCount+1)/((double)allCount);
            mwarning(M_IODEVICE_MESSAGE_DOMAIN, "read port elapsed: this %.3fms, >%.0f ms %ld/%ld times (%4.3f%%)",
                     elT / 1000.0,
                     kDIReportTimeUS / 1000.0,
                     slowCount,
                     allCount,
                     pct);
        }
    }
    
    lever1State = (fioState >> LJU6_LEVER1_FIO) & 0x01;
    lever2State = (fioState >> LJU6_LEVER2_FIO) & 0x01;
    
    // software debouncing
    debounce_bit(&lever1State, &lastLever1State, &lastLever1TransitionTimeUS, clock);
    debounce_bit(&lever2State, &lastLever2State, &lastLever2TransitionTimeUS, clock);
    
    *outLever1 = lever1State;
    *outLever2 = lever2State;
    
    return(1);
}

 *******************************************************************

void debounce_bit(unsigned int *thisState, unsigned int *lastState, MWTime *lastTransitionTimeUS, boost::shared_ptr <Clock> clock) {
    // software debouncing
    if (*thisState != *lastState) {
        if (clock->getCurrentTimeUS() - *lastTransitionTimeUS < kDIDeadtimeUS) {
            *thisState = *lastState;                // discard changes during deadtime
            mwarning(M_IODEVICE_MESSAGE_DOMAIN,
                     "LabJackU6Device: readLeverDI, debounce rejecting new read (last %lld now %lld, diff %lld)",
                     *lastTransitionTimeUS,
                     clock->getCurrentTimeUS(),
                     clock->getCurrentTimeUS() - *lastTransitionTimeUS);
        }
        *lastState = *thisState;                    // record and report the transition
        *lastTransitionTimeUS = clock->getCurrentTimeUS();
    }
}


// External function for scheduling

void *update_lever(const boost::weak_ptr<LabJackU6Device> &gp){
    boost::shared_ptr <Clock> clock = Clock::instance();
    boost::shared_ptr <LabJackU6Device> sp = gp.lock();
    sp->pollAllDI();
    sp.reset();
    return NULL;
}

bool LabJackU6Device::pollAllDI() {
    
    bool lever1Value;
    bool lever2Value;
    bool res;
    
    res = readLeverDI(&lever1Value, &lever2Value);
    //mprintf(M_IODEVICE_MESSAGE_DOMAIN, "levers: %d %d", lever1Value, lever2Value);
    
    if (!res) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "LJU6: error in readLeverDI()");
    }
    
    // Change MW variable value only if switch state is unchanged, or this is the first time through
    if ( (lastLever1Value == -1) // -1 means first time through
        || (lever1Value != lastLever1Value) ) {
        
        lever1->setValue(Datum(lever1Value));
        lastLever1Value = lever1Value;
    }
    if ( (lastLever2Value == -1) // -1 means first time through
        || (lever2Value != lastLever2Value) ) {
        
        lever2->setValue(Datum(lever2Value));
        lastLever2Value = lever2Value;
    }
    
    return true;
}



 // IODevice virtual calls (made by MWorks) ***********************


bool LabJackU6Device::startup() {
    // Do nothing right now
    if (VERBOSE_IO_DEVICE >= 2) {
        mprintf("LabJackU6Device: startup");
    }
    return true;
}


bool LabJackU6Device::shutdown(){
    // Do nothing right now
    if (VERBOSE_IO_DEVICE >= 2) {
        mprintf("LabJackU6Device: shutdown");
    }
    return true;
}


bool LabJackU6Device::startDeviceIO(){
    // Start the scheduled IO on the LabJackU6.  This starts a thread that reads the input ports
    
    if (VERBOSE_IO_DEVICE >= 1) {
        mprintf("LabJackU6Device: startDeviceIO");
    }
    if (deviceIOrunning) {
        merror(M_IODEVICE_MESSAGE_DOMAIN,
               "LabJackU6Device startDeviceIO:  startDeviceIO request was made without first stopping IO, aborting");
        return false;
    }
    
    // check hardware and restart if necessary
    setupU6PortsAndRestartIfDead();
    
    //  schedule_nodes_lock.lock();         // Seems to be no longer supported in MWorks
    
    setActive(true);
    deviceIOrunning = true;
    
    boost::shared_ptr<LabJackU6Device> this_one = shared_from_this();
    pollScheduleNode = scheduler->scheduleUS(std::string(FILELINE ": ") + getTag(),
                                             (MWTime)0,
                                             LJU6_DITASK_UPDATE_PERIOD_US,
                                             M_REPEAT_INDEFINITELY,
                                             boost::bind(update_lever, boost::weak_ptr<LabJackU6Device>(this_one)),
                                             M_DEFAULT_IODEVICE_PRIORITY,
                                             LJU6_DITASK_WARN_SLOP_US,
                                             LJU6_DITASK_FAIL_SLOP_US,
                                             M_MISSED_EXECUTION_DROP);
    
    //schedule_nodes.push_back(pollScheduleNode);
    //  schedule_nodes_lock.unlock();       // Seems to be no longer supported in MWorks
    
    return true;
}

bool LabJackU6Device::stopDeviceIO(){
    
    // Stop the LabJackU6 collecting data.  This is typically called at the end of each trial.
    
    if (VERBOSE_IO_DEVICE >= 1) {
        mprintf("LabJackU6Device: stopDeviceIO");
    }
    if (!deviceIOrunning) {
        mwarning(M_IODEVICE_MESSAGE_DOMAIN, "stopDeviceIO: already stopped on entry; using this chance to turn off lever solenoids");
        
        // force off solenoid
        this->lever1Solenoid->setValue(false);
        this->lever2Solenoid->setValue(false);
        leverSolenoidDO(false, LJU6_LEVER1SOLENOID_FIO);
        leverSolenoidDO(false, LJU6_LEVER2SOLENOID_FIO);
        
        return false;
    }
    
    // stop all the scheduled DI checking (i.e. stop calls to "updateChannel")
    //stopAllScheduleNodes();                               // IO device base class method -- this is thread safe
    if (pollScheduleNode != NULL) {
        //merror(M_IODEVICE_MESSAGE_DOMAIN, "Error: pulseDOL
        boost::mutex::scoped_lock lock(pollScheduleNodeLock);
        pollScheduleNode->cancel();
        pollScheduleNode.reset();  // drop shared_ptr and clean this up
                                   //pollScheduleNode->kill();  // MH This is not allowed!  This can make both the USB bus unhappy and also leave the lock
                                   //    in a locked state.
                                   //    If you insist on killing a thread that may be talking to the LabJack you should reset the USB bus.
    }
    
    //setActive(false);   // MH - by leaving active == true, we can use the Reward window to schedule pulses when trials are not running
    deviceIOrunning = false;
    return true;
}

 // Hardware functions *********************************


bool LabJackU6Device::ljU6ReadPorts(HANDLE Handle,
                                    unsigned int *fioState, unsigned int *eioState, unsigned int *cioState)
{
    uint8 sendDataBuff[3], recDataBuff[7];
    uint8 Errorcode, ErrorFrame;
    
    sendDataBuff[0] = 26;       //IOType is PortStateRead
    sendDataBuff[1] = 55;       //IOType is Counter1
    sendDataBuff[2] = 0;        //  - Don't reset counter
    
    if(ehFeedback(Handle, sendDataBuff, 3, &Errorcode, &ErrorFrame, recDataBuff, 7) < 0)
        return -1;
    if(Errorcode)
        return (long)Errorcode;
    
    *fioState = recDataBuff[0];
    *eioState = recDataBuff[1];
    *cioState = recDataBuff[2];
    
    // debug
    //mprintf("FIO 0x%x EIO 0x%x CIO 0x%x", *fioState, *eioState, *cioState);
    
    // Unpack counter value
    uint32 counterValue;
    for (size_t i = 0; i < 4; i++) {
        ((uint8 *)(&counterValue))[i] = recDataBuff[3 + i];
    }
    counterValue = CFSwapInt32LittleToHost(counterValue);  // Convert to host byte order
    
    // Update counter variable (only if counter value has changed)
    if (counter->getValue().getInteger() != counterValue) {
        counter->setValue(long(counterValue));
    }
    
    return 0;
    
}

bool LabJackU6Device::ljU6WriteStrobedWord(HANDLE Handle, unsigned int inWord) {
    
    uint8 outEioBits = inWord & 0xff;
    uint8 outCioBits = (inWord & 0xf00) >> 8;
    
    uint8 sendDataBuff[29];
    uint8 Errorcode, ErrorFrame;
    
    if (inWord > 0xfff) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "error writing strobed word; value is larger than 12 bits (nothing written)");
        return false;
    }
    
    
    
    sendDataBuff[0] = 27;           // PortStateWrite, 7 bytes total
    sendDataBuff[1] = 0x00;         // FIO: don't update
    sendDataBuff[2] = 0xff;         // EIO: update
    sendDataBuff[3] = 0x0f;         // CIO: update
    sendDataBuff[4] = 0x00;         // FIO: data
    sendDataBuff[5] = outEioBits;   // EIO: data
    sendDataBuff[6] = outCioBits;   // CIO: data
    
    sendDataBuff[7] = 5;            // WaitShort
    sendDataBuff[8] = 1;            // Time(*128us)
    
    sendDataBuff[9]  = 11;          // BitStateWrite
    sendDataBuff[10] = 7 | 0x80;    // first 4 bits: port # (FIO7); last bit, state
    
    sendDataBuff[11] = 5;           // WaitShort
    sendDataBuff[12] = 1;           // Time(*128us)
    
    sendDataBuff[13] = 27;          // PortStateWrite, 7 bytes total
    sendDataBuff[14] = 0x80;    //0x80  // FIO: update pin 7
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
    sendDataBuff[28] = 1;           // Time(*128us)
    
    
    if(ehFeedback(Handle, sendDataBuff, sizeof(sendDataBuff), &Errorcode, &ErrorFrame, NULL, 0) < 0) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "bug: ehFeedback error, see stdout");  // note we will get a more informative error on stdout
        return false;
    }
    if(Errorcode) {
        merror(M_IODEVICE_MESSAGE_DOMAIN, "ehFeedback: error with command, errorcode was %d", Errorcode);
        return false;
    }
    
    return true;
}


END_NAMESPACE_MW
*/
