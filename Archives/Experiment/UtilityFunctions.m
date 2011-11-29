//
//  UtilityFunctions.m
//  Experiment
//
//  Created by John Maunsell on Fri Apr 04 2003.
//  Copyright (c) 2003. All rights reserved.
//

//#import "Experiment.h"
#import "UtilityFunctions.h"

#define kC50Squared			0.4
#define kDrivenRate			40.0
#define kSpontRate			5.0

void announceEvents(void) {

    long lValue;
	float fValue;
	char *idString = "Experiment Version 1.1";
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
 	[dataDoc putEvent:@"text" withData:idString lengthBytes:strlen(idString)];
 	[dataDoc putEvent:@"displayCalibration" withData:[stimulusWindow displayParameters]];

    lValue = [defaults integerForKey:stimTypeKey];
	[dataDoc putEvent:@"stimulusType" withData:&lValue];
	[dataDoc putEvent:@"contrastStimParams" withData:(Ptr)getStimParams(kVisualStimulus)];
	[dataDoc putEvent:@"gabor" withData:(Ptr)[stimulusWindow->gabor gaborData]];
	[dataDoc putEvent:@"currentStimParams" withData:(Ptr)getStimParams(kElectricalStimulus)];
    fValue = [defaults floatForKey:frequencyKey];
	[dataDoc putEvent:@"frequencyHz" withData:(Ptr)&fValue];
    lValue = [defaults integerForKey:pulseWidthUSKey];
	[dataDoc putEvent:@"pulseWidthUS" withData:&lValue];
    lValue = [defaults integerForKey:uAPerVKey];
	[dataDoc putEvent:@"uAPerV" withData:&lValue];
    fValue = kITC18DAVoltageRangeV;
	[dataDoc putEvent:@"voltageRangeV" withData:(Ptr)&fValue];
    lValue = [defaults integerForKey:preIntervalMSKey];
	[dataDoc putEvent:@"preIntervalMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:intervalMSKey];
	[dataDoc putEvent:@"intervalMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:gapMSKey];
	[dataDoc putEvent:@"gapMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:postIntervalMSKey];
	[dataDoc putEvent:@"postStimuliMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:responseTimeMSKey];
	[dataDoc putEvent:@"responseTimeMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:tooFastMSKey];
	[dataDoc putEvent:@"tooFastTimeMS" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:triesKey];
	[dataDoc putEvent:@"tries" withData:(Ptr)&lValue];
    lValue = [defaults integerForKey:blockLimitKey];
	[dataDoc putEvent:@"blockLimit" withData:(Ptr)&lValue];
}

StimParams *getStimParams(long stimType) {

	static StimParams params;
	
	switch (stimType) {
	case kVisualStimulus:
		params.levels = [[NSUserDefaults standardUserDefaults] integerForKey:contrastsKey];
		params.maxValue = [[NSUserDefaults standardUserDefaults] floatForKey:maxContrastKey];
		params.factor = [[NSUserDefaults standardUserDefaults] floatForKey:contrastFactorKey];
		break;
	case kElectricalStimulus:
		params.levels = [[NSUserDefaults standardUserDefaults] integerForKey:currentsKey];
		params.maxValue = [[NSUserDefaults standardUserDefaults] floatForKey:maxCurrentKey];
		params.factor = [[NSUserDefaults standardUserDefaults] floatForKey:currentFactorKey];
		break;
	}
	return &params;
}

void requestReset(void) {

    if ([taskMode isIdle]) {
        reset();
    }
    else {
        resetFlag = YES;
    }
}

void reset(void) {

    long resetType = 0;
    
	[dataDoc putEvent:@"reset" withData:&resetType];
}

double spikeRateFromStimValue(double normalizedValue) {

	double vSquared;
	
	vSquared = normalizedValue * normalizedValue;
	return kDrivenRate *  vSquared / (vSquared + kC50Squared) + kSpontRate;
}

StimTrainData *stimTrainParameters(double amplitudeUA) {

	static StimTrainData data;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	data.amplitudeUA = amplitudeUA;
	data.DAChannel = [defaults integerForKey:DAChannelKey];
	data.doGate = [defaults boolForKey:doGateKey];
	data.doPulseMarkers = [defaults boolForKey:doMarkerPulsesKey];
	data.durationMS = [defaults integerForKey:intervalMSKey];
	data.frequencyHZ = [defaults floatForKey:frequencyKey];
	data.fullRangeV = kITC18DAVoltageRangeV;
	data.gateBit = [defaults integerForKey:gateBitKey];
	data.pulseMarkerBit = [defaults integerForKey:markerPulseBitKey];
	data.pulseWidthUS = [defaults integerForKey:pulseWidthUSKey];
	data.UAPerV = [defaults integerForKey:uAPerVKey];
	
	return &data;
}

double valueFromIndex(long index, StimParams *pStimParams) {

	if (index < 0 || index >= pStimParams->levels) {
		return 0.0;
	}
	return	exp(log(pStimParams->maxValue) + log(pStimParams->factor) * 
									(pStimParams->levels - index - 1));
}
