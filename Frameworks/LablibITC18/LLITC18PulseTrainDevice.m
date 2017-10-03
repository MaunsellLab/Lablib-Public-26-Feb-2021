//
//  LLITC18PulseTrainDevice.m 
//  Lablib
//
//  Created by John Maunsell on Aug 29 2008
//  Copyright (c) 2008. All rights reserved. 
//

#import "LLITC18PulseTrainDevice.h"
#import <LablibITC18/LLITC18DataDevice.h>
#import <Lablib/LLSystemUtil.h>
#import <ITC/ITC18.h>
#import <unistd.h>

#define kDriftTimeLimitMS	0.010
#define kDriftFractionLimit	0.001
#define kGarbageLength		3					// Invalid entries at the start of sequence
#define	kITC18TicksPerMS	800L				// Time base for ITC18
#define kITC18TickTimeUS	1.25
#define kMaxDAChannels		8
#define kOverSample			4

static short ADInstructions[] = {ITC18_INPUT_AD0, ITC18_INPUT_AD1, ITC18_INPUT_AD2,  ITC18_INPUT_AD3};
static short DAInstructions[] = {ITC18_OUTPUT_DA0, ITC18_OUTPUT_DA1, ITC18_OUTPUT_DA2,  ITC18_OUTPUT_DA3};

@implementation LLITC18PulseTrainDevice

// Close the ITC18.  

- (void)close;
{
	if (itcExists) {
		[deviceLock lock];
        if (weOwnITC) {
            ITC18_Close(itc);
            free(itc);
        }
		itc = nil;
		[deviceLock unlock];
	}
}

- (void)dealloc;
{
	long index;

	[self close];
	for (index = 0; index < channels; index++) {
		[inputSamples[index] release];
	}
	[deviceLock release];
	[super dealloc];
}

- (void)digitalOutputBits:(unsigned long)bits;
{
	if (itcExists) {
		digitalOutputWord = bits;
		ITC18_WriteAuxiliaryDigitalOutput(itc, digitalOutputWord);
	}
}

- (void)digitalOutputBitsOff:(unsigned short)bits {

	if (itcExists) {
		digitalOutputWord &= ~bits;
		ITC18_WriteAuxiliaryDigitalOutput(itc, digitalOutputWord);
	}
}

- (void)digitalOutputBitsOn:(unsigned short)bits {

	if (itcExists) {
		digitalOutputWord |= bits;
		ITC18_WriteAuxiliaryDigitalOutput(itc, digitalOutputWord);
	}
}

- (void)doInitializationWithDevice:(long)numDevice;
{
    long index;
    int ranges[ITC18_AD_CHANNELS];

    itc = nil;
    deviceLock = [[NSLock alloc] init];
    if ([self open:numDevice]) {
        for (index = 0; index < ITC18_AD_CHANNELS; index++) {    // Set AD voltage range
            ranges[index] = ITC18_AD_RANGE_10V;
        }
        for (index = 0; index < ITC18_NUMBEROFDACOUTPUTS; index++) {    // init in case sampleData is called unprepared
            inputSamples[index] = nil;
        }
        [deviceLock lock];
        ITC18_SetRange(itc, ranges);
        ITC18_SetDigitalInputMode(itc, YES, NO);                // latch and do not invert
        FIFOSize = ITC18_GetFIFOSize(itc);
        [deviceLock unlock];
    }
    weOwnITC = YES;                                               // we are solely in control of ITC-18
}

// Get the number of entries ready to be read from the FIFO.  We assume that the device has been locked before
// this method is called

- (int)getAvailable;
{
	int available, overflow;
	
	ITC18_GetFIFOReadAvailableOverflow(itc, &available, &overflow);
	if (overflow != 0) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18PulseTrainDevice"
                informativeText:@"Fatal error: FIFO overflow"];
		exit(0);
	}
	return available;
}

- (BOOL)hasITC18;
{
	return itcExists;
}

- (id)init;
{
	if ((self = [super init]) != nil) {
		[self doInitializationWithDevice:0];
	}
	return self;
}

// Initialization tests for the existence of the ITC, and initializes it if it is there.
// The ITC initialization sets thd AD voltage, and also set the digital input to latch.
// ITC-18 latching is not the same thing as edge triggering.  A short pulse will produce a positive 
// value at the next read, but a steady level can also produce a series of positive values.

