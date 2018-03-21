//
//  LLNIDAQ.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
// NB: The behavior of NIDAQ autostart, start and triggers is a little counterintuitive.  Start and autostart
// apply to the task.  Nothing will ever happen with input or output until a task has been started with either a start
// (a programmatic call to the start() function) or an autostart, which starts the task when the setup is made.
// The start or autostart will begin the output/acqusition immediately, UNLESS a digital or analog trigger has been
// specified.  In that case, the trigger will begin the output/acquisiton.  Note that a digital or analog trigger will
// do nothing if the task has not been started by a start() or autostart.

#import "LLNIDAQ.h"
#import "LLNIDAQTask.h"

#define kAOChannel0Name         @"ao0"
#define kAOChannel1Name         @"ao1"
#define kDigitalOutChannelName  @"port0/line2"
#define kMinSamples             2
#define kOutputRateHz           10000
#define kSamplesPerMS           (kOutputRateHz / 1000)
#define kLLSocketsRigIDKey      @"LLSocketsRigID"
#define kTriggerChanName        @"PFI0"
#define kWaitTimeS              0.100

@implementation LLNIDAQ

- (void)closeShutter;
{
    [self outputDigitalValue:0];
}

- (void)dealloc;
{
    long index;

    [deviceLock lock];
    for (index = 0; index < kAOChannels; index++) {
        [self setPowerToMinimumForChannel:index];
    }
    [analogOutput stop];
    [analogOutput deleteTask];
    [analogOutput release];
    [self closeShutter];
    [digitalOutput deleteTask];
    [digitalOutput release];
    [socket release];
    for (index = 0; index < kAOChannels; index++) {
        [calibrator[index] release];
    }
    [deviceLock unlock];
    [deviceLock release];

    [super dealloc];
}

- (id)init;
{
    return [self initWithSocket:nil];
}

- (id)initWithSocket:(LLSockets *)theSocket;
{
    NSString *fileName = [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey];

    return [self initWithSocket:theSocket calibrationFileName:fileName];
}

- (instancetype)initWithSocket:(LLSockets *)theSocket calibrationFileName:(NSString *)fileName;
{
    if ((self = [super init]) != nil) {
        deviceLock = [[NSLock alloc] init];
        socket = theSocket;
        [socket retain];
        analogOutput = [[LLNIDAQTask alloc] initWithSocket:socket];
        [analogOutput createAOTask];
        [analogOutput createVoltageChannelWithName:kAOChannel0Name maxVolts:10 minVolts:-10];
        [analogOutput createVoltageChannelWithName:kAOChannel1Name maxVolts:10 minVolts:-10];
        digitalOutput = [[LLNIDAQTask alloc] initWithSocket:socket];
        [digitalOutput createDOTask];
        [digitalOutput createChannelWithName:kDigitalOutChannelName];
        [self setPowerToMinimum];
        [self closeShutter];
    }
    return self;
}

- (BOOL)isDone:(LLNIDAQTask *)theTask;
{
    if ([theTask isKindOfClass:[LLNIDAQTask class]]) {
        return([theTask isDone]);
    }
    else {
        return NO;
    }
}

- (BOOL)loadCalibration:(short)channel url:(NSURL *)url;
{
    NSString *channelNames[kAOChannels] = {kAOChannel0Name, kAOChannel1Name};

    if (calibrator[channel] != nil) {
        [calibrator[channel] release];
    }
    calibrator[channel] = [[LLPowerCalibrator alloc] initFromFile:url];
    if (calibrator[channel].calibrated) {
        [analogOutput setMaxVolts:[calibrator[channel] maximumV] minVolts:[calibrator[channel] minimumV]
                      forChannelName:channelNames[channel]];
        return YES;
    }
    else {
        return NO;
    }
}

- (Float64 *)makeRamp:(Float64 *)pT durMS:(long)durMS startV:(float)startV endV:(float)endV;
{
    long sample, numSamples;

    numSamples = durMS * kSamplesPerMS;
    if (numSamples < 1) {                                           // don't do anything on non-intervals
        return pT;
    }
    for (sample = 0; sample < numSamples - 1; sample++) {           // n-1 to ensure final value is exactly endV
        *pT = startV + (sample + 1) * (endV - startV) / numSamples; // n+1 to ensure we start ramp with first value
        pT += kAOChannels;                                          // hop over samples for other channels
    }
    *pT = endV;                                                     // end exactly on endV
    pT += kAOChannels;
    return pT;
}

- (float)maximumMWForChannel:(long)channel;
{
    return [calibrator[channel] maximumMW];
}

- (float)minimumMWForChannel:(long)channel;
{
    return [calibrator[channel] minimumMW];
}

- (void)openShutter;
{
    [self outputDigitalValue:1];
}

