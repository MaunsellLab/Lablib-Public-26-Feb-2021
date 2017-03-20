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

#define kOutputRateHz           100000
#define kPowerChannelName       @"ao0"
#define kSamplesPerMS           (kOutputRateHz / 1000)
#define kShutterChannelName     @"port0/line"
#define kShutterDelayMS         4
#define kTrialShutterChanName   @"port0/line2"
#define kTriggerChanName        @"PFI0"

#define kLLSocketsRigIDKey          @"LLSocketsRigID"

@implementation LLNIDAQ

- (void)closeShutter;
{
    [self outputDigitalValue:0 channelName:[NSString stringWithFormat:@"%@%@", deviceName, kShutterChannelName]];
}

- (void)createChannel:(NIDAQTask)taskHandle channelName:(NSString*)channelName;
{
    NSMutableDictionary *dict;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            @"DAQmxCreateChannel", @"command", [NSValue valueWithPointer:taskHandle], @"taskHandle",
            channelName, @"channelName", nil];
    dict = [socket writeDictionary:dict];
    //int32 DAQmxCreateAOVoltageChan (TaskHandle taskHandle, const char physicalChannel[], const char nameToAssignToChannel[], float64 minVal, float64 maxVal, int32 units, const char customScaleName[]);
}

- (void)dealloc;
{
    [deviceLock lock];
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
        [self closeShutter];
    }
    return self;
}

- (void)outputDigitalValue:(short)value channelName:(NSString *)channelName;
{
//    Float64 outArray[3] = {value, value, value};
    LLNIDAQAnalogOutput *analogOutput;

    analogOutput = [[LLNIDAQAnalogOutput alloc] initWithSocket:socket];
    [analogOutput createChannelWithName:channelName];
//    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(outArray)];
//    [analogOutput writeArray:outArray length:sizeof(outArray) autoStart:NO];
//    [analogOutput start];
//    usleep(100000);
//    [analogOutput waitUntilDone];
//    [analogOutput stop];
    [analogOutput deleteTask];
    [analogOutput release];
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





