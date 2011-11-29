//
//  Events.m
//  TestEventDescriptions
//
//  This application creates a Lablib data file with data event that include event definitions
//  It creates examples of the various permutations of the data event types, and include some
//  of the major event definitions included in Lablib.  
//
//  It is meant to help with debugging of the creation and parsing of data event defintions
//
//  Created by John Maunsell on 2/26/05.
//  Copyright 2005. All rights reserved.
//

/*

xx) It is acceptable to set the element count in a definition to 0 (or equivalently, 
not initialize it).  This is interpreted as a count of 1.

xx) An entry defined as "string" implies an element size of sizeof(char) (regardless of
the value that is set, and a element count of -1 (i.e., variable, regardless of the value
that is set in the definition

*/

#import <Lablib/LLGabor.h>

//#define SIMPLETYPES
//#define STRUCT
//#define SIMPLEARRAYS
#define COMPLEXSTRUCT
#define LABLIBEVENTS
//#define SPIKES
//#define SAMPLES
//#define DEVICEDATA

#import "Events.h"

#define kArrayEntries		16
#define kBigArrayEntries	256
#define kCharArrayBytes		16
#define kDataChunks			3
#define kDataChunkSize		50
#define kDevices			2
#define kSmallStructs		2
#define kSpikes				100
#define kSamples			250
#define kSampleChannels		4
#define kSpikeChannels		4

typedef struct {
	char			sC;
	unsigned char	sUC;
	BOOL			sB;
	short			sS;
	unsigned short	sUS;
	long			sL;
	unsigned long	sUL;
	float			sF;
	double			sD;
} TestStruct;

LLDataDef gaborStructDef[] = kLLGaborEventDesc;
LLDataDef randomDotsStructDef[] = kLLRandomDotsEventDesc;

LLDataDef testStructDef[] =	{	
	{@"char",			@"charTag", 1, offsetof(TestStruct, sC)},
	{@"unsigned char",	@"unsignedCharTag", 1, offsetof(TestStruct, sUC)},
	{@"boolean",		@"booleanTag", 1, offsetof(TestStruct, sB)},
	{@"short",			@"shortTag", 1, offsetof(TestStruct, sS)},
	{@"unsigned short",	@"unsignedShortTag", 1, offsetof(TestStruct, sUS)},
	{@"long",			@"longTag", 1, offsetof(TestStruct, sL)},
	{@"unsigned long",	@"unsignedLongTag", 1, offsetof(TestStruct, sUL)},
	{@"float",			@"floatTag", 1, offsetof(TestStruct, sF)},
	{@"double",			@"doubleTag", 1, offsetof(TestStruct, sD)},
	nil};

typedef struct {
	short			sSS;
	long			sSL;
} SmallStruct;

LLDataDef deviceADStructDef[] = {
	{@"short",			@"device", 1, offsetof(DeviceDataHeader, device)},
	{@"short",			@"channel", 1, offsetof(DeviceDataHeader, channel)},
	{@"long",			@"count", 1, offsetof(DeviceDataHeader, count)},
	{@"short",			@"AD", -1, sizeof(DeviceDataHeader)},
	nil};

LLDataDef deviceTimestampStructDef[] = {
	{@"short",			@"device", 1, offsetof(DeviceDataHeader, device)},
	{@"short",			@"channel", 1, offsetof(DeviceDataHeader, channel)},
	{@"long",			@"count", 1, offsetof(DeviceDataHeader, count)},
	{@"short",			@"timestamp", -1, sizeof(DeviceDataHeader)},
	nil};

LLDataDef smallStructDef[] = {	
	{@"short",			@"shortSubStruct", 1, offsetof(SmallStruct, sSS)},
	{@"long",			@"longSubStruct", 1, offsetof(SmallStruct, sSL)},
	nil};

typedef struct {
	double			sD;
	float			sF;
	short			sS;
	SmallStruct		sStruct[kSmallStructs];
	char			sC[kCharArrayBytes];
} ArrayStruct;

