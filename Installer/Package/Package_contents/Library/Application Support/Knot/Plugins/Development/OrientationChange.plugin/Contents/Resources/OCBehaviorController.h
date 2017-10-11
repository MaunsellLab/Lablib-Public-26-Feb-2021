//
//  OCBehaviorController.h
//  OrientationChange
//
//  Copyright (c) 2006. All rights reserved.
//

#include "OC.h"

#define kEOTs				(kEOTIgnored + 2)				// Plot EOT types up to ignored, + 1 for probes
#define kEOTProbeCorrect	(kEOTIgnored + 1)
#define kMaxRT				1000

extern NSString *OCBehaviorWindowVisibleKey;

@interface OCBehaviorController : LLScrollZoomWindow {

	BlockStatus		blockStatus;
	NSView			*documentView;
    LLHistView		*hist[kMaxOriChanges];
	NSColor 		*highlightColor;
    long			highlightedPointIndex;
	long			highlightedPlotIndex;
	LLViewScale		*histScaling;
    NSMutableArray	*labelArray;
	BlockStatus		lastBlockStatus;
	long			lastMaxTargetTimeMS;
	long			lastMinTargetTimeMS;
	long			maxTargetTimeMS;
	long			minTargetTimeMS;
    NSMutableArray	*performance[kLocations][kEOTs];		// an array of LLBinomDist
    NSMutableArray	*performanceByTime[kLocations][kEOTs];	// an array of LLBinomDist
    LLPlotView		*perfPlot[kLocations];
    LLPlotView		*perfTimePlot[kLocations];
    LLPlotView		*reactPlot[kLocations];
    NSMutableArray	*reactTimes[kLocations];				// an array of LLNormDist
    NSMutableArray	*reactTimesInvalid[kLocations];			// an array of LLNormDist
    long			responseTimeMS;
    double			rtDist[kLocations][kMaxOriChanges][kMaxRT];
	long			saccadeStartTimeMS;
	unsigned long	stimStartTimeMS;
	unsigned long	targetOnTimeMS;
    NSMutableArray	*timeLabelArray;
	TrialDesc		trial;
    NSMutableArray	*xAxisLabelArray;
}

- (void)changeResponseTimeMS;
- (void)checkTimeParams;
- (void)checkParams;
- (LLHistView *)initHist:(LLViewScale *)scale data0:(double *)data0 data1:(double *)data1;
- (void)makeLabels;
- (void)makeTimeLabels;
- (void)positionPlots;
- (void)reset:(NSData *)eventData eventTime:(NSNumber *)eventTime;

@end
