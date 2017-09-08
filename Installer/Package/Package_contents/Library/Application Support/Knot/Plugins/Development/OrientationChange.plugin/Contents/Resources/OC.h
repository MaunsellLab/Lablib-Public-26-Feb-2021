/*
 *  OC.h
 *  OrientationChange
 *
 *  Copyright (c) 2006. All rights reserved.
 *
 */

#ifdef MAIN
#define EXTERN
#else
#define EXTERN	extern 
#endif

#define kPI          		(atan(1) * 4)
#define k2PI         		(atan(1) * 4 * 2)
#define kRadiansPerDeg      (kPI / 180.0)
#define kDegPerRadian		(180.0 / kPI)

// The following should be changed to be unique for each application

enum {kAttend0 = 0, kAttend1, kLocations};
enum {kLinear = 0, kLogarithmic};
enum {kUniform = 0, kExponential};
enum {kAuto = 0, kManual};
enum {kRewardFixed = 0, kRewardVariable};
enum {kNullStim = 0, kValidStim, kTargetStim, kFrontPadding, kBackPadding};
enum {kMyEOTCorrect = 0, kMyEOTMissed, kMyEOTEarlyToValid, kMyEOTEarlyToInvalid, kMyEOTBroke, 
				kMyEOTIgnored, kMyEOTQuit, kMyEOTTypes};

#define		kMaxOriChanges			12

typedef struct {
	long	levels;				// number of active stimulus levels
	float   maxValue;			// maximum stimulus value (i.e., direction change in degree)
	float   minValue;			// minimum stimulus value
} StimParams;

typedef struct StimDesc {
	long	index;
	long	stimOnFrame;
	long	stimOffFrame;
	short	stim0Type;
	short	stim1Type;
	float	contrast0PC;
	float	contrast1PC;
	float	direction0Deg;
	float	direction1Deg;
	float	orientationChangeDeg;
} StimDesc;

typedef struct TrialDesc {
	BOOL	instructTrial;
	BOOL	validTrial;
	BOOL	catchTrial;
	long	attendLoc;
	long	correctLoc;
	long	numCycles;
	long	targetIndex;				// index (count) of cycle of target in stimulus sequence
	long	targetOnTimeMS;				// time from first stimulus (start of stimlist) to the target
	float	temporalFreqHz;
	long	framesPerCycle;
	long	orientationChangeIndex;
	float	orientationChangeDeg;
} TrialDesc;

typedef struct BlockStatus {
	long	changes;
	float	orientationChangeDeg[kMaxOriChanges];
	float	validReps[kMaxOriChanges];
	long	validRepsDone[kMaxOriChanges];
	float	invalidReps[kMaxOriChanges];
	long	invalidRepsDone[kMaxOriChanges];
	long	instructDone;			// number of instruction trials left to do
	long	instructTrials;			// number of instruction trials left to do
	long	sidesDone;				// number of sides (out of kLocations) done
	long	blockLimit;				// number of blocks before stopping
	long	blocksDone;				// number of blocks completed
} BlockStatus;

// put parameters set in the behavior controller

typedef struct BehaviorSetting {
	long	blocks;
	long	intertrialMS;
	long	acquireMS;
	long	fixGraceMS;
	long	fixateMS;
	long	fixateJitterPC;
	long	responseTimeMS;
	long	tooFastMS;
	long	minSaccadeDurMS;
	long	breakPunishMS;
	long	rewardSchedule;
	long	rewardMS;
	float	fixWinWidthDeg;
	float	respWinWidthDeg;
} BehaviorSetting;

// put parameters set in the Stimulus controller

typedef struct StimSetting {
	float	temporalFreqHz;
	long	stimLeadMS;
	float	stimSpeedHz;
	long	stimDistribution;
	long	minTargetOnTimeMS;
	long	meanTargetOnTimeMS;
	long	maxTargetOnTimeMS;
	float	eccentricityDeg;
	float	polarAngleDeg;
	float	driftDirectionDeg;
	float	contrastPC;
	short	numberOfSurrounds;
	long	changeScale;
	long	orientationChanges;
	float	maxChangeDeg;
	float	minChangeDeg;
	long	changeRemains;
} StimSetting;


#ifndef	NoGlobals

// Behavior settings dialog

extern NSString *OCAcquireMSKey;
extern NSString *OCBlockLimitKey;
extern NSString *OCBreakPunishMSKey;
extern NSString *OCCatchTrialPCKey;
extern NSString *OCCueMSKey;
extern NSString *OCChageScaleKey;
extern NSString *OCDoSoundsKey;
extern NSString *OCFixateKey;
extern NSString *OCFixateMSKey;
extern NSString *OCFixGraceMSKey;
extern NSString *OCFixJitterPCKey;
extern NSString *OCFixWindowWidthDegKey;
extern NSString *OCIntertrialMSKey;
extern NSString *OCInstructionTrialsKey;
extern NSString *OCInvalidRewardFactorKey;
extern NSString *OCMaxTargetMSKey;
extern NSString *OCMinTargetMSKey;
extern NSString *OCMeanTargetMSKey;
extern NSString *OCNontargetContrastPCKey;
//extern NSString *OCNumInstructTrialsKey;
extern NSString *OCRespSpotSizeDegKey;
extern NSString *OCRespTimeMSKey;
extern NSString *OCRespWindowWidthDegKey;
extern NSString *OCRewardMSKey;
extern NSString *OCRewardScheduleKey;
extern NSString *OCSaccadeTimeMSKey;
extern NSString *OCStimDistributionKey;
extern NSString *OCStimRepsPerBlockKey;
extern NSString *OCTooFastMSKey;

// Stimulus settings dialog

extern NSString *OCStimDurationMSKey;
extern NSString *OCStimJitterPCKey;
extern NSString *OCChangeScaleKey;
extern NSString *OCOrientationChangesKey;
extern NSString *OCMaxDirChangeDegKey;
extern NSString *OCMinDirChangeDegKey;
extern NSString *OCChangeRemainKey;
extern NSString *OCChangeArrayKey;

extern NSString *OCDistContrastPCKey;
extern NSString *OCKdlPhiDegKey;
extern NSString *OCKdlThetaDegKey;
extern NSString *OCRadiusDegKey;
extern NSString *OCSeparationDegKey;
extern NSString *OCSpatialFreqCPDKey;
extern NSString *OCSpatialPhaseDegKey;
extern NSString *OCTemporalFreqHzKey;

extern NSString *OCChangeKey;
extern NSString *OCInvalidRepsKey;
extern NSString *OCValidRepsKey;

long		argRand;

#import "OCStimuli2.h"
@class OCDigitalOut;

long							attendLoc;
BlockStatus						blockStatus;
BehaviorSetting					behaviorSetting;
BOOL							brokeDuringStim;
OCDigitalOut					*digitalOut;
BOOL							resetFlag;
LLScheduleController			*scheduler;
OCStimuli2						*stimuli;

#endif

LLTaskPlugIn					*task;