- (id)initWithDevice:(long)numDevice;
{
	if ((self = [super init]) != nil) {
		[self doInitializationWithDevice:numDevice];
	}
	return self;
}

- (id)initWithDataDevice:(LLDataDevice *)dataDevice;
{
    if ((self = [super init]) != nil && dataDevice != nil) {
        deviceLock = [[NSLock alloc] init];
        if (![[dataDevice name] hasPrefix:@"ITC-18"]) {
            itc = nil;
        }
        else {
            itc = [(LLITC18DataDevice *)dataDevice itc];
            itcExists = (itc != nil);
            [deviceLock lock];
            FIFOSize = ITC18_GetFIFOSize(itc);
            [deviceLock unlock];
        }
    }
    weOwnITC = FALSE;
    return self;
}
// Open and initialize the ITC18

- (BOOL)open:(long)deviceNum;
{
	long code;
	long interfaceCodes[] = {0x0, USB18_CL};

    [deviceLock lock];
	if (itc == nil) {						// current opened?
		if ((itc = malloc(ITC18_GetStructureSize())) == nil) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18PulseTrainDevice"
                                     informativeText:@"Failed to allocate pLocal memory"];
			exit(0);
		}
	}
	else {
        ITC18_Close(itc);
	}

	for (code = 0, itcExists = NO; code < sizeof(interfaceCodes) / sizeof(long); code++) {
        NSLog(@"LLITC18DataDevice: attempting to initialize device %ld using code %ld",
					deviceNum, deviceNum | interfaceCodes[code]);
		if (ITC18_Open(itc, (int)(deviceNum | interfaceCodes[code])) != noErr) {
			continue;									// failed, try another code
		}

	// the ITC has opened, now initialize it

		if (ITC18_Initialize(itc, ITC18_STANDARD) != noErr) {
			ITC18_Close(itc);							// failed, close to try again
		}
		else {
			itcExists = YES;						// successful initialization
			break;
		}
	}
	if (itcExists) {
		NSLog(@"LLITC18PulseTrainDevice: succeeded initialize device %ld using code %ld",
					deviceNum, deviceNum | interfaceCodes[code]);
		ITC18_SetDigitalInputMode(itc, YES, NO);				// latch and do not invert
		ITC18_SetExternalTriggerMode(itc, NO, NO);				// no external trigger
	}
	else {
		free(itc);
		itc = nil;
	}
	[deviceLock unlock];
	return itcExists;
}

