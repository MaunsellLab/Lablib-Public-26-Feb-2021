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

//#define kAOChannels             2
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

- (void)doInitWithSocket:(LLSockets *)theSocket calibrationFileName:(NSString *)fileName;
{
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

- (instancetype)initWithSocket:(LLSockets *)theSocket;
{
    NSString *fileName;

    if ((self = [super init]) != nil) {
        fileName = [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey];
        [self doInitWithSocket:theSocket calibrationFileName:fileName];
    }
    return self;
}

- (instancetype)initWithSocket:(LLSockets *)theSocket calibrationFile:(NSString *)calibrationFileName;
{
    if ((self = [super init]) != nil) {
        [self doInitWithSocket:theSocket calibrationFileName:calibrationFileName];
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
    long sample, pulse, activeChannels, numChannelSamples, numTrainSamples;
    float limitMS;
    Float64 preV, postV, offV, pulseV, *train, *pTrain;
    LLPulseProfile *profiles[kAOChannels] = {pulse0, pulse1};

    if (pulse0 == nil) {
        return nil;
    }
    if (pulse1 == nil) {
        activeChannels = 1;
        numChannelSamples = pulse0.totalDurationMS + 1;
    }
    else {
        activeChannels = 2;
        numChannelSamples = MAX(pulse0.totalDurationMS, pulse1.totalDurationMS) + 1;
    }
    numTrainSamples = numChannelSamples * activeChannels;
    train = malloc(numTrainSamples * sizeof(Float64));
    for (pulse = 0; pulse < activeChannels; pulse++) {
        pulseV = [calibrator[pulse] voltageForMW:profiles[pulse].pulsePowerMW];
        preV = [calibrator[pulse] voltageForMW:profiles[pulse].prePowerMW];
        postV = [calibrator[pulse] voltageForMW:profiles[pulse].postPowerMW];
        offV = [calibrator[pulse] voltageForMW:profiles[pulse].offPowerMW];
        sample = 0;
        pTrain = &train[pulse];
        limitMS = profiles[pulse].preDelayMS;
        while (sample < limitMS * kSamplesPerMS) {      // delay before pre period
            *pTrain = offV;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].preRampMS;
        while (sample < limitMS * kSamplesPerMS) {      // ramp from off to pre period
            *pTrain = offV + (preV - offV) / profiles[pulse].preRampMS * kSamplesPerMS;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].preDurationMS;
        while (sample < limitMS * kSamplesPerMS) {      // pre period
            *pTrain = preV;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].pulseRampMS;
        while (sample < limitMS * kSamplesPerMS) {      // ramp from pre to pulse
            *pTrain = preV + (pulseV - preV) / profiles[pulse].pulseRampMS * kSamplesPerMS;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].pulseDurationMS;
        while (sample < limitMS * kSamplesPerMS) {      // pulse
            *pTrain = pulseV;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].postRampMS;
        while (sample < limitMS * kSamplesPerMS) {      // ramp from pulse to post
            *pTrain = pulseV - (pulseV - postV) / profiles[pulse].postRampMS * kSamplesPerMS;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].postDurationMS;
        while (sample < limitMS * kSamplesPerMS) {      // post period
            *pTrain = postV;
            pTrain += activeChannels;
        }
        limitMS += profiles[pulse].offRampMS;
        while (sample < limitMS * kSamplesPerMS) {      // ramp from post to off period
            *pTrain = postV - (postV - offV) / profiles[pulse].offRampMS * kSamplesPerMS;
            pTrain += activeChannels;
        }
        while (sample < numChannelSamples) {            // off period
            *pTrain = offV;
            pTrain += activeChannels;
        }
    }
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
    Float64 off0V, off1V, pulse0V, pulse1V, *train, *pTrain;

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

    for (sample = 0, pTrain = train; sample < numChannelSamples - 1; sample++) {
        *pTrain++ = (sample < delay0Samples) ? off0V : ((sample < delay0Samples + pulse0Samples) ? pulse0V : off0V);
        *pTrain++ = (sample < delay1Samples) ? off1V : ((sample < delay1Samples + pulse1Samples) ? pulse1V : off1V);
    }
    for ( ; sample < numChannelSamples; sample++) {
        *pTrain++ = off0V;
        *pTrain++ = off1V;
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
    Float64 off0V, off1V, *pTrain, train[kMinSamples * kAOChannels];        // min 2 samples per channel

    off0V = [calibrator[0] voltageForMW:[calibrator[0] minimumMW]];
    off1V = [calibrator[1] voltageForMW:[calibrator[1] minimumMW]];
    for (sample = 0, pTrain = train; sample < kMinSamples; sample++) {
        *pTrain++ = off1V;
        *pTrain++ = off0V;
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
