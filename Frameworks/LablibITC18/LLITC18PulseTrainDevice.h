//
//  LLITC18PulseTrainDevice.h
//  Lablib
//
//  Created by John Maunsell.
//  Copyright (c) 2008. All rights reserved.
//

#import <Lablib/LLPulseTrainDevice.h>
#import <Lablib/LLDataDevice.h>
#import <LablibITC18/LLITC18DataDevice.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#import <ITC/Itcmm.h>
#import <ITC/ITC18.h>
#pragma clang diagnostic pop

@interface LLITC18PulseTrainDevice : NSObject <LLPulseTrainDevice>  {

@private
	long				bufferLength;				// instructions in stimulus
	long				channels;					// number of active channels
	float				DASampleSetPeriodUS;
    LLITC18DataDevice   *dataDevice;                // LLITCDataDevice from which we inherited control
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
- (instancetype)initWithDevice:(long)numDevice;
- (instancetype)initWithDataDevice:(LLDataDevice *)theDataDevice;
- (BOOL)makeInstructionsFromTrainData:(PulseTrainData *)pTrain channels:(long)channels;
- (BOOL)open:(long)numDevice;
- (BOOL)outputDigitalEvent:(long)event withData:(long)data;

@end
