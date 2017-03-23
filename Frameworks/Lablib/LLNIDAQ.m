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

#define kActiveChannels         2
#define kAnalogOutChannel0Name  @"ao0"
#define kAnalogOutChannel1Name  @"ao1"
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
        [analogOutput createVoltageChannelWithName:kAnalogOutChannel0Name];
        [analogOutput createVoltageChannelWithName:kAnalogOutChannel1Name];
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

- (void)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
                                                duration1MS:(long)dur1MS delay1MS:(long)delay1MS;
{
    long sample;
    long numSamples, pulse0Samples, delay1Samples, pulse1Samples;
    Float64 offV, pulse0V, pulse1V, *train;

    pulse0Samples = dur0MS * kOutputRateHz / 1000.0;
    pulse1Samples = dur1MS * kOutputRateHz / 1000.0;
    delay1Samples = dur1MS * kOutputRateHz / 1000.0;
    numSamples = MAX(pulse0Samples, pulse1Samples + delay1Samples) + kActiveChannels;
    train = malloc(numSamples * sizeof(Float64));
    pulse0V = [calibrator voltageForMW:pulse0MW];
    pulse1V = [calibrator voltageForMW:pulse1MW];
    offV = [calibrator voltageForMW:[calibrator minimumMW]];
    for (sample = 0; sample < numSamples - kActiveChannels; sample += kActiveChannels) {
        train[sample] = (sample < pulse0Samples) ? pulse0V : offV;
        train[sample + 1] = (sample < delay1Samples) ? offV : ((sample < delay1Samples + pulse1Samples) ? pulse1V : offV);
    }
    for ( ; sample < numSamples; sample++) {
        train[sample] = offV;
    }

    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(numSamples)];
    [analogOutput configureTriggerDigitalEdgeStart:kTriggerChanName edge:@"rising"];
    [analogOutput writeArray:train length:numSamples autoStart:NO timeoutS:-1];
    [analogOutput start];
}

- (void)setPowerTo:(float)powerMW;
{
    Float64 outputV[2] = {powerMW, powerMW};                // ???? Need to handle calibration

    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(outputV)];
    [analogOutput configureTriggerDisableStart];            // start output on write/start
    [analogOutput writeArray:outputV length:sizeof(outputV) autoStart:YES timeoutS:-1];
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
 The following example demonstrates how to create an analog output task that generates voltage to given channel of the NI card:

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





