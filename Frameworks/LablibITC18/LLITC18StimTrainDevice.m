//
//  LLITC18StimTrainDevice.m 
//  Lablib
//
//  Created by John Maunsell on Mon Jun 09 2003.
//  Copyright (c) 2003. All rights reserved. 
//

#import "LLITC18StimTrainDevice.h"					
#import <ITC/Itcmm.h>
#import <ITC/ITC18.h>

#define kDriftTimeLimitMS	0.010
#define kDriftFractionLimit	0.001
#define kGarbageLength		3					// Invalid entries at the start of sequence
#define	kITC18TicksPerMS	800L				// Time base for ITC18
#define kITC18TickTimeUS	1.25
#define kOverSample			4

static short DAInstructions[] = {ITC18_OUTPUT_DA0, ITC18_OUTPUT_DA1, ITC18_OUTPUT_DA2,  ITC18_OUTPUT_DA3};

@implementation LLITC18StimTrainDevice

// Close the ITC18.  

- (void)close {

	if (itc != nil) {
		[deviceLock lock];
		ITC18_Close(itc);
		DisposePtr(itc);
		itc = nil;
		[deviceLock unlock];
	}
}

- (BOOL)dataEnabled {
	
	return dataEnabled;
}

- (void)dealloc {

	[self close];
	[deviceLock release];
	[super dealloc];
}

- (void)digitalOutputBitsOff:(unsigned short)bits {

	if (itc != nil) {
		digitalOutputWord &= ~bits;
		ITC18_WriteAuxiliaryDigitalOutput(itc, digitalOutputWord);
	}
}

- (void)digitalOutputBitsOn:(unsigned short)bits {

	if (itc != nil) {
		digitalOutputWord |= bits;
		ITC18_WriteAuxiliaryDigitalOutput(itc, digitalOutputWord);
	}
}

- (unsigned short)digitalInputValues {

	return digitalInputWord;
}

- (BOOL)hasITC18 {

	return itcExists;
}

- (void)doInitializationWithDevice:(long)numDevice {

	long index; 
	int ranges[ITC18_AD_CHANNELS];

	itc = nil;
	deviceLock = [[NSLock alloc] init];
	if ([self open:numDevice]) {
		for (index = 0; index < ITC18_AD_CHANNELS; index++) {	// Set AD voltage range
			ranges[index] = ITC18_AD_RANGE_10V;
		}
		ITC18_SetRange(itc, ranges);
		ITC18_SetDigitalInputMode(itc, YES, NO);				// latch and do not invert
		FIFOSize = ITC18_GetFIFOSize(itc);
	}
}

- (instancetype)init {

	if ((self = [super init]) != Nil) {
		[self doInitializationWithDevice:0];
	}
	return self;
}
// Initialization tests for the existence of the ITC, and initializes it if it is there.
// The ITC initialization sets thd AD voltage, and also set the digital input to latch.
// ITC-18 latching is not the same thing as edge triggering.  A short pulse will produce a positive 
// value at the next read, but a steady level can also produce a series of positive values.

- (instancetype)initWithDevice:(long)numDevice {

	if ((self = [super init]) != Nil) {
		[self doInitializationWithDevice:numDevice];
	}
	return self;
}

- (void)loadInstructionSequence {
}

// Open and initialize the ITC18

- (BOOL)open:(long)deviceNum;
{
	long code;
	long interfaceCodes[] = {0x0, USB18_CL};

    [deviceLock lock];
	if (itc == nil) {						// current opened?
		if ((itc = NewPtr(ITC18_GetStructureSize())) == nil) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18StimTrainDevice"
                                     informativeString: @"Failed to allocate pLocal memory."];
			exit(0);
		}
	}
	else {
        ITC18_Close(itc);
	}

	for (code = 0, itcExists = NO; code < sizeof(interfaceCodes) / sizeof(long); code++) {
		NSLog(@"LLITC18DataDevice: attempting to initialize device %d using code %d",
					deviceNum, deviceNum | interfaceCodes[code]);
		if (ITC18_Open(itc, deviceNum | interfaceCodes[code]) != noErr) {
			continue;									// failed, try another code
		}

	// the ITC has opened, now initialize it

		if (ITC18_Initialize(itc, ITC18_STANDARD) != noErr) {
			ITC18_Close(itc);							// failed, close to try again
		}
		else {
			USB18 = interfaceCodes[code] == USB18_CL;
			itcExists = YES;						// successful initialization
			break;
		}
	}
	if (itcExists) {
		NSLog(@"LLITC18StimTrainDevice: succeeded initialize device %d using code %d",
					deviceNum, deviceNum | interfaceCodes[code]);
		ITC18_SetDigitalInputMode(itc, YES, NO);				// latch and do not invert
		ITC18_SetExternalTriggerMode(itc, NO, NO);				// no external trigger
	}
	else {
		DisposePtr(itc);
		itc = nil;
	}
	[deviceLock unlock];
	return itcExists;
}

/* 
Get new stimulation parameter and load the instruction sequence in the ITC-18.  We create a buffer
in which alternate words are DA values and digital output words (to gate the train and mark the pulses).  
We load the entire stimulus into the buffer, so that no servicing is needed.
*/

