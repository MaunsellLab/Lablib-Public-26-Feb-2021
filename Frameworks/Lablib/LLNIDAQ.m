//
//  LLNIDAQ.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQ.h"
#import "LLNIDAQAnalogOutput.h"

@implementation LLNIDAQ

- (id)analogOutputTask;
{
    LLNIDAQAnalogOutput *analogOutputTask;

    analogOutputTask = [[[LLNIDAQAnalogOutput alloc] initWithNIDAQ:self] autorelease];
    return analogOutputTask;
}

- (NIDAQTask)createTaskWithName:(NSString*)taskName;
{
    NSMutableDictionary *dict;
    NIDAQTask theTask;

    dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                @"DAQmxCreateTask", @"command", taskName, @"taskName", nil];
//    dict = [socket writeDictionary:dict];
    theTask = (NIDAQTask)[[dict valueForKey:@"task"] pointerValue];
    return theTask;
 }

- (void)dealloc;
{
    [socket release];
    [super dealloc];
}

- (id)init;
{
    if ([super init] != nil) {
        socket = [[LLSockets alloc] init];
    }
    return self;
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





