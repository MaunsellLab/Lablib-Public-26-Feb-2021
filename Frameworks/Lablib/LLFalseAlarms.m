//
//  LLFalseAlarms.m
//  Lablib
//
//  Created by John Maunsell on 2/26/18.
/*
 Estimates the false alarm rate.  Assumes that the reaction time is controlled by four parameters:
    minTime -- earliest time in the trial when a valid stimulus can appear
    maxTime -- lastest time in the trial when a valid stimulus can appear
    tooFastTime -- the minimum allowable RT; earlier responses are considered wrong
    responseTime -- the RT window
 The method assumes that stimuli onsets are uniformly distributed betwen minTime and maxTime.  It monitors the
 number of false alarms that occur during the interval that can contain valid responses and false alarms
 (minTime + tooFastTime to maxTime -- there can be no false alarms beyond maxTime).  It compiles a rate of FAs
 as a function of time.  It also computes the probability that a guess during a bin in that interval would be
 scored as correct (i.e., the probability that the response window overlies the bin).  The FA  rate is the
 probabilitiest sum of the FA rate times the probability that a guess would be scored as correct.  Thus, the
 rate should approximate the lower asymptote on the psychometric function (gamma).

 The method monitors the four parameters (which are handed to the initializer as NSString *keys to entries in
 [NSUserDefaults standardUserDefaults].  If these parameters change, LLFalseAlarm will rebin, transferring the old
 data to any overlapping bins, and discarding the rest.

 Note that the FA rate returned generally won't correspond closely to the percentage of early (kEOTWrong) trials.
 Those typically include in their count responses that occur before any time in the trial. This code is specifically
 directed at estimating the fraction of trials on which the animal produced a false alarm that could have been
 counted as a correct.  It should generally be compared to the percentage correct.
*/

#import "LLFalseAlarms.h"
#import "LLStandardDataEvents.h"

@implementation LLFalseAlarms

- (void)clear;
{
    long index;

    for (index = 0; index < kBins; index++) {
        n[index] = sum[index] = 0;
    }
    self.rate = 0.0;
}

- (void)dealloc
{
    [self removeObserverForKey:maxTimeMSKey];
    [self removeObserverForKey:minTimeMSKey];
    [self removeObserverForKey:responseTimeMSKey];
    [self removeObserverForKey:tooFastTimeMSKey];
    [super dealloc];
}

- (void)dumpValues;
{
    NSLog(@"rate: %.2f; Taking from %ld to %ld", self.rate, self.minTimeMS + self.tooFastTimeMS, self.maxTimeMS);
    NSLog(@"minMS: %ld maxMS: %ld responseMS: %ld tooFast: %ld", self.minTimeMS, self.maxTimeMS, self.responseTimeMS, self.tooFastTimeMS);
    NSLog(@"n:    %5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld", n[0], n[1], n[2], n[3], n[4], n[5], n[6], n[7], n[8], n[9]);
    NSLog(@"sum:  %5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld\n", sum[0], sum[1], sum[2], sum[3], sum[4], sum[5], sum[6], sum[7], sum[8], sum[9]);
    NSLog(@"prob: %5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f\n", validProb[0], validProb[1], validProb[2], validProb[3], validProb[4], validProb[5], validProb[6], validProb[7], validProb[8], validProb[9]);
}

- (instancetype)initWithMaxMSKey:(NSString *)theMaxKey minMSKey:(NSString *)theMinKey
                    tooFastMSKey:(NSString *)theTooFastKey responseTimeMSKey:(NSString *)theResponseKey