- (BOOL)setTrainParameters:(StimTrainData *)pTrain {

	short values[2], gateAndPulseBits, gateBits, *sPtr;
	long index, DASamples, sampleIndex, ticksPerInstruction, DASamplesPerPulse;
	long bufferLength, pulseCount;
	int writeAvailable, result;
	float instructionPeriodUS, pulsePeriodUS, rangeFraction, DASamplePeriodUS;
	NSMutableData *trainValues, *pulseValues;
	int ITCInstructions[2]; 

	if (!itcExists) {
		return YES;
	}
	
// First determine the DASample period.  We require the entire stimulus to fit within the ITC-18 FIFO.
// We divide by a factor of 4 to allow for DA and Digital (2x) and a factor of safety (2x)
    
	ticksPerInstruction = ITC18_MINIMUM_TICKS;
	while ((pTrain->durationMS * 1000.0) / (kITC18TickTimeUS * ticksPerInstruction) > FIFOSize / 4.0) {
		ticksPerInstruction++;
	}
	if (ticksPerInstruction > ITC18_MAXIMUM_TICKS) {
		return NO;
	}
	
// Precompute values
	
	instructionPeriodUS = ticksPerInstruction * kITC18TickTimeUS;
	DASamplePeriodUS = instructionPeriodUS * 2.0;
	DASamplesPerPulse = round(pTrain->pulseWidthUS / DASamplePeriodUS);
	DASamples = pTrain->durationMS * 1000.0 / DASamplePeriodUS; // DA samples in entire train
	bufferLength = MAX(DASamples * 2, 2);
	pulsePeriodUS = (pTrain->frequencyHZ > 0) ? 1.0 / pTrain->frequencyHZ * 1000000.0 : 0;
	gateBits = ((pTrain->doGate) ? (0x1 << pTrain->gateBit) : 0);
	gateAndPulseBits = gateBits | ((pTrain->doPulseMarkers) ? (0x1 << pTrain->pulseMarkerBit) : 0);
					
// Create and load an array with output values that make up one pulse (DA and digital)

	if (DASamplesPerPulse > 0) {
		pulseValues = [[NSMutableData alloc] initWithLength:DASamplesPerPulse * 4 * sizeof(short)];
		rangeFraction = (pTrain->amplitudeUA / pTrain->UAPerV) / pTrain->fullRangeV;
		values[0] = -rangeFraction * 0x7fff;		// negative (cathodal) pulse DA value (first)
		values[1] = gateAndPulseBits;				// digital output word
		for (sampleIndex = 0; sampleIndex < DASamplesPerPulse; sampleIndex++) {
			[pulseValues replaceBytesInRange:NSMakeRange(sampleIndex * sizeof(short) * 2, sizeof(short) * 2)
				withBytes:&values];
		}
		values[0] = rangeFraction * 0x7fff;			// positive (anodal) pulse DA value (second)
		for (sampleIndex = 0; sampleIndex < DASamplesPerPulse; sampleIndex++) {
			[pulseValues replaceBytesInRange:
				NSMakeRange((DASamplesPerPulse + sampleIndex) * sizeof(short) * 2, sizeof(short) * 2)
				withBytes:&values];
		}
	}
	
// Create an array with the entire output sequence.  It starts zeroed.  If there is a gating signal,
// we add that to the digital output values.  bufferLength is always at least 2.

	trainValues = [[NSMutableData alloc] initWithLength:bufferLength * sizeof(short)];
	if (gateBits > 0) {
		sPtr = [trainValues mutableBytes];
		for (index = 0; index < bufferLength / 2 - 1; index++) {
			sPtr++;										// skip over analog value
			*sPtr++ = gateBits;							// set the gate bits
		}
	}
	
// Modify the output sequence to include the pulses.  If the stimulation frequency is zero
// (pulsePeriodUS set to 0), we load no pulses.  If the duration is shorter than one pulse, nothing
// is loaded.  If the pulseWidth is zero, nothing is loaded.
	
	if ((pulsePeriodUS > 0) && (DASamplesPerPulse > 0)) {
		for (pulseCount = sampleIndex = 0; sampleIndex < DASamples; pulseCount++) {
			sampleIndex = pulseCount * pulsePeriodUS / DASamplePeriodUS;
			if (sampleIndex + 2 * DASamplesPerPulse + 1 < DASamples) {				// another biphasic pulse will fit
				[trainValues replaceBytesInRange:NSMakeRange(sampleIndex * sizeof(short) * 2, 
								[pulseValues length]) withBytes:[pulseValues bytes]];
			}
		}
	}
	
// Set up the ITC for the stimulus train.  Do everything except the start

	ITCInstructions[0] = DAInstructions[pTrain->DAChannel] | ITC18_INPUT_SKIP | ITC18_OUTPUT_UPDATE;
	ITCInstructions[1] = ITC18_OUTPUT_DIGITAL1 | ITC18_INPUT_SKIP | ITC18_OUTPUT_UPDATE;
	ITC18_SetSequence(itc, sizeof(ITCInstructions) / sizeof(int), ITCInstructions); 
	ITC18_StopAndInitialize(itc, YES, YES);
//	ITC18_InitializeAcquisition(itc);
    ITC18_GetFIFOWriteAvailable(itc, &writeAvailable);
	if (writeAvailable < DASamples) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLITC18StimTrainDevice"
                    informativeString:@"An ITC18 Laboratory Interface card was found, but the write buffer was full."];
		[trainValues release];
		return NO;
	}
    result = ITC18_WriteFIFO(itc, bufferLength, (short *)[trainValues bytes]);
	[trainValues release];
    if (result != noErr) { 
        NSLog(@"Error ITC18_WriteFIFO, result: %d", result);
        return NO;
    }
	ITC18_SetSamplingInterval(itc, ticksPerInstruction, NO);
	return YES;
}


- (void)stimulate {

	if (itcExists) {
		ITC18_Start(itc, NO, YES, NO, NO);				// Start with no external trigger, output enabled
	}
}

@end