- (void)outputDigitalValue:(short)value;
{
    Float64 outArray[3] = {value, value, value};

    [digitalOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:sizeof(outArray)];
    [digitalOutput writeSamples:outArray numSamples:sizeof(outArray) / sizeof(Float64) autoStart:YES timeoutS:0.250];
    [digitalOutput waitUntilDone:kWaitTimeS];
    [digitalOutput stop];
    [digitalOutput alterState:@"unreserve"];
}

- (id)pairedPulsesWithChannel0:(LLPulseProfile *)pulse0 channel1:(LLPulseProfile *)pulse1 autoStart:(BOOL)autoStart
                digitalTrigger:(BOOL)digitalTrigger;
{
    long sample, pulse, numChannelSamples, numTrainSamples;
    Float64 startV, preV, postV, pulseV, endV, *train, *pT, lastValue;
    LLPulseProfile *theProfile;
    LLPulseProfile *profiles[kAOChannels] = {pulse0, pulse1};

    if (pulse0 == nil) {
        return nil;
    }
    if (pulse1 == nil) {
        numChannelSamples = pulse0.totalDurationMS * kSamplesPerMS;
    }
    else {
        numChannelSamples = MAX(pulse0.totalDurationMS, pulse1.totalDurationMS) * kSamplesPerMS;
    }
    if (numChannelSamples <= 0) {                       // don't do anything if the total time is zero
        return nil;
    }
    numChannelSamples += 100;                                       // leave room for integer rounding errors
    numTrainSamples = numChannelSamples * kAOChannels;              // we're configured for kAOChannels AO channels
    train = malloc(numTrainSamples * sizeof(Float64));              // extra for rounding errors
    for (pulse = 0; pulse < kAOChannels; pulse++) {
        pT = &train[pulse];                                         // offset by AO channel count
        theProfile = profiles[pulse];
        // If the profile is nil, just zero out the samples for this channel
        if (theProfile == nil) {
            for (sample = 0; sample < numChannelSamples; sample++) {
                *pT = 0;
                pT += kAOChannels;                                  // hop over samples for other channels
            }
            continue;
        }
        // If the pre ramp and duration are zero, pass the start power through to the pulse
        if (theProfile.preRampMS == 0 && theProfile.preDurationMS == 0) {
            theProfile.prePowerMW = theProfile.startPowerMW;
        }
        // If the pulse ramp and duration are zero, pass the delay power through to the post ramp
        if (theProfile.pulseRampMS == 0 && theProfile.pulseDurationMS == 0) {
            theProfile.pulsePowerMW = theProfile.prePowerMW;
        }
        startV = [calibrator[pulse] voltageForMW:theProfile.startPowerMW];
        preV = [calibrator[pulse] voltageForMW:theProfile.prePowerMW];
        pulseV = [calibrator[pulse] voltageForMW:theProfile.pulsePowerMW];
        postV = [calibrator[pulse] voltageForMW:theProfile.postPowerMW];
        endV = [calibrator[pulse] voltageForMW:theProfile.endPowerMW];
        // Add each of the components of the profile in succession
        pT = [self makeRamp:pT durMS:(long)theProfile.preDelayMS startV:(float)startV endV:(float)startV];
        pT = [self makeRamp:pT durMS:(long)theProfile.preRampMS startV:(float)startV endV:(float)preV];
        pT = [self makeRamp:pT durMS:(long)theProfile.preDurationMS startV:(float)preV endV:(float)preV];
        pT = [self makeRamp:pT durMS:(long)theProfile.pulseRampMS startV:(float)preV endV:(float)pulseV];
        pT = [self makeRamp:pT durMS:(long)theProfile.pulseDurationMS startV:(float)pulseV endV:(float)pulseV];
        pT = [self makeRamp:pT durMS:(long)theProfile.postRampMS startV:(float)pulseV endV:(float)postV];
        pT = [self makeRamp:pT durMS:(long)theProfile.postDurationMS startV:(float)postV endV:(float)postV];
        pT = [self makeRamp:pT durMS:(long)theProfile.endRampMS startV:(float)postV endV:(float)endV];
//        // If the post ramp and duration are zero, force the end voltage to endV
//        if (theProfile.postDurationMS == 0 && theProfile.postRampMS == 0) {
//            *pT = endV;
//            pT += kAOChannels;
//        }
        lastValue = pT[-kAOChannels];
        while (pT < train + numTrainSamples) {
            *pT = lastValue;
            pT += kAOChannels;
        }
    }
    numTrainSamples = pT - train - 1;                           // trim to the actual number of samples
    [analogOutput doTrain:train numSamples:numTrainSamples outputRateHz:kOutputRateHz digitalTrigger:digitalTrigger
       triggerChannelName:kTriggerChanName autoStart:autoStart waitTimeS:0.0];
    free(train);
    return(analogOutput);
}

- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
{
    return [self pairedPulsesWithPulse0MW:pulse0MW duration0MS:dur0MS delay0MS:0 pulse1MW:pulse1MW
      duration1MS:dur1MS delay1MS:0 autoStart:autoStart digitalTrigger:digitalTrigger];
}

- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS delay1MS:(long)delay1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
{
    return [self pairedPulsesWithPulse0MW:pulse0MW duration0MS:dur0MS delay0MS:0 pulse1MW:pulse1MW
                              duration1MS:dur1MS delay1MS:delay1MS autoStart:autoStart digitalTrigger:digitalTrigger];
}

// only positive delays are allowed

- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS delay0MS:(long)delay0MS pulse1MW:(float)pulse1MW
       duration1MS:(long)dur1MS delay1MS:(long)delay1MS autoStart:(BOOL)autoStart digitalTrigger:(BOOL)digitalTrigger;
{
    long sample;
    long numChannelSamples, numTrainSamples, pulse0Samples, delay0Samples, delay1Samples, pulse1Samples;
    Float64 off0V, off1V, pulse0V, pulse1V, *train, *pT;

    pulse0Samples = dur0MS * kSamplesPerMS;
    pulse1Samples = dur1MS * kSamplesPerMS;
    delay0Samples = delay0MS * kSamplesPerMS;
    delay1Samples = delay1MS * kSamplesPerMS;
    numChannelSamples = MAX(pulse0Samples + delay0Samples, pulse1Samples + delay1Samples) + 1;
    numTrainSamples = numChannelSamples * kAOChannels;
    train = malloc(numTrainSamples * sizeof(Float64));
    pulse0V = [calibrator[0] voltageForMW:pulse0MW];
    pulse1V = [calibrator[1] voltageForMW:pulse1MW];
    off0V = [calibrator[0] voltageForMW:[calibrator[0] minimumMW]];
    off1V = [calibrator[1] voltageForMW:[calibrator[1] minimumMW]];

    for (sample = 0, pT = train; sample < numChannelSamples - 1; sample++) {
        *pT++ = (sample < delay0Samples) ? off0V : ((sample < delay0Samples + pulse0Samples) ? pulse0V : off0V);
        *pT++ = (sample < delay1Samples) ? off1V : ((sample < delay1Samples + pulse1Samples) ? pulse1V : off1V);
    }
    for ( ; sample < numChannelSamples; sample++) {
        *pT++ = off0V;
        *pT++ = off1V;
    }
    [analogOutput doTrain:train numSamples:numTrainSamples outputRateHz:kOutputRateHz digitalTrigger:digitalTrigger
                triggerChannelName:kTriggerChanName autoStart:autoStart waitTimeS:0.0];
    return(analogOutput);
}

- (void)setChannel:(long)channel powerTo:(float)powerMW;
{
    long sample;
    long numSamples = kMinSamples * kAOChannels;       // NIDAQ requires 2 samples per channel minimum
    Float64 outputV[kMinSamples * kAOChannels];        // min 2 samples per channel
    
    for (sample  = 0; sample < numSamples; sample++) {
        outputV[sample] = calibrator[channel].calibrated ? [calibrator[channel] voltageForMW:powerMW] : powerMW;
    }
    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:kMinSamples];
    [analogOutput configureTriggerDisableStart];            // start output on write/start
    [analogOutput writeSamples:outputV numSamples:kMinSamples * kAOChannels autoStart:YES timeoutS:-1];
    [analogOutput waitUntilDone:kWaitTimeS];
    [analogOutput stop];
    [analogOutput alterState:@"unreserve"];
}

- (void)setPowerToMinimum;
{
    long sample;
    Float64 off0V, off1V, *pT, train[kMinSamples * kAOChannels];        // min 2 samples per channel

    off0V = [calibrator[0] voltageForMW:[calibrator[0] minimumMW]];
    off1V = [calibrator[1] voltageForMW:[calibrator[1] minimumMW]];
    for (sample = 0, pT = train; sample < kMinSamples; sample++) {
        *pT++ = off1V;
        *pT++ = off0V;
    }
    [analogOutput doTrain:train numSamples:kMinSamples * kAOChannels outputRateHz:kOutputRateHz
           digitalTrigger:NO triggerChannelName:kTriggerChanName autoStart:YES waitTimeS:kWaitTimeS];
}

- (void)setPowerToMinimumForChannel:(long)channel;
{
    [self setChannel:channel powerTo:[calibrator[channel] minimumMW]];
}

- (void)showWindow:(id)sender;
{
    [socket showWindow:sender];
}

- (BOOL)start:(LLNIDAQTask *)theTask;
{
    if ([theTask isKindOfClass:[LLNIDAQTask class]]) {
        return([theTask start]);
    }
    else {
        return NO;
    }
}

- (BOOL)stop:(LLNIDAQTask *)theTask;
{
    BOOL result;

    if ([theTask isKindOfClass:[LLNIDAQTask class]]) {
        result = [theTask stop];
        [theTask alterState:@"unreserve"];
        return(result);
    }
    else {
        return NO;
    }
}

@end
