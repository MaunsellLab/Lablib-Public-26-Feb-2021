//
//  LLFalseHits.m
//  Lablib
//
//  Created by John Maunsell on 2/26/18.
/*
 Estimates the false hit rate.  False alarms are all early responses, whether a stimulus has been presented or not.
 In distinction, false hits are response that occur without a stimulus during the period when they are counted as a
 hit.  An estimate of false hits must takeinto account four parameters:
    minTime -- earliest time in the trial when a valid stimulus can appear
    maxTime -- lastest time in the trial when a valid stimulus can appear
    tooFastTime -- the minimum allowable RT; earlier responses are considered wrong
    responseTime -- the RT window
 The method assumes that stimuli onsets are uniformly distributed betwen minTime and maxTime.  It monitors the
 number of false alarms that occur during the interval that can contain valid responses and false alarms
 (minTime + tooFastTime to maxTime -- there can be no false alarms beyond maxTime).  It compiles a rate of FAs
 as a function of time.  It also computes the probability that a guess during a bin in that interval would be
 scored as correct (i.e., the probability that the response window overlies the bin).  The FH  rate is the
 probabilitiest sum of the response rate times the probability that that response would be scored as correct.  Thus,
 the rate should approximate the lower asymptote on the psychometric function (gamma).  There will be some distortion
 of the estimate if the reaction time window is long compared to the min to max period (because FAs can't be measured
 in the RT window after the maxStimTime.

 The method monitors the four parameters (which are handed to the initializer as NSString *keys to entries in
 [NSUserDefaults standardUserDefaults].  If these parameters change, LLFalseAlarm will rebin, transferring the old
 data to any overlapping bins, and discarding the rest.

 The FH rate  returned is an estimate of FH / (FH + Miss), which should be directly comparable to the standard
 measure of Hits (Hits / Hits+Miss). Note that the FH rate returned generally won't correspond closely to the
 percentage of early (kEOTWrong) trials. Those typically include in their count responses that occur before any
 time in the trial. This code is specifically directed at estimating the fraction of trials on which the animal
 produced a false alarm that could have been counted as a correct.  It should generally be compared to the
 percentage correct.
*/

#import "LLFalseHits.h"
#import "LLStandardDataEvents.h"

@implementation LLFalseHits

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
    NSLog(@"minMS: %ld maxMS: %ld responseMS: %ld tooFast: %ld",
                                        self.minTimeMS, self.maxTimeMS, self.responseTimeMS, self.tooFastTimeMS);
    NSLog(@"n:    %5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld",
                                        n[0], n[1], n[2], n[3], n[4], n[5], n[6], n[7], n[8], n[9]);
    NSLog(@"sum:  %5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld%5ld\n",
                                        sum[0], sum[1], sum[2], sum[3], sum[4], sum[5], sum[6], sum[7], sum[8], sum[9]);
    NSLog(@"prob: %5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f%5.2f\n",
                                        validProb[0], validProb[1], validProb[2], validProb[3], validProb[4],
                                        validProb[5], validProb[6], validProb[7], validProb[8], validProb[9]);
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
    // FA rate that is computed by updateWithResponse.  The response window start is moved in uniform
    // steps from minTime to maxTime, although we are monitoring minTime+tooFast to maxTime.

    for (bin = 0; bin < kBins; bin++) {
        binTimeMS = newStartTimeMS + (bin + 0.5) * (newEndTimeMS - newStartTimeMS) / kBins;
        for (binOffset = validProb[bin] = 0; binOffset < kBins; binOffset++) {       // offset the response window
            respWindowStart = newMinMS + binOffset * (newMaxMS - newMinMS) / (kBins);
            respWindowEnd = respWindowStart + MAX(newRespTimeMS, ((float)newMaxMS - newStartTimeMS) / kBins)
                        - newTooFastMS;         // NB: We expect tooFastMS to be deducted from the response window
            if (binTimeMS > respWindowStart && binTimeMS <= respWindowEnd) {
                validProb[bin] += 1.0 / kBins;
            }
            NSLog(@"%ld %ld: %ld -- %ld to %ld, %.2f", bin, binOffset, binTimeMS, respWindowStart, respWindowEnd, validProb[bin]);
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
    float newRate, newRespondRate;

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
    endBin = MIN(kBins, floor(((float)trialTimeMS - minTimeMS) / (maxTimeMS - minTimeMS) * kBins));
    for (bin = 0; bin < endBin; bin++) {
        n[bin]++;
    }
    if (eotCode == kEOTWrong) {
        sum[MIN(endBin, kBins - 1)]++;
        n[MIN(endBin, kBins - 1)]++;
    }

    // We want to compare ourselves to the nominal correct rate in a psychometric function.  That is taken
    // as the number of corrects divided by the number of corrects plus the number of misses.  So we want a
    // value that is the inferred FHs relative to some number of misses.  To get this, we work out the probability
    // of getting a response on a trial with no stimulus (newResponseRate), which gives us the number of misses
    // (when subtracted from one).  We also get the number of FHs by multiplying each bin's response rate
    // by the probability that the response will occur in a reaction time window (validProb).

    newRate = 1.0;                                              // invert probability for multiplying
    newRespondRate = 1.0;
    for (bin = 0; bin < kBins; bin++) {
        if (n[bin] > 0) {
            newRespondRate *= 1.0 - ((float)sum[bin] / n[bin]);             // rate of response
            newRate *= 1.0 - ((float)sum[bin] / n[bin] * validProb[bin]);   // rate * probability in response window
        }
    }
    newRespondRate = 1.0 - newRespondRate;  // re-invert to real rates
    newRate = 1.0 - newRate;
    self.rate = newRate  / (1.0 - (newRespondRate - newRate));  // FHs divided by FH + misses

    [self dumpValues];
}

@end