- (BOOL)makeInstructionsFromTrainData:(PulseTrainData *)pTrain channels:(long)activeChannels;
{
	short values[kMaxChannels + 1], gateAndPulseBits, gateBits, *sPtr;
	long index, DASampleSetsInTrain, DASampleSetsPerPhase, sampleSetIndex, ticksPerInstruction;
	long gatePorchUS, sampleSetsInPorch, porchBufferLength;
	long pulseCount, DASamplesPerPulse, durationUS, instructionsPerSampleSet, valueIndex;
	int writeAvailable, result;
	float instructionPeriodUS, pulsePeriodUS, rangeFraction[kMaxChannels];
	NSMutableData *trainValues, *pulseValues, *porchValues;
	int ITCInstructions[kMaxChannels + 1];

	if (!itcExists) { 
		return NO; 
	}
	
// We take common values from the first entry, on the assumption that others have been checked and are the same
	
	channels = MIN(activeChannels, ITC18_NUMBEROFDACOUTPUTS);
	instructionsPerSampleSet = channels + 1;                            // channels plus a digital word
	gatePorchUS = (pTrain->doGate) ? pTrain->gatePorchMS * 1000.0 : 0;
	durationUS = pTrain->durationMS * 1000.0;
	
// First determine the DASample period.  We require the entire stimulus to fit within the ITC-18 FIFO.
// We divide down to allow for enough DA (channels) and digital (1) samples, plus a 2x safety factor
    
	ticksPerInstruction = ITC18_MINIMUM_TICKS;
	while ((durationUS + 2 * gatePorchUS) / (kITC18TickTimeUS * ticksPerInstruction) > 
											FIFOSize / (instructionsPerSampleSet * 2)) {
		ticksPerInstruction++;
	}
	if (ticksPerInstruction > ITC18_MAXIMUM_TICKS) {
		return NO;
	}
	
// Precompute some important values
	
	instructionPeriodUS = ticksPerInstruction * kITC18TickTimeUS;
	DASampleSetPeriodUS = instructionPeriodUS * instructionsPerSampleSet;
	DASampleSetsPerPhase = round(pTrain->pulseWidthUS / DASampleSetPeriodUS);
	sampleSetsInPorch = gatePorchUS / DASampleSetPeriodUS;		// DA samples in the gate porch
	DASampleSetsInTrain = durationUS / DASampleSetPeriodUS;		// DA samples in entire train
	bufferLength = MAX(DASampleSetsInTrain * instructionsPerSampleSet, instructionsPerSampleSet);
	pulsePeriodUS = (pTrain->frequencyHZ > 0) ? 1.0 / pTrain->frequencyHZ * 1000000.0 : 0;
	gateBits = ((pTrain->doGate) ? (0x1 << pTrain->gateBit) : 0);
	gateAndPulseBits = gateBits | ((pTrain->doPulseMarkers) ? (0x1 << pTrain->pulseMarkerBit) : 0);
	
// Create and load an array with output values that make up one pulse (DA plus digital).  These will be inserted
// into trainValues repeatedly in the next section.
	
	DASamplesPerPulse = DASampleSetsPerPhase * (pTrain->pulseBiphasic) ? 2 : 1;
	if (DASamplesPerPulse > 0) {
		for (index = 0; index < channels; index++) {
			rangeFraction[index] = (pTrain[index].amplitude / pTrain[index].fullRangeV) /
				((pTrain[index].pulseType == kCurrentPulses) ? pTrain[index].UAPerV : 1);
		}
		pulseValues = [[NSMutableData alloc] initWithLength:DASamplesPerPulse *
                                                   instructionsPerSampleSet * sizeof(short)];
		for (index = 0; index < channels; index++) {
			values[index] = rangeFraction[index] * 0x7fff;		// amplitude might be positive or negative
		}
		values[index] = gateAndPulseBits;						// digital output word
		for (sampleSetIndex = 0; sampleSetIndex < DASampleSetsPerPhase; sampleSetIndex++) {
			[pulseValues replaceBytesInRange:NSMakeRange(sampleSetIndex * sizeof(short) * instructionsPerSampleSet, 
						sizeof(short) * instructionsPerSampleSet) withBytes:&values];
		}
		if (pTrain->pulseBiphasic) {
			for (index = 0; index < channels; index++) {
				values[index] = -rangeFraction[index] * 0x7fff;		// amplitude might be positive or negative
			}
			values[index] = gateAndPulseBits;						// digital output word
			for (sampleSetIndex = 0; sampleSetIndex < DASampleSetsPerPhase; sampleSetIndex++) {
				[pulseValues replaceBytesInRange:
				 NSMakeRange((DASampleSetsPerPhase + sampleSetIndex) * sizeof(short) * instructionsPerSampleSet, 
							 sizeof(short) * instructionsPerSampleSet) withBytes:&values];
			}
		}
	}
	
// Create an array for the entire output sequence (trainValues).  It is created zeroed.  If there is a gating signal,
// we add that to the digital output values.  bufferLength is always at least as long as instructionsPerSampleSet.
	
	trainValues = [[NSMutableData alloc] initWithLength:bufferLength * sizeof(short)];
	if (gateBits > 0) {
		sPtr = [trainValues mutableBytes];
		for (index = 0; index < DASampleSetsInTrain; index++) {
			sPtr += channels;							// skip over analog values
			*(sPtr)++ = gateBits;						// set the gate bits
		}
	}
	
// Modify the output sequence by inserting the pulses.  If the stimulation frequency is zero
// (pulsePeriodUS set to 0), we load no pulses.  If the duration is shorter than one pulse, nothing
// is loaded.  If the pulseWidth is zero, nothing is loaded.
	
	if ((pulsePeriodUS > 0) && (DASampleSetsPerPhase > 0)) {
		for (pulseCount = 0; ; pulseCount++) {
			sampleSetIndex = pulseCount * pulsePeriodUS / DASampleSetPeriodUS;
			valueIndex = sampleSetIndex * instructionsPerSampleSet;
			if ((valueIndex + DASamplesPerPulse * ((pTrain->pulseBiphasic) ? 2 : 1) + 1) >= bufferLength) {
				break;
			}
			[trainValues replaceBytesInRange:NSMakeRange(valueIndex * sizeof(short), 
						[pulseValues length]) withBytes:[pulseValues bytes]];
		}
	}
	
// If there the gate has a front and back porch, add the porches to the output values
	
	if (sampleSetsInPorch > 0) {
		porchBufferLength = sampleSetsInPorch * instructionsPerSampleSet;
		porchValues = [[NSMutableData alloc] initWithLength:(porchBufferLength * sizeof(short))];
		sPtr = [porchValues mutableBytes];
		for (index = 0; index < sampleSetsInPorch; index++) {
			sPtr += channels;							// skip over analog values
			*(sPtr)++ = gateBits;						// set the gate bits
		}
		[trainValues appendData:porchValues];	 		// stim train, back porch
		[porchValues appendData:trainValues];			// front porch, stim train, back porch
		[trainValues release];							// release unneeded data
		trainValues = porchValues;						// make trainValues point to the whole set
		bufferLength += 2 * porchBufferLength;			// tally the buffer length with both porches
	}
	
// Make the last digital output word in the buffer close the gate (0x00)
	
	[trainValues resetBytesInRange:NSMakeRange((bufferLength - 1) * sizeof(short), sizeof(short))];

// Set up the ITC for the stimulus train.  Do everything except the start.  For every DA output,
// we also do a read on the corresponding AD channel
	
	for (index = 0; index < channels; index++) {
		ITCInstructions[index] = 
			ADInstructions[pTrain[index].DAChannel] | DAInstructions[pTrain[index].DAChannel] | 
						ITC18_INPUT_UPDATE | ITC18_OUTPUT_UPDATE;
	} 
	ITCInstructions[index] = ITC18_OUTPUT_DIGITAL1 | ITC18_INPUT_SKIP | ITC18_OUTPUT_UPDATE;
	[deviceLock lock];
	ITC18_SetSequence(itc, (int)(channels + 1), ITCInstructions);
	ITC18_StopAndInitialize(itc, YES, YES);
    ITC18_GetFIFOWriteAvailable(itc, &writeAvailable);
	if (writeAvailable < DASampleSetsInTrain) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18PulseTrainDevice"
                informativeText:@"An ITC18 Laboratory Interface card was found, but the write buffer was full."];
		[trainValues release];
		return NO;
	}
    result = ITC18_WriteFIFO(itc, (int)bufferLength, (short *)[trainValues bytes]);
	[trainValues release];
    if (result != noErr) { 
        NSLog(@"Error ITC18_WriteFIFO, result: %d", result);
        return NO;
    }
	ITC18_SetSamplingInterval(itc, (int)ticksPerInstruction, NO);
	samplesReady = NO;
	[deviceLock unlock];
	return YES;
}

