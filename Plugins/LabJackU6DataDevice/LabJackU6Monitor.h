//
//  LabJackU6Monitor.h
//  Lablib
//
//  Copyright (c) 2016. All rights reserved.
//

#import "LabJackU6MonitorSettings.h"
#import <Lablib/LLMonitor.h>
#import <Lablib/LLIODevice.h>

extern NSString	*doWarnDriftKey;
extern NSString	*driftLimitKey;

typedef struct {
	double	cumulativeTimeMS;							// duration of sequence based on CPU clock
	long	samples;									// number of sample sets collected
    double	samplePeriodMS;								// period for one sample set
    long 	sequences;
} LabJackU6MonitorValues;

@interface  LabJackU6Monitor : NSObject <LLMonitor> {
@private
	BOOL						alarmActive;
	LabJackU6MonitorValues 		cumulative;
	NSString					*descriptionString;				// First line in report
	NSString					*IDString;						// Short string for menu entry
	LabJackU6MonitorValues 		previous;
	double						samplePeriodMS;
	double						sequenceStartTimeMS;			// start of current sequence
	LabJackU6MonitorSettings	*settings;
}

- (void)doAlarm:(NSString *)message;
- (void)initValues:(LabJackU6MonitorValues *)pValues;
- (id)initWithID:(NSString *)ID description:(NSString *)description;
- (void)resetCounters;
- (void)sequenceValues:(LabJackU6MonitorValues)current;
- (NSString *)valueString:(LabJackU6MonitorValues *)pValues;
- (NSString *)uniqueKey:(NSString *)commonKey;

@end


