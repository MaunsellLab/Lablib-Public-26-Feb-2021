//
//  OCSummaryController.h
//  Experiment
//
//  Copyright (c) 2006. All rights reserved.
//

#import "OC.h"
#import "OCStateSystem.h"

@interface OCSummaryController : LLScrollZoomWindow {

    double				accumulatedRunTimeS;
	BlockStatus			blockStatus;
	long				dayComputer;			// Count of trials with computer certification errors
	long				dayEOTs[kEOTTypes];
    long				dayEOTTotal;
    NSDictionary		*fontAttr;
    NSDictionary		*labelFontAttr;
    NSDictionary		*leftFontAttr;
	long 				lastEOTCode;
    double				lastStartTimeS;
    long				myDayEOTTotal;
	long				myDayEOTs[kMyEOTTypes];
    long				myRecentEOTs[kMyEOTTypes];
    long				myRecentEOTTotal;
    BOOL				newTrial;
	long				recentComputer;			// Count of trials with computer certification errors
    long				recentEOTs[kEOTTypes];
    long				recentEOTTotal;
	StimParams			stimParams;
    long 				oriChangeIndex;
	TrialDesc			trial;

    IBOutlet			LLEOTView *dayPlot;
    IBOutlet			LLEOTHistoryView *eotHistory;
    IBOutlet			NSTableView *percentTable;
    IBOutlet			LLEOTView *recentPlot;
    IBOutlet			NSTableView *trialTable;
}

- (NSDictionary *)makeAttributesForFont:(NSFont *)font alignment:(NSTextAlignment)align tailIndex:(float)indent;
- (id)percentTableColumn:(NSTableColumn *)tableColumn row:(long)row;
- (id)trialTableColumn:(NSTableColumn *)tableColumn row:(long)row;

@end
