//
//  LLITC18WhiteNoiseDevice.m
//  Lablib
//
//  Created by John Maunsell on Aug 29 2008
//  Copyright (c) 2008-2020. All rights reserved.
//

#import "LLITC18WhiteNoiseDevice.h"
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

@property long bufferLength;                // instructions in stimulus
@property long channels;                    // number of active channels
@property float DASampleSetPeriodUS;
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

- (BOOL)makeInstructionsFromTrainData:(WhiteNoiseData *)pNoise channels:(long)activeChannels;
{
    short values[kMaxChannels + 1], gateAndPulseBits, gateBits, *sPtr;
    long index, DASampleSetsInTrain, DASampleSetsPerPhase, sampleSetIndex, ticksPerInstruction;
    long gatePorchUS, sampleSetsInPorch, porchBufferLength;
    long pulseCount, DASamplesPerPulse, durationUS, instructionsPerSampleSet, valueIndex;
    int writeAvailable, result;
    float instructionPeriodUS, pulsePeriodUS, rangeFraction[kMaxChannels];
    NSMutableData *trainValues, *pulseValues, *porchValues;
    int ITCInstructions[kMaxChannels + 1];

    if (!self.itcExists) {
        return NO; 
    }
    
// We take common values from the first entry, on the assumption that others have been checked and are the same
    
    self.channels = MIN(activeChannels, ITC18_NUMBEROFDACOUTPUTS);
    instructionsPerSampleSet = self.channels + 1;                            // channels plus a digital word
    gatePorchUS = (pNoise->doGate) ? pNoise->gatePorchMS * 1000.0 : 0;
    durationUS = pNoise->durationMS * 1000.0;
    
// First determine the DASample period.  We require the entire stimulus to fit within the ITC-18 FIFO.
// We divide down to allow for enough DA (channels) and digital (1) samples, plus a 2x safety factor
    
    ticksPerInstruction = ITC18_MINIMUM_TICKS;
    while ((durationUS + 2 * gatePorchUS) / (kITC18TickTimeUS * ticksPerInstruction) > 
                                            self.FIFOSize / (instructionsPerSampleSet * 2)) {
        ticksPerInstruction++;
    }
    if (ticksPerInstruction > ITC18_MAXIMUM_TICKS) {
        return NO;
    }
    
// Precompute some important values
    
    instructionPeriodUS = ticksPerInstruction * kITC18TickTimeUS;
    self.DASampleSetPeriodUS = instructionPeriodUS * instructionsPerSampleSet;
    DASampleSetsPerPhase = round(pNoise->pulseWidthMS * 1000.0 / self.DASampleSetPeriodUS);
    sampleSetsInPorch = gatePorchUS / self.DASampleSetPeriodUS;        // DA samples in the gate porch
    DASampleSetsInTrain = durationUS / self.DASampleSetPeriodUS;        // DA samples in entire train
    self.bufferLength = MAX(DASampleSetsInTrain * instructionsPerSampleSet, instructionsPerSampleSet);
    pulsePeriodUS = (pNoise->frequencyHZ > 0) ? 1.0 / pNoise->frequencyHZ * 1000000.0 : 0;
    gateBits = ((pNoise->doGate) ? (0x1 << pNoise->gateBit) : 0);
    gateAndPulseBits = gateBits | ((pNoise->doPulseMarkers) ? (0x1 << pNoise->pulseMarkerBit) : 0);
    
// Create and load an array with output values that make up one pulse (DA plus digital).  These will be inserted
// into trainValues repeatedly in the next section.
    
    DASamplesPerPulse = DASampleSetsPerPhase;
    if (DASamplesPerPulse > 0) {
        for (index = 0; index < self.channels; index++) {
            rangeFraction[index] = pNoise[index].pulseAmpV / pNoise[index].fullRangeV;
        }
        pulseValues = [[NSMutableData alloc] initWithLength:DASamplesPerPulse *
                                                   instructionsPerSampleSet * sizeof(short)];
        for (index = 0; index < self.channels; index++) {
            values[index] = rangeFraction[index] * 0x7fff;        // amplitude might be positive or negative
        }
        values[index] = gateAndPulseBits;                        // digital output word
        for (sampleSetIndex = 0; sampleSetIndex < DASampleSetsPerPhase; sampleSetIndex++) {
            [pulseValues replaceBytesInRange:NSMakeRange(sampleSetIndex * sizeof(short) * instructionsPerSampleSet, 
                        sizeof(short) * instructionsPerSampleSet) withBytes:&values];
        }
    }
    
// Create an array for the entire output sequence (trainValues).  It is created zeroed.  If there is a gating signal,
// we add that to the digital output values.  bufferLength is always at least as long as instructionsPerSampleSet.
    
    trainValues = [[NSMutableData alloc] initWithLength:self.bufferLength * sizeof(short)];
    if (gateBits > 0) {
        sPtr = trainValues.mutableBytes;
        for (index = 0; index < DASampleSetsInTrain; index++) {
            sPtr += self.channels;                            // skip over analog values
            *(sPtr)++ = gateBits;                        // set the gate bits
        }
    }
    
// Modify the output sequence by inserting the pulses.  If the stimulation frequency is zero
// (pulsePeriodUS set to 0), we load no pulses.  If the duration is shorter than one pulse, nothing
// is loaded.  If the pulseWidth is zero, nothing is loaded.
    
    if ((pulsePeriodUS > 0) && (DASampleSetsPerPhase > 0)) {
        for (pulseCount = 0; ; pulseCount++) {
            sampleSetIndex = pulseCount * pulsePeriodUS / self.DASampleSetPeriodUS;
            valueIndex = sampleSetIndex * instructionsPerSampleSet;
            if (valueIndex + DASamplesPerPulse + 1 >= self.bufferLength) {
                break;
            }
            [trainValues replaceBytesInRange:NSMakeRange(valueIndex * sizeof(short), 
                        pulseValues.length) withBytes:pulseValues.bytes];
        }
    }
    [pulseValues release];
    
// If there the gate has a front and back porch, add the porches to the output values
    
    if (sampleSetsInPorch > 0) {
        porchBufferLength = sampleSetsInPorch * instructionsPerSampleSet;
        porchValues = [[NSMutableData alloc] initWithLength:(porchBufferLength * sizeof(short))];
        sPtr = porchValues.mutableBytes;
        for (index = 0; index < sampleSetsInPorch; index++) {
            sPtr += self.channels;                            // skip over analog values
            *(sPtr)++ = gateBits;                        // set the gate bits
        }
        [trainValues appendData:porchValues];            // stim train, back porch
        [porchValues appendData:trainValues];            // front porch, stim train, back porch
        [trainValues release];                           // release unneeded data
        trainValues = porchValues;                       // make trainValues point to the whole set
        self.bufferLength += 2 * porchBufferLength;           // tally the buffer length with both porches
    }
    
// Make the last digital output word in the buffer close the gate (0x00)
    
    [trainValues resetBytesInRange:NSMakeRange((self.bufferLength - 1) * sizeof(short), sizeof(short))];

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
    if (writeAvailable < DASampleSetsInTrain) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                informativeText:@"An ITC18 Laboratory Interface card was found, but the write buffer was full."];
        [trainValues release];
        return NO;
    }
    result = ITC18_WriteFIFO(self.itc, (int)self.bufferLength, (short *)trainValues.bytes);
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

