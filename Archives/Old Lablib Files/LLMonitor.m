//
//  LLMonitor.m
//  Lablib
//
//  Created by John Maunsell on Wed Jan 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLMonitor.h"
#import "LLSystemUtil.h"

#define kRangeMinLimitS	-0.010
#define kRangeMaxLimitS	0.010

static MonitorValues currentValues;
static MonitorValues lastValues;
static MonitorValues cumulativeValues;
static double lastTime = 0;					// last time an event occurred

@implementation LLMonitor

- (void)dealloc {

	[identifier release];
	[super dealloc];
}

- (id)init {

    if ((self = [super init]) != Nil) {
		[self initValues:&currentValues];
		[self initValues:&cumulativeValues];
		currentValues.rangeMinS = cumulativeValues.rangeMinS = kRangeMinLimitS;
		currentValues.rangeMaxS = cumulativeValues.rangeMaxS = kRangeMaxLimitS;
		lastTime = 0.0;
		identifier = [[NSString alloc] initWithString:@"LLMonitor"];
	}
    return self;
}

- (void)initValues:(MonitorValues *)pValues {

    pValues->n = pValues->sum = pValues->sumsq = 0.0;
    pValues->overRange = pValues->underRange = 0.0;
    pValues->minValue = 1e100;
    pValues->maxValue = -1e100;
}

// Record the occurence of an event.  This is the method that should be called 
// when the event being monitored occurs.

- (void)recordEvent {

    double currentTime, deltaTime;
    
    currentTime = [LLSystemUtil getTimeS];			// get the time now
    if (lastTime != 0) {
        deltaTime = currentTime - lastTime;
		[self updateValues:&currentValues newValue:deltaTime];
		[self updateValues:&cumulativeValues newValue:deltaTime];
    }
    lastTime = currentTime;
}

- (NSString *)report {

	NSMutableString *textString;

	textString = [[[NSMutableString alloc] init] autorelease];

	[textString appendString:[NSString stringWithFormat:@"%@:\n\n", identifier]];
	if (cumulativeValues.n == 0) {
		[textString appendString:@"n = 0\n"];
	}
	else {
		[textString appendString:@"   Cumulative: "];
		[textString appendString:[self valueString:&cumulativeValues]];
	}
	if (lastValues.n > 0) {
		[textString appendString:@"   Last Period: "];
		[textString appendString:[self valueString:&lastValues]];
	}
	return [NSString stringWithString:textString];
}

- (void)reset {

	lastValues = currentValues;
	[self initValues:&currentValues];
    lastTime = 0.0;
	[[NSNotificationCenter defaultCenter] postNotificationName:LLReportUpdated object:self];
}

- (void)setIdentifier:(NSString *)newID {

	[newID retain];
	[identifier release];
	identifier = newID;
}

- (void)updateValues:(MonitorValues *)pValues newValue:(double)newValue {

	double meanTime;
	
	pValues->n += 1.0;
	pValues->sum += newValue;
	pValues->sumsq += newValue * newValue;
	pValues->maxValue = MAX(pValues->maxValue, newValue);
	pValues->minValue = MIN(pValues->minValue, newValue);
	meanTime = pValues->sum / pValues->n;
	if (newValue > meanTime + pValues->rangeMaxS) {
		pValues->overRange += 1.0;
	}
	if (newValue < meanTime + pValues->rangeMinS) {
		pValues->underRange += 1.0;
	}
}

- (NSString *)valueString:(MonitorValues *)pValues {

	return [NSString  stringWithFormat:
		@"n = %.0lf mean = %.2lf max = %.2lf (%.0lf %.0lf over mean) min = %.2lf (%.0lf %.0lf under mean)\n\n", 
		pValues->n, pValues->sum / pValues->n * 1000.0, pValues->maxValue * 1000.0, pValues->overRange,
		pValues->rangeMaxS * 1000.0, pValues->minValue * 1000.0, pValues->underRange, pValues->rangeMaxS * 1000.0];
}

@end
