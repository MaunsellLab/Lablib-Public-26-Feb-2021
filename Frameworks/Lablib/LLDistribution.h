/*
 *  LLDistribution.h
 *  Lablib
 *  
 *  Protocol specifying required methods for a statistical distribution
 *
 *  Created by John Maunsell on Fri Sep 24 2004.
 *  Copyright (c) 2004. All rights reserved.
 *
 */

typedef NS_ENUM(unsigned int, LLErrorBarType) {kStandardError, kConfidence95};

#define kConfidence68        kStandardError
#define k68ErrorCriterion    ((1.0 - 0.6826) / 2.0)

@protocol LLDistribution

- (void)addValue:(double)value;
- (void)clear;
@property (NS_NONATOMIC_IOSONLY, readonly) double lowerError;
@property (NS_NONATOMIC_IOSONLY, readonly) double mean;
@property (NS_NONATOMIC_IOSONLY, readonly) double n;
@property (NS_NONATOMIC_IOSONLY, readonly) double se;
- (void)setErrorType:(long)errorType;
@property (NS_NONATOMIC_IOSONLY, readonly) double std;
- (void)subtractValue:(double)value;
@property (NS_NONATOMIC_IOSONLY, readonly) double upperError;
@property (NS_NONATOMIC_IOSONLY, readonly) double var;

@end
