//
//  LLNIDAQ.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

// I don't know.  Maybe the AO output and AO input are the way to go.  Could have them speak to the socket directly,
// using a socket lock.  That would be pretty safe.

#import "LLNIDAQ.h"
#import "LLNIDAQAnalogOutput.h"

#define kAnalogOutChannelName   @"ao0"
#define kDigitalOutChannelName  @"port0/line2"
#define kOutputRateHz           100000
#define kSamplesPerMS           (kOutputRateHz / 1000)
#define kShutterDelayMS         4
#define kTrialShutterChanName   @"port0/line2"
#define kTriggerChanName        @"PFI0"
#define kWaitTimeS              0.100

#define kLLSocketsRigIDKey          @"LLSocketsRigID"

@implementation LLNIDAQ

- (void)closeShutter;
{
    [self outputDigitalValue:0];
}

- (void)dealloc;
{
    [deviceLock lock];
    [self setPowerToMinimum];
    [analogOutput stop];
    [analogOutput deleteTask];
    [analogOutput release];
    [self closeShutter];
    [digitalOutput deleteTask];
    [digitalOutput release];
    [socket release];
    [deviceLock unlock];
    [deviceLock release];

    [super dealloc];
}

- (id)initWithSocket:(LLSockets *)theSocket;
{
    if ([super init] != nil) {
        deviceLock = [[NSLock alloc] init];
        socket = theSocket;
        [socket retain];
        deviceName = [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey];

        calibrator = [[LLPowerCalibrator alloc] initWithFile:deviceName];

        analogOutput = [[LLNIDAQAnalogOutput alloc] initWithSocket:socket];
        [analogOutput createVoltageChannelWithName:kAnalogOutChannelName];
        [self setPowerToMinimum];

        digitalOutput = [[LLNIDAQDigitalOutput alloc] initWithSocket:socket];
        [digitalOutput createChannelWithName:kDigitalOutChannelName];
        [self closeShutter];
    }
    return self;
}

- (float)maximumMW;
{
    return [calibrator maximumMW];
}

- (float)minimumMW;
{
    return [calibrator minimumMW];
}

- (void)openShutter;
{
    [self outputDigitalValue:1];
}

- (void)outputDigitalValue:(short)value;
{
    Float64 outArray[3] = {value, value, value};

    [digitalOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(outArray)];
    [digitalOutput writeArray:outArray length:sizeof(outArray) autoStart:YES];
    [digitalOutput waitUntilDone:kWaitTimeS];
    [digitalOutput stop];
    [digitalOutput alterState:@"unreserve"];
}

- (void) setPowerTo:(float)powerMW;
{
    Float64 outputV[2] = {powerMW, powerMW};                // ???? Need to handle calibration

    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(outputV)];
    [analogOutput configureTriggerDisableStart];            // start output on write/start
    [analogOutput writeArray:outputV length:sizeof(outputV) autoStart:YES];
    [analogOutput waitUntilDone:kWaitTimeS];
    [analogOutput stop];
}

- (void)setPowerToMinimum;
{
    [self setPowerTo:0.0];
}

- (void)showWindow:(id)sender;
{
    [socket showWindow:sender];
}

@end

/*
Create objects for AnalogOutputTask and DigitalOutputTask
give them the set of functions from below
from nidaqmx import AnalogOutputTask, DigitalOutputTask
task = DigitalOutputTask()
task = AnalogOutputTask()
del task

task.create_channel(channelName)
task.create_voltage_channel('%s/%s' % (self.deviceName, self.powerChanName), min_val=0, max_val=self.powerChanMaxV)
task.configure_timing_sample_clock(rate = 100000.0, sample_mode='finite', samples_per_channel=len(outArr))
task.configure_trigger_digital_edge_start('PFI0', edge='rising')
task.write(outArr, auto_start=0)
task.start()
task.wait_until_done(1)
task.stop()
 
 
 The following example demonstrates how to create an analog output task that generates voltage to given channel of the NI card:

 >>> task = AnalogOutputTask()
 >>> task.create_voltage_channel('Dev1/ao2', min_val=-10.0, max_val=10.0)
 >>> task.configure_timing_sample_clock(rate = 1000.0)
 >>> task.write(data)
 >>> task.start()
 >>> raw_input('Generating voltage continuously. Press Enter to interrupt..')
 >>> task.stop()
 >>> del task
 The generated voltage can be measured as well when connecting the corresponding channels in the NI card:

 >>> from nidaqmx import AnalogInputTask
 >>> import numpy as np
 >>> task = AnalogInputTask()
 >>> task.create_voltage_channel('Dev1/ai16', terminal = 'rse', min_val=-10.0, max_val=10.0)
 >>> task.configure_timing_sample_clock(rate = 1000.0)
 >>> task.start()
 >>> data = task.read(2000, fill_mode='group_by_channel')
 >>> del task
 >>> from pylab import plot, show
 >>> plot (data)
 >>> show ()
 that should plot two sine waves.

 Learning about your NI card and software
 The nidaqmx package allows you to make various queries about the NI card devices as well as software properties. For that, use nidaqmx.System instance as follows:

 >>> from nidaqmx import System
 >>> system = System()
 >>> print 'libnidaqmx version:',system.version
 libnidaqmx version: 8.0
 >>> print 'NI-DAQ devives:',system.devices
 NI-DAQ devives: ['Dev1', 'Dev2']
 >>> dev1 = system.devices[0]
 >>> print dev1.get_product_type()
 PCIe-6259
 >>> print dev1.get_bus()
 PCIe (bus=7, device=0)
 >>> print dev1.get_analog_input_channels()
 ['Dev1/ai0', 'Dev1/ai1', ..., 'Dev1/ai31']

 */





