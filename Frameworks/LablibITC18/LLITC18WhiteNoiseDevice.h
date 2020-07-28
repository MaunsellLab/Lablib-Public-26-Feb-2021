//
//  LLITC18WhiteNoiseDevice.h
//  Lablib
//
//  Created by John Maunsell.
//  Copyright (c) 2008-2020. All rights reserved.
//

#import <Lablib/LLWhiteNoiseDevice.h>
#import <Lablib/LLDataDevice.h>
#import <LablibITC18/LLITC18DataDevice.h>
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
#import <ITC/Itcmm.h>
#import <ITC/ITC18.h>
#pragma clang diagnostic pop

@interface LLITC18WhiteNoiseDevice : NSObject <LLWhiteNoiseDevice>  {

@private
	NSData				*inputSamples[ITC18_NUMBEROFDACOUTPUTS];
}

- (void)close;
- (void)digitalOutputBits:(unsigned long)bits;
- (void)digitalOutputBitsOff:(unsigned short)bits;
- (void)digitalOutputBitsOn:(unsigned short)bits;
- (void)doInitializationWithDevice:(long)numDevice;
- (instancetype)initWithDevice:(long)numDevice;
- (instancetype)initWithDataDevice:(LLDataDevice *)theDataDevice;
- (BOOL)makeInstructionsFromTrainData:(WhiteNoiseData *)pNoise channels:(long)channels;
- (BOOL)open:(long)numDevice;
- (BOOL)outputDigitalEvent:(long)event withData:(long)data;

@end