;
{
    if ((self = [super init]) != nil) {
        [self clear];
        [self setKeyFor:&maxTimeMSKey toKey:theMaxKey];
        [self setKeyFor:&minTimeMSKey toKey:theMinKey];
        [self setKeyFor:&responseTimeMSKey toKey:theResponseKey];
        [self setKeyFor:&tooFastTimeMSKey toKey:theTooFastKey];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change
                       context:(void *)context;
{
    NSString *key = keyPath.pathExtension;

    if ([key isEqualTo:maxTimeMSKey] || [key isEqualTo:minTimeMSKey] || [key isEqualTo:responseTimeMSKey]
                                                || [key isEqualTo:tooFastTimeMSKey]) {
        [self rebin];
    }
}

- (void)removeObserverForKey:(NSString *)theKey;
{
    if (theKey != nil) {
        [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self
                    forKeyPath:[NSString stringWithFormat:@"values.%@", theKey]];
    }
}

// When one of the key time changes, we need to create new bins.  In doing so, we try to transfer data
// from any existing bins that will overlap with the new bins.

- (void)rebin;
{
    long bin, binOffset, newBin, startTimeMS, endTimeMS, newStartTimeMS, newEndTimeMS, binTimeMS;
    long respWindowStart, respWindowEnd, tempN[kBins], tempSum[kBins];

    long newMaxMS = [[NSUserDefaults standardUserDefaults] integerForKey:maxTimeMSKey];
    long newMinMS = [[NSUserDefaults standardUserDefaults] integerForKey:minTimeMSKey];
    long newRespTimeMS = [[NSUserDefaults standardUserDefaults] integerForKey:responseTimeMSKey];
    long newTooFastMS = [[NSUserDefaults standardUserDefaults] integerForKey:tooFastTimeMSKey];

    [self dumpValues];
    startTimeMS = self.minTimeMS + self.tooFastTimeMS;
    endTimeMS = self.maxTimeMS;
    newStartTimeMS = newMinMS + newTooFastMS;
    newEndTimeMS = newMaxMS;

    if ((newStartTimeMS == startTimeMS && newEndTimeMS == endTimeMS) || (newEndTimeMS <= newStartTimeMS)) {
        return;
    }
    for (bin = 0; bin < kBins; bin++) {
        tempN[bin] = tempSum[bin] = 0;
    }
    for (bin = 0; bin < kBins; bin++) {
        binTimeMS = startTimeMS + (bin + 0.5) * (endTimeMS - startTimeMS) / kBins;
        if (binTimeMS < newStartTimeMS || binTimeMS >= newEndTimeMS) {
            continue;
        }
        newBin = floor(((float)binTimeMS - newStartTimeMS) / (newEndTimeMS - newStartTimeMS) * kBins);
        tempN[newBin] += n[bin];
        tempSum[newBin] += sum[bin];
    }
    for (bin = 0; bin < kBins; bin++) {
        n[bin] = tempN[bin];
        sum[bin] = tempSum[bin];
    }
    self.minTimeMS = newMinMS;
    self.maxTimeMS = newMaxMS;
    self.responseTimeMS = newRespTimeMS;
    self.tooFastTimeMS = newTooFastMS;
    [self dumpValues];

    // Compute the probability that a FA will be inside the response window. This is used to compute the
    // FA rate that is computed by updateWithResponse.

    for (bin = 0; bin < kBins; bin++) {
        binTimeMS = newStartTimeMS + (bin + 0.5) * (newEndTimeMS - newStartTimeMS) / kBins;
        for (binOffset = validProb[bin] = 0; binOffset < kBins; binOffset++) {       // offset the response window
            respWindowStart = newStartTimeMS + binOffset * (newMaxMS - newStartTimeMS) / (kBins);
            respWindowEnd = respWindowStart + MAX(newRespTimeMS, ((float)newMaxMS - newStartTimeMS) / kBins);
            if (binTimeMS > respWindowStart && binTimeMS <= respWindowEnd) {
                validProb[bin] += 1.0 / kBins;
            }
        }
    }
}

- (void)setKeyFor:(NSString **)pKey toKey:(NSString *)theKey;
{
    [self removeObserverForKey:*pKey];
    [*pKey release];
    [theKey retain];
    *pKey = theKey;
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
                                        forKeyPath:[NSString stringWithFormat:@"values.%@", *pKey]
                                        options:NSKeyValueObservingOptionNew context:nil];
}

- (void)updateWithResponse:(long)eotCode atTrialTimeMS:(long)trialTimeMS;
{
    long bin, endBin, minTimeMS, maxTimeMS;
    float newRate;

    if (eotCode != kEOTCorrect && eotCode != kEOTWrong && eotCode != kEOTFailed) {
        return;
    }
    if (self.maxTimeMS == 0 || self.minTimeMS == 0) {
        return;
    }
    minTimeMS = self.minTimeMS + self.tooFastTimeMS;
    maxTimeMS = self.maxTimeMS;
    if (trialTimeMS < minTimeMS || (trialTimeMS >= maxTimeMS && eotCode != kEOTFailed)) {
        return;
    }
    endBin = (eotCode == kEOTFailed) ? kBins :
                        floor(((float)trialTimeMS - minTimeMS) / (maxTimeMS - minTimeMS) * kBins);
    for (bin = 0; bin < endBin; bin++) {
        n[bin]++;
    }
    if (eotCode == kEOTWrong) {     // Wrong (FA): increment FA count
        sum[endBin]++;
        n[endBin]++;
    }
    // Overall FA rate is taken as the sum of the bin probabilities that there will be a spontaneous release
    // times the probability that the bin will fall on the response window
    newRate = 1.0;
    for (bin = 0; bin < kBins; bin++) {
        if (n[bin] > 0) {
            newRate *= 1.0 - ((float)sum[bin] / n[bin] * validProb[bin]); // rate times probability in response window
        }
    }
    self.rate = 1.0 - newRate;
    [self dumpValues];
}

@end