LLDataDef arrayStructDef[] = {	
	{@"double",		@"doubleTag", 1, offsetof(ArrayStruct, sD)},
	{@"float",		@"floatTag", 1, offsetof(ArrayStruct, sF)},
	{@"short",		@"shortTag", 1, offsetof(ArrayStruct, sS)},
	{@"struct",		@"structTag",	kSmallStructs,  offsetof(ArrayStruct, sStruct[0]), sizeof(SmallStruct), smallStructDef},
	{@"char",		@"charTag",		kCharArrayBytes, offsetof(ArrayStruct, sC)},
	nil};

EventDefinition events[] = {
#ifdef SIMPLETYPES
	{@"stringEvent",			0,						{@"string"}},
	{@"noDataEvent",			0,						{@"no data"}},
	{@"charDataEvent",			sizeof(char),			{@"char"}},
	{@"unsignedCharDataEvent",	sizeof(char),			{@"unsigned char"}},
	{@"booleanDataEvent",		sizeof(BOOL),			{@"boolean"}},
	{@"shortDataEvent",			sizeof(short),			{@"short"}},
	{@"unsignedShortDataEvent",	sizeof(unsigned short),	{@"unsigned short"}},
	{@"longDataEvent",			sizeof(long),			{@"long"}},
	{@"unsignedLongDataEvent",	sizeof(unsigned long),	{@"unsigned long"}},
	{@"floatDataEvent",			sizeof(float),			{@"float"}},
	{@"doubleDataEvent",		sizeof(double),			{@"double"}},
#endif
#ifdef STRUCT
	{@"structDataEvent",		sizeof(TestStruct),		{@"struct", @"testStruct", 1, 0, sizeof(TestStruct), testStructDef}},
	{@"gabor",					sizeof(Gabor),			{@"struct", @"gabor", 1, 0, sizeof(Gabor), gaborStructDef}},
	{@"randomDots",				sizeof(RandomDots),		{@"struct", @"randomDots", 1, 0, sizeof(RandomDots), randomDotsStructDef}},
#endif
#ifdef SIMPLEARRAYS
	{@"charArrayDataEvent",			sizeof(char),			{@"char", nil, kArrayEntries}},
	{@"unsignedCharArrayDataEvent",	sizeof(unsigned char),	{@"unsigned char", nil, kArrayEntries}},
	{@"booleanArrayDataEvent",		sizeof(BOOL),			{@"boolean", nil, kArrayEntries}},
	{@"shortArrayDataEvent",		sizeof(short),			{@"short", nil, kArrayEntries}},
	{@"unsignedShortArrayDataEvent",sizeof(unsigned short), {@"unsigned short", nil, kArrayEntries}},
	{@"longArrayDataEvent",			sizeof(long),			{@"long", nil, kArrayEntries}},
	{@"unsignedLongArrayDataEvent",	sizeof(unsigned long),	{@"unsigned long", nil, kArrayEntries}},
	{@"floatArrayDataEvent",		sizeof(float),			{@"float", nil, kArrayEntries}},
	{@"doubleArrayDataEvent",		sizeof(double),			{@"double", nil, kArrayEntries}},

	{@"shortBigArrayDataEvent",		sizeof(short),			{@"short", nil, kBigArrayEntries}},
#endif
#ifdef COMPLEXSTRUCT
	{@"arrayStructDataEvent",		sizeof(ArrayStruct),	{@"struct", @"arrayStruct", -1, 0, sizeof(ArrayStruct), arrayStructDef}},
#endif	
#ifdef DEVICEDATA
	{@"deviceADData",				sizeof(short),			{@"struct", @"deviceADData", -1, 
																sizeof(DeviceDataHeader), 
																sizeof(short), deviceADStructDef}},
	{@"deviceTimestampData",		sizeof(short),			{@"struct", @"deviceTimestampData", -1, 
																sizeof(DeviceDataHeader), 
																sizeof(short), deviceTimestampStructDef}},
#endif
#ifndef LABLIBEVENTS
	{@"trialStart",			sizeof(long),					{@"long"}},
	{@"trialEnd",			sizeof(long),					{@"long"}},
#endif	
};

@implementation Events