- (BOOL)makeStimUsingProfile:(LLNoiseProfile *)profile meanPowerMW:(float)meanPowerMW;
{
    short values[kMaxChannels + 1], gateAndPulseBits, gateBits, *sPtr;
    long index, DASampleSetsInTrain, DASampleSetsPerPhase, sampleSetIndex, ticksPerInstruction;
    long gatePorchUS, sampleSetsInPorch, porchBufferLength;
    long pulseCount, DASamplesPerPulse, durationUS, instructionsPerSampleSet, valueIndex;
    int writeAvailable, result;
    float instructionPeriodUS, pulsePeriodUS, rangeFraction[kMaxChannels];
    NSMutableData *trainValues, *pulseValues, *porchValues;
    int ITCInstructions[kMaxChannels + 1];

    if (!self.itcExists) {
        return NO;
    }
    self.channels = 1;                                                  // Configured for one channel

    // We take common values from the first entry, on the assumption that others have been checked and are the same
    
    instructionsPerSampleSet = self.channels + 1;                            // channels plus a digital word
    gatePorchUS = (pNoise->doGate) ? pNoise->gatePorchMS * 1000.0 : 0;
    durationUS = pNoise->durationMS * 1000.0;
    
// First determine the DASample period.  We require the entire stimulus to fit within the ITC-18 FIFO.
// We divide down to allow for enough DA (channels) and digital (1) samples, plus a 2x safety factor
    
    ticksPerInstruction = ITC18_MINIMUM_TICKS;
    while ((durationUS + 2 * gatePorchUS) / (kITC18TickTimeUS * ticksPerInstruction) >
                                            self.FIFOSize / (instructionsPerSampleSet * 2)) {
        ticksPerInstruction++;
    }
    if (ticksPerInstruction > ITC18_MAXIMUM_TICKS) {
        return NO;
    }
    
// Precompute some important values
    
    instructionPeriodUS = ticksPerInstruction * kITC18TickTimeUS;
    self.DASampleSetPeriodUS = instructionPeriodUS * instructionsPerSampleSet;
    DASampleSetsPerPhase = round(pNoise->pulseWidthMS * 1000.0 / self.DASampleSetPeriodUS);
    sampleSetsInPorch = gatePorchUS / self.DASampleSetPeriodUS;        // DA samples in the gate porch
    DASampleSetsInTrain = durationUS / self.DASampleSetPeriodUS;        // DA samples in entire train
    self.bufferLength = MAX(DASampleSetsInTrain * instructionsPerSampleSet, instructionsPerSampleSet);
    pulsePeriodUS = (pNoise->frequencyHZ > 0) ? 1.0 / pNoise->frequencyHZ * 1000000.0 : 0;
    gateBits = ((pNoise->doGate) ? (0x1 << pNoise->gateBit) : 0);
    gateAndPulseBits = gateBits | ((pNoise->doPulseMarkers) ? (0x1 << pNoise->pulseMarkerBit) : 0);
    
// Create and load an array with output values that make up one pulse (DA plus digital).  These will be inserted
// into trainValues repeatedly in the next section.
    
    DASamplesPerPulse = DASampleSetsPerPhase;
    if (DASamplesPerPulse > 0) {
        for (index = 0; index < self.channels; index++) {
            rangeFraction[index] = pNoise[index].pulseAmpV / pNoise[index].fullRangeV;
        }
        pulseValues = [[NSMutableData alloc] initWithLength:DASamplesPerPulse *
                                                   instructionsPerSampleSet * sizeof(short)];
        for (index = 0; index < self.channels; index++) {
            values[index] = rangeFraction[index] * 0x7fff;        // amplitude might be positive or negative
        }
        values[index] = gateAndPulseBits;                        // digital output word
        for (sampleSetIndex = 0; sampleSetIndex < DASampleSetsPerPhase; sampleSetIndex++) {
            [pulseValues replaceBytesInRange:NSMakeRange(sampleSetIndex * sizeof(short) * instructionsPerSampleSet,
                        sizeof(short) * instructionsPerSampleSet) withBytes:&values];
        }
    }
    
// Create an array for the entire output sequence (trainValues).  It is created zeroed.  If there is a gating signal,
// we add that to the digital output values.  bufferLength is always at least as long as instructionsPerSampleSet.
    
    trainValues = [[NSMutableData alloc] initWithLength:self.bufferLength * sizeof(short)];
    if (gateBits > 0) {
        sPtr = trainValues.mutableBytes;
        for (index = 0; index < DASampleSetsInTrain; index++) {
            sPtr += self.channels;                            // skip over analog values
            *(sPtr)++ = gateBits;                        // set the gate bits
        }
    }
    
// Modify the output sequence by inserting the pulses.  If the stimulation frequency is zero
// (pulsePeriodUS set to 0), we load no pulses.  If the duration is shorter than one pulse, nothing
// is loaded.  If the pulseWidth is zero, nothing is loaded.
    
    if ((pulsePeriodUS > 0) && (DASampleSetsPerPhase > 0)) {
        for (pulseCount = 0; ; pulseCount++) {
            sampleSetIndex = pulseCount * pulsePeriodUS / self.DASampleSetPeriodUS;
            valueIndex = sampleSetIndex * instructionsPerSampleSet;
            if (valueIndex + DASamplesPerPulse + 1 >= self.bufferLength) {
                break;
            }
            [trainValues replaceBytesInRange:NSMakeRange(valueIndex * sizeof(short),
                        pulseValues.length) withBytes:pulseValues.bytes];
        }
    }
    [pulseValues release];
    
// If there the gate has a front and back porch, add the porches to the output values
    
    if (sampleSetsInPorch > 0) {
        porchBufferLength = sampleSetsInPorch * instructionsPerSampleSet;
        porchValues = [[NSMutableData alloc] initWithLength:(porchBufferLength * sizeof(short))];
        sPtr = porchValues.mutableBytes;
        for (index = 0; index < sampleSetsInPorch; index++) {
            sPtr += self.channels;                            // skip over analog values
            *(sPtr)++ = gateBits;                        // set the gate bits
        }
        [trainValues appendData:porchValues];            // stim train, back porch
        [porchValues appendData:trainValues];            // front porch, stim train, back porch
        [trainValues release];                           // release unneeded data
        trainValues = porchValues;                       // make trainValues point to the whole set
        self.bufferLength += 2 * porchBufferLength;           // tally the buffer length with both porches
    }
    
// Make the last digital output word in the buffer close the gate (0x00)
    
    [trainValues resetBytesInRange:NSMakeRange((self.bufferLength - 1) * sizeof(short), sizeof(short))];

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
    if (writeAvailable < DASampleSetsInTrain) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                informativeText:@"An ITC18 Laboratory Interface card was found, but the write buffer was full."];
        [trainValues release];
        return NO;
    }
    result = ITC18_WriteFIFO(self.itc, (int)self.bufferLength, (short *)trainValues.bytes);
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
    if (!self.itcExists) {                                // return nil data when no device is present
        return nil;
//        return inputSamples;
    }
    if (!self.samplesReady) {                            // or the samples aren't all read in yet
        return nil;
    }
    else {
        self.samplesReady = NO;
        return inputSamples;
    }
}

