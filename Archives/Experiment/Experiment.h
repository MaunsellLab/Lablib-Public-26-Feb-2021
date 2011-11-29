/*
 *  Experiment.h
 *  Experiment
 *
 *  Created by John Maunsell on Sat Feb 01 2003.
 *  Copyright (c) 2003. All rights reserved.
 *
 */

// We need the following definition, even if the non-ITC18 version is being built

#ifndef USE_ITC
#define kITC18DAVoltageRangeV  10.24
#endif

#import "StimWindow.h"
#import "StateSystem.h"

#ifdef MAIN
#define EXTERN
#else
#define EXTERN	extern 
#endif

// The following should be changed to be unique for each application

enum {kLeverChannel = 0, kVBLChannel, kFirstSpikeChannel};
enum {kFirstInterval = 0, kSecondInterval};
enum {kVisualStimulus = 0, kElectricalStimulus, kStimTypes};

#define 	kLeverBit				(0x0001 << kLeverChannel)
#define		kRewardBit				0x0001
#define		kSpikeChannels			2						// One channels spikes, one channel stim pulses
#define		kSamplePeriodMS			5
#define		kTimestampTickMS		1

#define 	kMaxLevels				16
#define		kMaxHists				16

typedef struct {
	long	levels;				// number of active stimulus levels
	float   maxValue;			// maximum stimulus value
	float   factor;				// factor between values
} StimParams;

#ifndef	NoGlobals

// Preferences dialog

extern NSString *doDataDirectoryKey;

// Behavior settings dialog

extern NSString *acquireMSKey;
extern NSString *blockLimitKey;
extern NSString *fixateKey;
extern NSString *fixSpotSizeKey;
extern NSString *fixWindowWidthKey;
extern NSString *intertrialMSKey;
extern NSString *nontargetContrastKey;
extern NSString *respSpotSizeKey;
extern NSString *responseTimeMSKey;
extern NSString *respWindowWidthKey;
extern NSString *respWindow0AziKey;
extern NSString *respWindow0EleKey;
extern NSString *respWindow1AziKey;
extern NSString *respWindow1EleKey;
extern NSString *rewardKey;
extern NSString *saccadeTimeMSKey;
extern NSString *soundsKey;
extern NSString *tooFastMSKey;
extern NSString *triesKey;

// Stimulus settings dialog

extern NSString *stimTypeKey;

extern NSString *gapMSKey;
extern NSString *intervalMSKey;
extern NSString *postIntervalMSKey;
extern NSString *preIntervalMSKey;

extern NSString *azimuthDegKey;
extern NSString *elevationDegKey;
extern NSString *kdlPhiDegKey;
extern NSString *kdlThetaDegKey;
extern NSString *orientationDegKey;
extern NSString *radiusDegKey;
extern NSString *sigmaDegKey;
extern NSString *spatialFreqCPDKey;
extern NSString *spatialPhaseDegKey;
extern NSString *temporalFreqHzKey;

extern NSString *contrastFactorKey;
extern NSString *contrastsKey;
extern NSString *maxContrastKey;

extern NSString *currentsKey;
extern NSString *currentFactorKey;
extern NSString *DAChannelKey;
extern NSString *frequencyKey;
extern NSString *gateBitKey;
extern NSString *doGateKey;
extern NSString *pulseWidthUSKey;
extern NSString *markerPulseBitKey;
extern NSString *doMarkerPulsesKey;
extern NSString *maxCurrentKey;
extern NSString *uAPerVKey;

EXTERN NSPoint					currentEyeDeg;
EXTERN LLDataDoc				*dataDoc;					// LLDataDoc for data events
EXTERN id<LLIODevice>			dataSource;
EXTERN NSUserDefaults			*defaults;					// User default values
EXTERN LLEyeCalibrator			*eyeCalibration;
EXTERN LLMonitorController		*monitorController;
EXTERN BOOL						resetFlag;
EXTERN NSMutableDictionary		*settings;
EXTERN id<LLStimTrainDevice>	stimTrainDevice;			// Device for electrical stimulation 
EXTERN BOOL						stimulusOn;					// Flag for stimulus being displayed
EXTERN StimWindow 				*stimulusWindow;			// Stimulus window object
EXTERN LLSynthIODevice			*synthDataSource;
EXTERN LLTaskMode				*taskMode;
EXTERN LLTrialBlock				*trialBlock;

#endif
