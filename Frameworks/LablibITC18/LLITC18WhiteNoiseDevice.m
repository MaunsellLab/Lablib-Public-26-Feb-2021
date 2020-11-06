//
//  LLITC18WhiteNoiseDevice.m
//  Lablib
//
//  Created by John Maunsell on Aug 29 2008
//  Copyright (c) 2008-2020. All rights reserved.
//

#import <LablibITC18/LLITC18WhiteNoiseDevice.h>
#import <LablibITC18/LLITC18DataDevice.h>
#import <Lablib/LLSystemUtil.h>
#import <unistd.h>

#define kDriftTimeLimitMS   0.010
#define kDriftFractionLimit 0.001
#define kGarbageLength      3                    // Invalid entries at the start of sequence
#define kITC18TicksPerMS    800L                // Time base for ITC18
#define kITC18TickTimeUS    1.25
#define kMaxDAChannels      8
#define kOverSample         4

static short ADInstructions[] = {ITC18_INPUT_AD0, ITC18_INPUT_AD1, ITC18_INPUT_AD2,  ITC18_INPUT_AD3};
static short DAInstructions[] = {ITC18_OUTPUT_DA0, ITC18_OUTPUT_DA1, ITC18_OUTPUT_DA2,  ITC18_OUTPUT_DA3};

@interface LLITC18WhiteNoiseDevice()

@property long bufferLength;                // instructions in stimulus reading and writing
@property long channels;                    // number of active channels
@property float sampleSetPeriodUS;
@property (retain) LLITC18DataDevice *dataDevice; // LLITCDataDevice from which we inherited control
@property (retain) NSLock *deviceLock;
@property unsigned short digitalOutputWord;
@property long FIFOSize;
@property Ptr itc;
@property BOOL itcExists;
@property (nonatomic) BOOL samplesReady;
@property BOOL ownsITC;

@end

@implementation LLITC18WhiteNoiseDevice

// Close the ITC18.  

- (void)close;
{
    if (self.itcExists && self.itc != nil) {
        [self.deviceLock lock];
        if (self.ownsITC) {
            ITC18_Close(self.itc);
            free(self.itc);
        }
        else {
            ITC18_StopAndInitialize(self.itc, YES, YES); // critical to return ITC18 in a clean state
            self.dataDevice.itc = self.itc;                   // restore dataDevice.itc to allow access to ITC18
        }
        self.itc = nil;                                  // clear our pointer, not any LLITC18DataDevice pointer
        [self.deviceLock unlock];
    }
}

- (void)dealloc;
{
    long index;

    [self close];
    for (index = 0; index < self.channels; index++) {
        [inputSamples[index] release];
    }
    [self.deviceLock release];
    [super dealloc];
}

- (void)digitalOutputBits:(unsigned long)bits;
{
    if (self.itcExists) {
        self.digitalOutputWord = bits;
        ITC18_WriteAuxiliaryDigitalOutput(self.itc, self.digitalOutputWord);
    }
}

- (void)digitalOutputBitsOff:(unsigned short)bits {

    if (self.itcExists) {
        self.digitalOutputWord &= ~bits;
        ITC18_WriteAuxiliaryDigitalOutput(self.itc, self.digitalOutputWord);
    }
}

- (void)digitalOutputBitsOn:(unsigned short)bits {

    if (self.itcExists) {
        self.digitalOutputWord |= bits;
        ITC18_WriteAuxiliaryDigitalOutput(self.itc, self.digitalOutputWord);
    }
}