- (float)samplePeriodUS;
{
    return self.DASampleSetPeriodUS;
}

// Report whether it is safe to call sampleData

- (BOOL)samplesReady;
{
    return (self.samplesReady || !self.itcExists);
}
/* 
 Get new stimulation parameter data and load the instruction sequence in the ITC-18.  The array argument may 
 contain parameter descriptions for up to 8 different channels.  In the current configuration, all channels
 have synchronous pulses (all biphasic or all monophasic, all synchronous, same frequency).  Only the number of
 channels and their amplitudes can vary.

 We create a buffer
 in which alternate words are DA values and digital output words (to gate the train and mark the pulses).  
 We load the entire stimulus into the buffer, so that no servicing is needed.
 */

- (BOOL)setNoiseArray:(NSArray *)array;
{
    BOOL doPulseMarkers, doGate;
    long index, DAchannels, durationMS, gateBit, pulseMarkerBit, pulseWidthMS;
    float frequencyHZ, fullRangeV;
    WhiteNoiseData noiseData[kMaxDAChannels];
    NSValue *value;
    
    DAchannels = array.count;  
    if (!self.itcExists || (DAchannels == 0)) {
        return YES;
    }
    
// Check that the entries are within limits, then unload the data
    
    if (DAchannels > ITC18_NUMBEROFDACOUTPUTS) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                                 informativeText: @"Too many channels requested.  Ignoring request."];
        return NO;
    }
    for (index = 0; index < DAchannels; index++) {
        value = array[index];
        [value getValue:&noiseData[index]];
        if (index == 0) {
            doPulseMarkers = noiseData[index].doPulseMarkers;
            doGate = noiseData[index].doGate;
            durationMS = noiseData[index].durationMS;
            gateBit = noiseData[index].gateBit;
            pulseMarkerBit = noiseData[index].pulseMarkerBit;
            pulseWidthMS = noiseData[index].pulseWidthMS;
            frequencyHZ = noiseData[index].frequencyHZ;
            fullRangeV = noiseData[index].fullRangeV;
        }
        else if (doPulseMarkers != noiseData[index].doPulseMarkers|| doGate != noiseData[index].doGate ||
                    durationMS != noiseData[index].durationMS || gateBit != noiseData[index].gateBit ||
                    pulseMarkerBit != noiseData[index].pulseMarkerBit || pulseWidthMS != noiseData[index].pulseWidthMS
                    || frequencyHZ != noiseData[index].frequencyHZ || fullRangeV != noiseData[index].fullRangeV) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18WhiteNoiseDevice"
                                     informativeText: @"Incompatible values requested on different DA channels."];
            return NO;
        }            
    } 
    return [self makeInstructionsFromTrainData:noiseData channels:DAchannels];
}

/* 
Get new stimulation parameter and load the instruction sequence in the ITC-18.  We create a buffer
in which alternate words are DA values and digital output words (to gate the train and mark the pulses).  
We load the entire stimulus into the buffer, so that no servicing is needed.
*/

- (BOOL)setNoiseParameters:(WhiteNoiseData *)pNoise;
{
    return [self makeInstructionsFromTrainData:pNoise channels:1];
}

- (void)stimulate;
{
    if (!self.itcExists) {
        return;
    }
    [self.deviceLock lock];
    ITC18_Start(self.itc, NO, YES, NO, NO);                // Start with no external trigger, output enabled
    [self.deviceLock unlock];
    [NSThread detachNewThreadSelector:@selector(readData) toTarget:self withObject:nil];
}
@end
