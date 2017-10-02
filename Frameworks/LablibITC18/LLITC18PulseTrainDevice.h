//
//  LLITC18PulseTrainDevice.h
//  Lablib
//
//  Created by John Maunsell.
//  Copyright (c) 2008. All rights reserved.
//

#import <Lablib/LLPulseTrainDevice.h>
#import <Lablib/LLDataDevice.h>
#import <ITC/Itcmm.h>

@interface LLITC18PulseTrainDevice : NSObject <LLPulseTrainDevice>  {

@private
	long				bufferLength;				// instructions in stimulus
	long				channels;					// number of active channels
	float				DASampleSetPeriodUS;
    NSLock				*deviceLock;
	unsigned short		digitalOutputWord;
	long				FIFOSize;
	NSData				*inputSamples[ITC18_NUMBEROFDACOUTPUTS];
	Ptr					itc;
	BOOL				itcExists;
	BOOL				samplesReady;
    BOOL                weOwnITC;
}

- (void)close;
- (void)digitalOutputBits:(unsigned long)bits;
- (void)digitalOutputBitsOff:(unsigned short)bits;
- (void)digitalOutputBitsOn:(unsigned short)bits;
- (void)doInitializationWithDevice:(long)numDevice;
- (id)initWithDevice:(long)numDevice;
- (id)initWithDataDevice:(LLDataDevice *)dataDevice;
- (BOOL)makeInstructionsFromTrainData:(PulseTrainData *)pTrain channels:(long)channels;
- (BOOL)open:(long)numDevice;
- (BOOL)outputDigitalEvent:(long)event withData:(long)data;

@end