- (void)doInitializationWithDevice:(long)numDevice;
{
    long index;
    int ranges[ITC18_AD_CHANNELS];

    self.itc = nil;
    _deviceLock = [[NSLock alloc] init];
    if ([self open:numDevice]) {
        for (index = 0; index < ITC18_AD_CHANNELS; index++) {    // Set AD voltage range
            ranges[index] = ITC18_AD_RANGE_10V;
        }
        for (index = 0; index < ITC18_NUMBEROFDACOUTPUTS; index++) {    // init in case sampleData is called unprepared
            inputSamples[index] = nil;
        }
        [_deviceLock lock];
        ITC18_SetRange(self.itc, ranges);
        ITC18_SetDigitalInputMode(self.itc, YES, NO);                // latch and do not invert
        _FIFOSize = ITC18_GetFIFOSize(self.itc);
        [_deviceLock unlock];
    }
    _ownsITC = YES;                                               // we are solely in control of ITC-18
}

// Get the number of entries ready to be read from the FIFO.  We assume that the device has been locked before
// this method is called

- (int)getAvailable;
{
    int available, overflow;
    
    ITC18_GetFIFOReadAvailableOverflow(self.itc, &available, &overflow);
    if (overflow != 0) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                informativeText:@"Fatal error: FIFO overflow"];
        exit(0);
    }
    return available;
}

- (BOOL)hasITC18;
{
    return self.itcExists;
}

// Initialization tests for the existence of the ITC, and initializes it if it is there.
// The ITC initialization sets thd AD voltage, and also set the digital input to latch.
// ITC-18 latching is not the same thing as edge triggering.  A short pulse will produce a positive
// value at the next read, but a steady level can also produce a series of positive values.

- (id)init;
{
    if ((self = [super init]) != nil) {
        [self doInitializationWithDevice:0];
    }
    return self;
}

- (id)initWithDevice:(long)numDevice;
{
    if ((self = [super init]) != nil) {
        [self doInitializationWithDevice:numDevice];
    }
    return self;
}

// In some circumstances, a task plugin will want to take over an ITC18 that is already been loaded as a
// LLDataDevice plugin for use with other task plugins.  To do that, we temporarally seize the ITC-18 by
// getting a pointer to the device (itc), and setting the LLDataDevice pointer to nil.  Setting the LLDataDevice
// pointer to nil insures that it will not take any action on the ITC18 while we control it.  We restore the
// LLDataDevice pointer in our -close method.

- (id)initWithDataDevice:(LLDataDevice *)theDataDevice;
{
    if ((self = [super init]) != nil) {
        if (theDataDevice != nil) {
            _deviceLock = [[NSLock alloc] init];
            if (![theDataDevice.name hasPrefix:@"ITC-18"]) {
                self.itc = nil;
            }
            else {
                _dataDevice = (LLITC18DataDevice *)theDataDevice;   // save for -close
                _itc = _dataDevice.itc;
                _dataDevice.itc = nil;                              // clear dataDevice.itc to stop it from using ITC18
                _itcExists = (_itc != nil);
                if (_itcExists) {
                    [_deviceLock lock];
                    _FIFOSize = ITC18_GetFIFOSize(_itc);
                    [_deviceLock unlock];
                }
            }
            _ownsITC = FALSE;
        }
    }
    return self;
}

// Open and initialize the ITC18

- (BOOL)open:(long)deviceNum;
{
    long code;
    long interfaceCodes[] = {0x0, USB18_CL};

    [self.deviceLock lock];
    if (self.itc == nil) {                        // current opened?
        if ((self.itc = malloc(ITC18_GetStructureSize())) == nil) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                                     informativeText:@"Failed to allocate pLocal memory"];
            exit(0);
        }
    }
    else {
        ITC18_Close(self.itc);
    }

    for (code = 0, self.itcExists = NO; code < sizeof(interfaceCodes) / sizeof(long); code++) {
        NSLog(@"LLITC18DataDevice: attempting to initialize device %ld using code %ld",
                    deviceNum, deviceNum | interfaceCodes[code]);
        if (ITC18_Open(self.itc, (int)(deviceNum | interfaceCodes[code])) != noErr) {
            continue;                                    // failed, try another code
        }

    // the ITC has opened, now initialize it

        if (ITC18_Initialize(self.itc, ITC18_STANDARD) != noErr) {
            ITC18_Close(self.itc);                            // failed, close to try again
        }
        else {
            self.itcExists = YES;                        // successful initialization
            break;
        }
    }
    if (self.itcExists) {
        NSLog(@"LLITC18WhiteNoiseDevice: succeeded initialize device %ld using code %ld",
                    deviceNum, deviceNum | interfaceCodes[code]);
        ITC18_SetDigitalInputMode(self.itc, YES, NO);                // latch and do not invert
        ITC18_SetExternalTriggerMode(self.itc, NO, NO);                // no external trigger
    }
    else {
        free(self.itc);
        self.itc = nil;
    }
    [self.deviceLock unlock];
    return self.itcExists;
}