- (BOOL)outputDigitalEvent:(long)event withData:(long)data;
{
    if (itc == nil) {
        return NO;
    }
    [deviceLock lock];
    [self digitalOutputBits:(event | 0x8000)];
    [self digitalOutputBits:(data & 0x7fff)];
    [deviceLock unlock];
    return YES;
}

- (void)readData;
{
	short index, *samples, *pSamples, *channelSamples[ITC18_NUMBEROFDACOUTPUTS];
	long sets, set;
	int available;
	NSAutoreleasePool *threadPool = [[NSAutoreleasePool alloc] init];		// create a threadPool for this thread

	sets = bufferLength / (channels + 1);										// number of sample sets in stim
	samples = malloc(sizeof(short) * bufferLength);
	for (index = 0; index < channels; index++) {
		channelSamples[index] = malloc(sizeof(short) * sets);
	}

// When a sequence is started, the first three entries in the FIFO are garbage.  They should be thrown out.  
	
	[deviceLock lock];			// Wait here for the lock, then check time again
	while ((available = [self getAvailable]) < kGarbageLength + 1) {
		usleep(1000);
	}
	ITC18_ReadFIFO(itc, kGarbageLength, samples);
	
// Wait for the stimulus to be over.
	
	while ((available = [self getAvailable]) < bufferLength) {
		usleep(10000);
	}

// When all the samples are available, read them and unpack them
	
	ITC18_ReadFIFO(itc, (int)bufferLength, samples);							// read all available sets
	for (set = 0; set < sets; set++) {									// process each set
		pSamples = &samples[(channels + 1) * set];						// point to start of a set
		for (index = 0; index < channels; index++) {					// for every channel
			channelSamples[index][set] = *pSamples++;
		}
	}
	for (index = 0; index < channels; index++) {
		[inputSamples[index] release];
		inputSamples[index] = [[NSData dataWithBytes:channelSamples[index] length:(sets * sizeof(short))] retain];
	}
	samplesReady = YES;                                                 // flag that the input is all read in
	[deviceLock unlock];
    [threadPool release];
}

