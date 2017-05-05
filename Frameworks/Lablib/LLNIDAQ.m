//
//  LLNIDAQ.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

// I don't know.  Maybe the AO output and AO input are the way to go.  Could have them speak to the socket directly,
// using a socket lock.  That would be pretty safe.

#import "LLNIDAQ.h"
#import "LLNIDAQTask.h"

#define kActiveChannels         2
#define kAnalogOutChannel0Name  @"ao0"
#define kAnalogOutChannel1Name  @"ao1"
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
    [analogOutput createVoltageChannelWithName:kAnalogOutChannel0Name maxVolts:10 minVolts:-10];
    [analogOutput createVoltageChannelWithName:kAnalogOutChannel1Name maxVolts:10 minVolts:-10];
    digitalOutput = [[LLNIDAQTask alloc] initWithSocket:socket];
    [digitalOutput createDOTask];
    [digitalOutput createChannelWithName:kDigitalOutChannelName];
    [self setPowerToMinimum];
    [self closeShutter];
}

- (id)initWithSocket:(LLSockets *)theSocket;
{
    NSString *fileName;

    if ((self = [super init]) != nil) {
        fileName = [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey];
        [self doInitWithSocket:theSocket calibrationFileName:fileName];
    }
    return self;
}

- (id)initWithSocket:(LLSockets *)theSocket calibrationFile:(NSString *)calibrationFileName;
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
    NSString *channelNames[kAOChannels] = {kAnalogOutChannel0Name, kAnalogOutChannel1Name};

    if (calibrator[channel] != nil) {
        [calibrator[channel] release];
    }
    calibrator[channel] = [[LLPowerCalibrator alloc] initFromFile:url];
    if ([calibrator[channel] calibrated]) {
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

- (id)pairedPulsesWithPulse0MW:(float)pulse0MW duration0MS:(long)dur0MS pulse1MW:(float)pulse1MW
                   duration1MS:(long)dur1MS delay1MS:(long)delay1MS digitalTrigger:(BOOL)digitalTrigger;
{
    long sample;
    long numSamples, pulse0Samples, delay1Samples, pulse1Samples;
    Float64 off0V, off1V, pulse0V, pulse1V, *train, *pTrain;

    pulse0Samples = dur0MS * kSamplesPerMS;
    pulse1Samples = dur1MS * kSamplesPerMS;
    delay1Samples = delay1MS * kSamplesPerMS;
    numSamples = MAX(pulse0Samples, pulse1Samples + delay1Samples) + kActiveChannels;
    train = malloc(numSamples * sizeof(Float64) * kActiveChannels);
    pulse0V = [calibrator[0] voltageForMW:pulse0MW];
    pulse1V = [calibrator[1] voltageForMW:pulse1MW];
    off0V = [calibrator[0] voltageForMW:[calibrator[0] minimumMW]];
    off1V = [calibrator[1] voltageForMW:[calibrator[1] minimumMW]];

    for (sample = 0, pTrain = train; sample < numSamples - kActiveChannels; sample++) {
        *pTrain++ = (sample < delay1Samples) ? off1V : ((sample < delay1Samples + pulse1Samples) ? pulse1V : off1V);
        *pTrain++ = (sample < pulse0Samples) ? pulse0V : off0V;
    }
    for ( ; sample < numSamples; sample++) {
        *pTrain++ = off1V;
        *pTrain++ = off0V;
    }

    [analogOutput stop];                                    // task must be stopped before re-arming
    [analogOutput alterState:@"unreserve"];                // must unreserve in case it was never started
    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:numSamples];
    if (digitalTrigger) {
        [analogOutput configureTriggerDigitalEdgeStart:kTriggerChanName edge:@"rising"];
    }
    else {
        [analogOutput configureTriggerDisableStart];
    }
    [analogOutput writeSamples:train numSamples:(numSamples * kActiveChannels) autoStart:NO timeoutS:-1];
    if (digitalTrigger) {
        [analogOutput start];
    }
    return(analogOutput);
}

- (void)setChannel:(long)channel powerTo:(float)powerMW;
{
    long sample;
    long numSamples = kMinSamples * kActiveChannels;       // NIDAQ requires 2 samples per channel minimum
    Float64 outputV[kMinSamples * kActiveChannels];        // min 2 samples per channel
    
    for (sample  = 0; sample < numSamples; sample++) {
        outputV[sample] = [calibrator[channel] calibrated] ? [calibrator[channel] voltageForMW:powerMW] : powerMW;
    }

    [analogOutput configureTimingSampleClockWithRate:kOutputRateHz mode:@"finite" samplesPerChannel:kMinSamples];
    [analogOutput configureTriggerDisableStart];            // start output on write/start
    [analogOutput writeSamples:outputV numSamples:kMinSamples * kActiveChannels autoStart:YES timeoutS:-1];
    [analogOutput waitUntilDone:kWaitTimeS];
    [analogOutput stop];
    [analogOutput alterState:@"unreserve"];
}

- (void)setPowerToMinimum;
{
    long c;

    for (c = 0; c < kAOChannels; c++) {
        [self setPowerToMinimumForChannel:c];
    }
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