// The instructions are made based on the parameters in pNoise.  However, if the stimulus extends beyond
// maxDurMS, the power from that point on is forced to zero

- (BOOL)makeInstructionsFromNoiseData:(WhiteNoiseData *)pNoise channels:(long)activeChannels maxDurMS:(long)maxDurMS;
{
    long index, sampleSetTimeMS;
    short sampleValues[kMaxChannels + 1];
    float sampleV, sampleP, v[2], mw[2];
    int writeAvailable;
    int ITCInstructions[kMaxChannels + 1];
    BOOL pulseState;
    
    self.FIFOSize = 100000;
//
    // We take common values from the first entry, on the assumption that others have been checked and are the same
    
    self.channels = MIN(activeChannels, ITC18_NUMBEROFDACOUTPUTS);
    long instructsPerSampleSet = self.channels + 1;                            // channels plus a digital word
    long gatePorchUS = (pNoise->doGate) ? pNoise->gatePorchMS * 1000.0 : 0;
    long durationUS = pNoise->durationMS * 1000.0;
    
// First determine the DASample period.  We require the entire stimulus to fit within the ITC-18 FIFO.
// We divide down to allow for enough DA (channels) and digital (1) samples, plus a 2x safety factor
    
    long ticksPerInstruction = ITC18_MINIMUM_TICKS;
    while ((durationUS + 2 * gatePorchUS) / (kITC18TickTimeUS * ticksPerInstruction) > 
                                            self.FIFOSize / (instructsPerSampleSet * 2)) {
        ticksPerInstruction++;
    }
    if (ticksPerInstruction > ITC18_MAXIMUM_TICKS) {
        return NO;
    }
    
// Precompute some important values
    
    float instructPeriodUS = ticksPerInstruction * kITC18TickTimeUS;
    self.sampleSetPeriodUS = instructsPerSampleSet * instructPeriodUS;
    long sampleSetsPerMS = 1000.0 / self.sampleSetPeriodUS;
    long numPorchSampleSets = gatePorchUS / self.sampleSetPeriodUS;     // DA samples in each gate porch
    long numStimSampleSets = durationUS / self.sampleSetPeriodUS;       // DA samples in train (without porches)
    long numTrainSamples = (durationUS + 2 * gatePorchUS) / instructPeriodUS;
    double vRangeFract = pNoise->pulseAmpV / pNoise->fullRangeV;
    self.bufferLength = MAX(numTrainSamples, instructsPerSampleSet);
    long numPulses = pNoise->durationMS / pNoise->pulseWidthMS;
    short gateBits = ((pNoise->doGate) ? (0x1 << pNoise->gateBit) : 0);
    short gateAndPulseBits = gateBits | ((pNoise->doPulseMarkers) ? (0x1 << pNoise->pulseMarkerBit) : 0);
    v[0] = mw[0] = 0.0;
    v[1] = pNoise->pulseAmpV;
    mw[1] = pNoise->pulseAmpMW;

// Create the arrays that will hold the times and amplitudes of the pulses, and also an array for the entire output
// sequence (trainValues). It is created zeroed.  If there is a gating signal,
// we load that into the digital output values. bufferLength is always at least as long as instructsPerSampleSet.
    
    long rampEndSampleSet = pNoise->rampDurMS * sampleSetsPerMS;
    long pulsePhaseMS = rand() % (long)pNoise->pulseWidthMS;    // random pulse phase (to nearest ms)

//        NSLog(@"%ld: time: %ld voltage %.2f power %.2f", pulseIndex, timesMS[pulseIndex], voltages[pulseIndex], powersMW[pulseIndex]);
    self.timesMS = [[NSMutableData alloc] initWithLength:numPulses * sizeof(int32_t)];
    int32_t *tPtr = self.timesMS.mutableBytes;
    self.voltages = [[NSMutableData alloc] initWithLength:numPulses * sizeof(float)];
    float *vPtr = self.voltages.mutableBytes;
    self.powersMW = [[NSMutableData alloc] initWithLength:numPulses * sizeof(float)];
    float *pPtr = self.powersMW.mutableBytes;
    NSMutableData *trainValues = [[NSMutableData alloc] initWithLength:self.bufferLength * sizeof(short)];
    short *sPtr = trainValues.mutableBytes;
    long pulseIndex = -1;                                                           // force a new pulse entring loop
    for (long sampleSet = 0; sampleSet < numStimSampleSets; sampleSet++) {
        sampleSetTimeMS = (sampleSet * self.sampleSetPeriodUS / 1000.0);
        if ((sampleSetTimeMS + pulsePhaseMS) / pNoise->pulseWidthMS > pulseIndex) { // start of a new pulse
            pulseIndex++;
            *tPtr++ = (int32_t)(pulseIndex * pNoise->pulseWidthMS + pulsePhaseMS);  // save start time of new pulse
            if (maxDurMS < 0 || sampleSetTimeMS < maxDurMS) {
                pulseState = rand() % 2;                                            // select random state
            }
            else {
                pulseState = 0;                                                     // no stim past maxDurMS;
            }
            sampleP = mw[pulseState];                                               // save power of new pulse
            sampleV = v[pulseState];                                                // save voltage of new pulse
            if (pulseState && sampleSet < rampEndSampleSet) {                       // if we're in the ramp, rescale
                float factor = MIN((float)sampleSet / rampEndSampleSet, 1.0);
                sampleP *= factor;
                sampleV *= factor;
            }
            *pPtr++ = sampleP;
            *vPtr++ = sampleV;
            for (index = 0; index < self.channels; index++) {                       // create new values for train
                sampleValues[index] = sampleV * vRangeFract * 0x7fff;  // might be positive or negative
            }
            sampleValues[index] = gateAndPulseBits;                   // digital output word (pulseBits on even pulses)
            sampleValues[index] = (pulseIndex % 2) ? gateBits : gateAndPulseBits;
            NSLog(@"%3ld: time: %4ld voltage %.2f power %.2f", pulseIndex, pulseIndex * pNoise->pulseWidthMS + pulsePhaseMS,
                  sampleV, sampleP);
        }
        for (index = 0; index < self.channels + 1; index++) {                  // load values for one sample set
            *sPtr++ = sampleValues[index];
        }
    }

// If there the gate has a front and back porch, add those to the output values
    
    if (numPorchSampleSets > 0) {
        long porchBufferLength = numPorchSampleSets * instructsPerSampleSet;
        NSMutableData *porchValues = [[NSMutableData alloc]
                                      initWithLength:porchBufferLength * sizeof(short)];
        sPtr = porchValues.mutableBytes;
        short scaledOffV = 0.0 * vRangeFract * 0x7fff;
        for (index = 0; index < numPorchSampleSets; index++) {
            for (long c = 0; c < self.channels; c++) {
                *sPtr++ = scaledOffV;                       // analog values are off values during porch
            }
            *sPtr++ = gateBits;                             // load the gate values in the digital word
        }
        [trainValues appendData:porchValues];               // stim train and back porch
        [porchValues appendData:trainValues];               // front porch, stim train, and back porch
        [trainValues release];                              // release unneeded data
        trainValues = porchValues;                          // make trainValues point to the whole set
        self.bufferLength += 2 * porchBufferLength;     // tally the buffer length with both porches
    }
    
// Make the last digital output word in the buffer close the gate (0x00)
    
    [trainValues resetBytesInRange:NSMakeRange((self.bufferLength - 1) * sizeof(short), sizeof(short))];

    
    if (!self.itcExists) {
        return NO;
    }
    

    
    
// Set up the ITC for the stimulus train.  Do everything except the start.  For every DA output,
// we also do a read on the corresponding AD channel
    
    for (index = 0; index < self.channels; index++) {
        ITCInstructions[index] = 
            ADInstructions[pNoise[index].DAChannel] | DAInstructions[pNoise[index].DAChannel] |
                        ITC18_INPUT_UPDATE | ITC18_OUTPUT_UPDATE;
    } 
    ITCInstructions[index] = ITC18_OUTPUT_DIGITAL1 | ITC18_INPUT_SKIP | ITC18_OUTPUT_UPDATE;
    [self.deviceLock lock];
    ITC18_SetSequence(self.itc, (int)(self.channels + 1), ITCInstructions);
    ITC18_StopAndInitialize(self.itc, YES, YES);
    ITC18_GetFIFOWriteAvailable(self.itc, &writeAvailable);
    if (writeAvailable < numStimSampleSets) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                informativeText:@"An ITC18 Laboratory Interface card was found, but the write buffer was full."];
        [trainValues release];
        return NO;
    }
    int result = ITC18_WriteFIFO(self.itc, (int)self.bufferLength, (short *)trainValues.bytes);
    [trainValues release];
    if (result != noErr) { 
        NSLog(@"Error ITC18_WriteFIFO, result: %d", result);
        return NO;
    }
    ITC18_SetSamplingInterval(self.itc, (int)ticksPerInstruction, NO);
    self.samplesReady = NO;
    [self.deviceLock unlock];
    return YES;
}

