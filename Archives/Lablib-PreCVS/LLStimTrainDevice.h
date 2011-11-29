/*
 *  LLStimTrainDevice.h
 *  Lablib
 *  
 *  Protocol specifying required methods for an electrical stimulus train object
 *
 *  Created by John Maunsell on Fri Apr 18 2003.
 *  Copyright (c) 2003. All rights reserved.
 *
 */

typedef struct {
	float   amplitudeUA;
	long	DAChannel;
	BOOL	doPulseMarkers;
	BOOL	doGate;
	long	durationMS;
	float   frequencyHZ;
	float   fullRangeV;
	long	gateBit;
	long	pulseMarkerBit;
	long	pulseWidthUS;
	float   UAPerV;
} StimTrainData;

@protocol LLStimTrainDevice <NSObject>

- (BOOL)setTrainParameters:(StimTrainData *)pTrain;
- (void)stimulate;

@end