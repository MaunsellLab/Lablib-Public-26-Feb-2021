/*
OCStimuli2.h
*/

#import "OC.h"

@interface OCStimuli : NSObject {

	BOOL					abortStimuli;
	DisplayParam			display;
	long					durationMS;
	float					fixSizePix;
	LLFixTarget				*fixSpot;
	BOOL					fixSpotOn;
	NSArray					*fixTargets;
	LLGabor 				*gabor1;
	LLGabor 				*gabor0;
	LLIntervalMonitor 		*monitor;
	short					selectTable[kMaxOriChanges];
	NSMutableArray			*stimList;
	BOOL					stimulusOn;
	BOOL					targetPresented;
}

- (void)doFixSettings;
- (void)doGabor0Settings;
- (void)doGabor1Settings;
- (void)presentStimSequence;
- (void)dumpStimList;
- (void)erase;
- (LLGabor *)gabor0;
- (LLGabor *)gabor1;
- (LLGabor *)gaborWithIndex:(long)index;
- (LLGabor *)initGabor;
- (void)loadGaborsWithStimDesc:(StimDesc *)pSD;
- (void)makeStimList:(TrialDesc *)pTrial;
- (LLIntervalMonitor *)monitor;
- (void)setFixSpot:(BOOL)state;
- (void)shuffleStimListFrom:(short)start count:(short)count;
- (void)startStimSequence;
- (BOOL)stimulusOn;
- (void)stopAllStimuli;
- (BOOL)targetPresented;

@end