- (NSData **)sampleData;
{
	if (!itcExists) {								// return nil data when no device is present
        return nil;
//        return inputSamples;
	}
	if (!samplesReady) {                            // or the samples aren't all read in yet
		return nil;
	}
	else {
		samplesReady = NO;
		return inputSamples;
	}
}

- (float)samplePeriodUS;
{
	return DASampleSetPeriodUS;
}

// Report whether it is safe to call sampleData

- (BOOL)samplesReady;
{
	return (samplesReady || !itcExists);
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

- (BOOL)setTrainArray:(NSArray *)array;
{
	BOOL doPulseMarkers, doGate, pulseBiphasic;
	long index, DAchannels, pulseType, durationMS, gateBit, pulseMarkerBit, pulseWidthUS;
	float frequencyHZ, fullRangeV, UAPerV;
	PulseTrainData trainData[kMaxDAChannels];
	NSValue *value;
	
	DAchannels = [array count];  
	if (!itcExists || (DAchannels == 0)) {
		return YES;
	}
	
// Check that the entries are within limits, then unload the data
	
	if (DAchannels > ITC18_NUMBEROFDACOUTPUTS) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18PulseTrainDevice"
                                 informativeText: @"Too many channels requested.  Ignoring request."];
		return NO;
	}
	for (index = 0; index < DAchannels; index++) {
		value = [array objectAtIndex:index];
		[value getValue:&trainData[index]];
		if (index == 0) {
			doPulseMarkers = trainData[index].doPulseMarkers;
			doGate = trainData[index].doGate;
			pulseBiphasic = trainData[index].pulseBiphasic;
			pulseType = trainData[index].pulseType;
			durationMS = trainData[index].durationMS;
			gateBit = trainData[index].gateBit;
			pulseMarkerBit = trainData[index].pulseMarkerBit; 
			pulseWidthUS = trainData[index].pulseWidthUS;
			frequencyHZ = trainData[index].frequencyHZ;
			fullRangeV = trainData[index].fullRangeV;
			UAPerV = trainData[index].UAPerV;		
		}
		else if (doPulseMarkers != trainData[index].doPulseMarkers|| doGate != trainData[index].doGate ||
			pulseBiphasic != trainData[index].pulseBiphasic || pulseType != trainData[index].pulseType ||
			durationMS != trainData[index].durationMS || gateBit != trainData[index].gateBit ||
			pulseMarkerBit != trainData[index].pulseMarkerBit ||  pulseWidthUS != trainData[index].pulseWidthUS ||
			frequencyHZ != trainData[index].frequencyHZ || fullRangeV != trainData[index].fullRangeV ||
				 UAPerV != trainData[index].UAPerV) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18PulseTrainDevice"
                                     informativeText: @"Incompatible values requested on different DA channels."];
			return NO;
		}			
	} 
	return [self makeInstructionsFromTrainData:trainData channels:DAchannels];
}

/* 
Get new stimulation parameter and load the instruction sequence in the ITC-18.  We create a buffer
in which alternate words are DA values and digital output words (to gate the train and mark the pulses).  
We load the entire stimulus into the buffer, so that no servicing is needed.
*/

- (BOOL)setTrainParameters:(PulseTrainData *)pTrain;
{
	return [self makeInstructionsFromTrainData:pTrain channels:1];
}

- (void)stimulate;
{
	if (!itcExists) {
		return;
	}
	[deviceLock lock];
	ITC18_Start(itc, NO, YES, NO, NO);				// Start with no external trigger, output enabled
	[deviceLock unlock];
	[NSThread detachNewThreadSelector:@selector(readData) toTarget:self withObject:nil];
}
@end