- (BOOL)outputDigitalEvent:(long)event withData:(long)data;
{
    if (self.itc == nil) {
        return NO;
    }
    [self.deviceLock lock];
    [self digitalOutputBits:(event | 0x8000)];
    [self digitalOutputBits:(data & 0x7fff)];
    [self.deviceLock unlock];
    return YES;
}

// Read the AD samples and put them into inputSamples.  The host app can track when they are ready using
// samplesReady.  If the host doesn't pick up the data, they will be discarded when the next stimulus cycle runs.

- (void)readData;
{
    short index, *samples, *pSamples, *channelSamples[ITC18_NUMBEROFDACOUTPUTS];
    long sets, set;
    int available;

    @autoreleasepool {
        sets = self.bufferLength / (self.channels + 1);                                        // number of sample sets in stim
        samples = malloc(sizeof(short) * self.bufferLength);
        for (index = 0; index < self.channels; index++) {
            channelSamples[index] = malloc(sizeof(short) * sets);
        }

    // When a sequence is started, the first three entries in the FIFO are garbage.  They should be thrown out.

        while ((available = [self getAvailable]) < kGarbageLength + 1) {
            usleep(1000);
        }
        [self.deviceLock lock];            // Wait here for the lock, then check time again
        ITC18_ReadFIFO(self.itc, kGarbageLength, samples);
        [self.deviceLock unlock];

    // Wait for the stimulus to be over.

        while ((available = [self getAvailable]) < self.bufferLength) {
            usleep(10000);
        }

    // When all the samples are available, read them and unpack them

        [self.deviceLock lock];            // Wait here for the lock, then check time again
        ITC18_ReadFIFO(self.itc, (int)self.bufferLength, samples);                            // read all available sets
        [self.deviceLock unlock];
        for (set = 0; set < sets; set++) {                                    // process each set
            pSamples = &samples[(self.channels + 1) * set];                        // point to start of a set
            for (index = 0; index < self.channels; index++) {                    // for every channel
                channelSamples[index][set] = *pSamples++;
            }
        }
        for (index = 0; index < self.channels; index++) {
            [inputSamples[index] release];                                  // release samples from previous stim cycle
            inputSamples[index] = [[NSData dataWithBytes:channelSamples[index] length:(sets * sizeof(short))] retain];
        }
        free(samples);
        for (index = 0; index < self.channels; index++) {
            free(channelSamples[index]);
        }
        self.samplesReady = YES;                                                 // flag that the input is all read in
    }
}

