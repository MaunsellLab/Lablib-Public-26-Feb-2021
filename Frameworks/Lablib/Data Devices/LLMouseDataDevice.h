//
//  LLMouseDataDevice.h
//  Lablib
//
//  Created by John Maunsell on Thu Jun 05 2003.
//  Copyright (c) 2005. All rights reserved.
//

#import <Lablib/LLDataDevice.h>

#define kLLMouseADChannels				8
#define kLLMouseDigitalBits				16
#define kLLMouseSamplePeriodMS			5
#define kLLMouseTimestampPeriodMS		1

#define kLLMouseButtonBitsKey           @"LLMouseButtonBits"
#define kLLMouseGainKey                 @"LLMouseGain"
#define LLMouseXBitsKey                 @"LLMouseXBits"
#define LLMouseYBitsKey                 @"LLMouseYBits"

@interface LLMouseDataDevice : LLDataDevice {

	BOOL				buttonWasDown;
	double 				nextSampleTimeS;
	BOOL				mouseDown;
	NSPoint				origin;
	NSMutableData		*sampleData[kLLMouseADChannels];
    double				timestampRefS;
	NSMutableData		*timestampData[kLLMouseDigitalBits];
}

- (void)setMouseState:(long)state;
- (void)setOrigin:(NSPoint)point;

@end