- (void)awakeFromNib;
{
	long index, entry, j, channel, device, chunk;
	short sample, dataValue;
	char c, cArray[kArrayEntries];
	unsigned char uc, uCArray[kArrayEntries];
	BOOL b, bArray[kArrayEntries];
	short s, sArray[kArrayEntries], sBigArray[kBigArrayEntries];
	unsigned short us, uSArray[kArrayEntries];
	long l, lArray[kArrayEntries];
	unsigned long ul, uLArray[kArrayEntries];
	float f, fArray[kArrayEntries];
	double d, dArray[kArrayEntries];
	TestStruct st;
	NSMutableData *data;

	ArrayStruct aS[kArrayEntries];
	LLEyeCalibrationData eyeCalibration;
	FixWindowData fixWindow;
	DisplayParam displayParam;
	Gabor gabor;
	RandomDots randomDots;

	LLDataDoc *dataDoc;
	TimestampData timestamp;
	ADData ad;
	DeviceDataHeader dataHeader;
	short samples[2];
	char stringBuffer[256];
	float windowDeg[4] = {0, 0, 1, 1};
	float windowUnits[4] = {0, 0, 100, 100};

	dataDoc = [[LLDataDoc alloc] init]; 
#ifdef LABLIBEVENTS
	[dataDoc defineEvents:[LLStandardDataEvents eventsWithDataDefs] count:[LLStandardDataEvents count]];
#endif
	[dataDoc defineEvents:events count:sizeof(events) / sizeof(EventDefinition)];
	[dataDoc createDataFile];

// Header

#ifdef LABLIBEVENTS
	[dataDoc putEvent:@"text" withData:(Ptr)"This file contains test information and three trials" 
					lengthBytes:strlen("This file contains test information and three trials")];
#endif

// Load values

	for (index = 0; index < 3; index++) {
		c = uc = b = s = us = l = ul = f = d = index * 100;
		st.sC = st.sUC = st.sB = st.sS = st.sUS = st.sL = st.sUL = st.sF = st.sD = index * 100;
		for (entry = 0; entry < kArrayEntries; entry++) {
			cArray[entry] = uCArray[entry] = bArray[entry] = entry + index * 100;
			sArray[entry] = uSArray[entry] = lArray[entry] = entry + index * 100;
			uLArray[entry] = fArray[entry] = dArray[entry] = entry + index * 100;
			aS[entry].sD = aS[entry].sF = aS[entry].sS = entry + index * 100;
			for (j = 0; j < kSmallStructs; j++) {
				aS[entry].sStruct[j].sSS = entry + index * 100 + j * 10;
				aS[entry].sStruct[j].sSL = entry + index * 100 + j * 10 + 1;
			}
			for (j = 0; j < kCharArrayBytes; j++) {
				aS[entry].sC[j] = j;
			}			
		}
		for (entry = 0; entry < kBigArrayEntries; entry++) {
			sBigArray[entry] = entry + index * 1000;
		}
		
		[dataDoc putEvent:@"trialStart" withData:(Ptr)&index];
		sprintf(stringBuffer, "This string is the first event after the start of trial %d", index);

// Generic standard events
#ifdef SIMPLETYPES
		[dataDoc putEvent:@"stringEvent" withData:(Ptr)stringBuffer lengthBytes:strlen(stringBuffer)];
		[dataDoc putEvent:@"noDataEvent"];
		[dataDoc putEvent:@"charDataEvent" withData:(Ptr)&c];
		[dataDoc putEvent:@"unsignedCharDataEvent" withData:(Ptr)&uc];
		[dataDoc putEvent:@"booleanDataEvent" withData:(Ptr)&b];
		[dataDoc putEvent:@"shortDataEvent" withData:(Ptr)&s];
		[dataDoc putEvent:@"unsignedShortDataEvent" withData:(Ptr)&us];
		[dataDoc putEvent:@"longDataEvent" withData:(Ptr)&l];
		[dataDoc putEvent:@"unsignedLongDataEvent" withData:(Ptr)&ul];
		[dataDoc putEvent:@"floatDataEvent" withData:(Ptr)&f];
		[dataDoc putEvent:@"doubleDataEvent" withData:(Ptr)&d];
#endif
// Generic structure
#ifdef STRUCT
		[dataDoc putEvent:@"structDataEvent" withData:(Ptr)&st];
		gabor.azimuthDeg = index;
		gabor.elevationDeg = index;
		gabor.directionDeg = index;
		gabor.sigmaDeg = index;
		gabor.radiusDeg = index;
		gabor.spatialFreqCPD = index;
		gabor.temporalFreqHz = index;
		gabor.spatialPhaseDeg = index;
		gabor.temporalPhaseDeg = index;
		gabor.temporalModulation = index;
		gabor.temporalModulationParam = index;
		gabor.spatialModulation = index;
		gabor.contrast = index;
		gabor.kdlThetaDeg = index;
		gabor.kdlPhiDeg = index;
		[dataDoc putEvent:@"gabor" withData:(Ptr)&gabor];

		randomDots.antialias = index;			// antialias the dots
		randomDots.lifeFrames = index;			// Life of each dot
		randomDots.randomSeed = index;			// seed for generating movie
		randomDots.version = index;			// version of this structure
		randomDots.azimuthDeg = index;			// Center of gabor 
		randomDots.coherence = index;		// Percent coherence
		randomDots.density = index;			// Dot Density (per degree squared)
		randomDots.directionDeg = index;		// Direction of motion
		randomDots.dotContrast = index;		// Contrast [0:1]
		randomDots.dotDiameterDeg = index;		// Dot diameter in degrees
		randomDots.elevationDeg = index;		// Center of gabor 
		randomDots.kdlPhiDeg = index;			// kdl space (deg)
		randomDots.kdlThetaDeg = index;		// kdl space (deg)
		randomDots.radiusDeg = index;		// Radius of drawing
		randomDots.speedDPS = index;			// Dot speed degrees/s
		randomDots.coherence = index;	// Coherence after step
		randomDots.backgroundColor.red = index;	// color of background
		randomDots.backgroundColor.green = index;	// color of background
		randomDots.backgroundColor.blue = index;	// color of background
		randomDots.dotColor.red = index;	// color of background
		randomDots.dotColor.green = index;	// color of background
		randomDots.dotColor.blue = index;	// color of background
		[dataDoc putEvent:@"randomDots" withData:(Ptr)&randomDots];

#endif
// Generic arrays
#ifdef SIMPLEARRAYS		
		[dataDoc putEvent:@"charArrayDataEvent" withData:(Ptr)cArray];
		[dataDoc putEvent:@"unsignedCharArrayDataEvent" withData:(Ptr)uCArray];
		[dataDoc putEvent:@"booleanArrayDataEvent" withData:(Ptr)bArray];
		[dataDoc putEvent:@"shortArrayDataEvent" withData:(Ptr)sArray];
		[dataDoc putEvent:@"unsignedShortArrayDataEvent" withData:(Ptr)uSArray];
		[dataDoc putEvent:@"longArrayDataEvent" withData:(Ptr)lArray];
		[dataDoc putEvent:@"unsignedLongArrayDataEvent" withData:(Ptr)uLArray];
		[dataDoc putEvent:@"floatArrayDataEvent" withData:(Ptr)fArray];
		[dataDoc putEvent:@"doubleArrayDataEvent" withData:(Ptr)dArray];

		[dataDoc putEvent:@"shortBigArrayDataEvent" withData:(Ptr)sBigArray];
#endif
// Array of structs
#ifdef COMPLEXSTRUCT
		[dataDoc putEvent:@"arrayStructDataEvent" withData:(Ptr)&aS count:(index + 1)];
#endif

#ifdef DEVICEDATA
		for (chunk = 0; chunk < kDataChunks; chunk++) {
			for (device = 0; device < kDevices; device++) {
				dataHeader.device = device;
				for (channel = 0; channel < kSampleChannels; channel++) {
					dataHeader.channel = channel;
					dataHeader.count = kDataChunkSize;
					data = [NSMutableData dataWithLength:0];
					[data appendBytes:&dataHeader length:sizeof(DeviceDataHeader)];
					for (sample = 0; sample < kDataChunkSize; sample++) {
						dataValue = chunk * kDataChunkSize + sample;
						[data appendBytes:&dataValue length:sizeof(dataValue)];
					}
					[dataDoc putEvent:@"deviceADData" withData:(Ptr)[data bytes] lengthBytes:[data length]];
					[dataDoc putEvent:@"deviceTimestampData" withData:(Ptr)[data bytes] lengthBytes:[data length]];
				}
			}
		}
#endif

// Lablib events
#ifdef LABLIBEVENTS

		fixWindow.index = index;
		fixWindow.windowDeg.origin.x = index;
		fixWindow.windowDeg.origin.y = index;
		fixWindow.windowDeg.size.height = index;
		fixWindow.windowDeg.size.width = index;
		fixWindow.windowUnits.origin.x = index * 100;
		fixWindow.windowUnits.origin.y = index * 100;
		fixWindow.windowUnits.size.height = index * 100;
		fixWindow.windowUnits.size.width = index * 100;
		[dataDoc putEvent:@"eyeWindow" withData:(Ptr)&fixWindow];
		
		eyeCalibration.offsetSizeDeg = index;
		eyeCalibration.currentOffsetDeg.x = eyeCalibration.currentOffsetDeg.y = index;
		eyeCalibration.targetDeg[0].x = eyeCalibration.targetDeg[0].y = index;
		eyeCalibration.targetDeg[1].x = eyeCalibration.targetDeg[1].y = index + 1;
		eyeCalibration.targetDeg[2].x = eyeCalibration.targetDeg[2].y = index + 2;
		eyeCalibration.targetDeg[3].x = eyeCalibration.targetDeg[3].y = index + 3;
		eyeCalibration.actualUnits[0].x = eyeCalibration.actualUnits[0].y = index * 10;
		eyeCalibration.actualUnits[1].x = eyeCalibration.actualUnits[1].y = index * 10 + 1;
		eyeCalibration.actualUnits[2].x = eyeCalibration.actualUnits[2].y = index * 10 + 2;
		eyeCalibration.actualUnits[3].x = eyeCalibration.actualUnits[3].y = index * 10 + 3;
		eyeCalibration.calibration.m11 = 1100 + index;
		eyeCalibration.calibration.m12 = 1200 + index;
		eyeCalibration.calibration.m21 = 2100 + index;
		eyeCalibration.calibration.m22 = 2200 +index;
		eyeCalibration.calibration.tX = 500 + index;
		eyeCalibration.calibration.tY = -500 - index;
		[dataDoc putEvent:@"eyeCalibration" withData:(Ptr)&eyeCalibration];

		displayParam.frameRateHz = displayParam.pixelBits = index;
		displayParam.widthPix = displayParam.heightPix = index;
		displayParam.CIEx.red = displayParam.CIEx.green = displayParam.CIEx.blue = index;
		displayParam.CIEy.red = displayParam.CIEy.green = displayParam.CIEy.blue = index;
		displayParam.distanceMM = displayParam.widthMM = displayParam.heightMM = index;
		[dataDoc putEvent:@"displayCalibration" withData:(Ptr)&displayParam];
		
#endif
#ifndef DEVICEDATA
#ifdef SPIKES
		for (channel = 0; channel < kSpikeChannels; channel++) {
			timestamp.channel = channel;
			for (j = 0; j < kSpikes; j++) {
				timestamp.time = j;
				[dataDoc putEvent:@"spike" withData:(Ptr)&timestamp];
			}
		}
#endif
#ifdef SAMPLES
		for (channel = 0; channel < kSampleChannels; channel++) {
			ad.channel = channel;
			for (j = 0; j < kSamples; j++) {
				ad.data = j;
				[dataDoc putEvent:@"sample" withData:(Ptr)&ad];
			}
		}
#endif
#endif
		[dataDoc putEvent:@"trialEnd" withData:(Ptr)&index];
	}
#ifdef LABLIBEVENTS
	[dataDoc putEvent:@"fileEnd"];
#endif
	[dataDoc closeDataFile];
}

@end