- (NSData **)sampleData;
{
    if (!self.itcExists || !self.samplesReady) {       // no device is present or samples aren't all read yet
        return nil;
    }
    else {
        self.samplesReady = NO;
        return inputSamples;
    }
}

- (float)samplePeriodUS;
{
    return self.sampleSetPeriodUS;
}

// Report whether it is safe to call sampleData

- (BOOL)samplesReady;
{
    return (self.samplesReady || !self.itcExists);
}
/* 
 Get new stimulation parameter data and load the instruction sequence in the ITC-18.  The array argument may 
 contain parameter descriptions for up to 8 different channels. In the current configuration, all channels
 have synchronous pulses (all monophasic, all synchronous, same frequency).  Only the number of
 channels and their amplitudes can vary.

 We create a buffer in which alternate words are DA values and digital output words (to gate the train and mark
 the pulses). We load the entire stimulus into the buffer, so that no servicing is needed.
 
 If a single channel is being used, it can be simpler to use setNoiseParameters.
 */

- (BOOL)setNoiseArray:(NSArray *)array;
{
    WhiteNoiseData noiseData[kMaxDAChannels];
    NSValue *value;
    
    if (!self.itcExists || (array.count == 0)) {
        return YES;
    }

// Check that the entries are within limits, then unload the data
    
    if (array.count > ITC18_NUMBEROFDACOUTPUTS) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                                 informativeText: @"Too many channels requested.  Ignoring request."];
        return NO;
    }
    for (long index = 0; index < array.count; index++) {
        value = array[index];
        [value getValue:&noiseData[index]];
        if (index > 0) {
            if (noiseData[index].doPulseMarkers != noiseData[0].doPulseMarkers ||
                        noiseData[index].doGate != noiseData[0].doGate ||
                        noiseData[index].durationMS != noiseData[0].durationMS ||
                        noiseData[index].gateBit != noiseData[0].gateBit ||
                        noiseData[index].pulseMarkerBit != noiseData[0].pulseMarkerBit ||
                        noiseData[index].pulseWidthMS != noiseData[0].pulseWidthMS ||
                        noiseData[index].fullRangeV != noiseData[0].fullRangeV) {
                [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice:setNoiseArray:"
                            informativeText: @"Incompatible values requested on different DA channels."];
                return NO;
            }
        }
    } 
    return [self makeInstructionsFromNoiseData:noiseData channels:array.count maxDurMS:-1];
}

/* 
Get new stimulation parameter and load the instruction sequence in the ITC-18.  We create a buffer
in which alternate words are DA values and digital output words (to gate the train and mark the pulses).  
We load the entire stimulus into the buffer, so that no servicing is needed.
*/

- (BOOL)setNoiseParameters:(WhiteNoiseData *)pNoise;
{
    return [self makeInstructionsFromNoiseData:pNoise channels:1 maxDurMS:-1];
}

- (BOOL)setNoiseParameters:(WhiteNoiseData *)pNoise maxDurMS:(long)maxDurMS;
{
    return [self makeInstructionsFromNoiseData:pNoise channels:1 maxDurMS:maxDurMS];
}

- (void)stimulate;
{
    if (!self.itcExists) {
        return;
    }
    [self.deviceLock lock];
    ITC18_Start(self.itc, NO, YES, NO, NO);                // Start with no external trigger, output enabled
    [self.deviceLock unlock];
//    [NSThread detachNewThreadSelector:@selector(readData) toTarget:self withObject:nil];
}

@end
