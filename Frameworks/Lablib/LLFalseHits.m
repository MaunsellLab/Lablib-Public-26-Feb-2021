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
    self.fhFraction= self.faFraction = self.missFraction = 0.0;
    self.fhRate = self.faRate = 0.0;
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
    NSLog(@"minMS: %ld maxMS: %ld responseMS: %ld tooFast: %ld",
                                        self.minTimeMS, self.maxTimeMS, self.responseTimeMS, self.tooFastTimeMS);
    NSLog(@"Taking from %ld to %ld", self.minTimeMS + self.tooFastTimeMS, self.maxTimeMS);
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

// Compute the probability that a FA will be inside the response window. This is used to compute the
// FA rate in updateWithResponse.  The response window start is moved in small steps from minTime to maxTime to
// capture the full range of stimulus onset times (and corresponding reaction window positions).

- (void)loadValidProb;
{
    long bin, windowStartMS, windowEndMS, binStartMS, binEndMS;
    float binOccupancy;
    long startTimeMS = self.minTimeMS + self.tooFastTimeMS;;
    long endTimeMS = self.maxTimeMS;
    float maxOccupancy = (self.maxTimeMS - self.minTimeMS) * (endTimeMS - startTimeMS) / kBins;

    // We're going to convolve the response window with each bin.  The result will be convered to a probability
    // by considering the maximum possible value, corresponding to always being in the response window.  That's
    // equivalent to cover all of the bin (endTimeMS - startTimeMS / kBins) for every step of the integration
    // (self.maxTimeMS - self.minTimeMS).
    
    for (bin = 0; bin < kBins; bin++) {
        binOccupancy = validProb[bin] = 0.0;
        binStartMS = bin * (endTimeMS - startTimeMS) / kBins;
        binEndMS = (bin + 1) * (endTimeMS - startTimeMS) / kBins;
        windowStartMS = MAX(self.minTimeMS, binStartMS - (self.responseTimeMS - self.tooFastTimeMS));
        windowEndMS = windowStartMS + (self.responseTimeMS - self.tooFastTimeMS);
        for ( ; windowStartMS < self.maxTimeMS; windowStartMS++, windowEndMS++) {
            // There are six possible window/bin configurations. One is when the response window is entirely to the
            // left (earlier) than the bin, where it can't contribute to the bin.  We have prevented this condition
            // by starting with the end of the response window aligned to the start of the bin. The second condition
            // is when the response window has gotten to a point where it is entirely to the right of the bin.  Because
            // the window moves to the right, there is nothing left to add to the bin, and we can stop the iterations.
            if (binEndMS < windowStartMS) {
                break;
            }
            // The remaining four four conditionshave the response window straddling the bin, inside the bin, or
            // crossing the start or end of the bin (depending on where it is and whether it is wider or narrower
            // than the bin.  These are all handled by clipping to the portion overlapping the bin.
            binOccupancy += (MIN(binEndMS, windowEndMS) - MAX(binStartMS, windowStartMS));
        }
        validProb[bin] = binOccupancy / maxOccupancy;

        NSLog(@"loadValidProb: %ld %5ld to %5ld ms: binOcc %.0f maxOcc %.0f, %.3f", bin, binStartMS + self.tooFastTimeMS, binEndMS + self.tooFastTimeMS,
            binOccupancy, maxOccupancy, validProb[bin]);
   }
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
    long bin, newBin, startTimeMS, endTimeMS, newStartTimeMS, newEndTimeMS, binTimeMS;
    long tempN[kBins], tempSum[kBins];

    long newMaxMS = [[NSUserDefaults standardUserDefaults] integerForKey:maxTimeMSKey];
    long newMinMS = [[NSUserDefaults standardUserDefaults] integerForKey:minTimeMSKey];
    long newRespTimeMS = [[NSUserDefaults standardUserDefaults] integerForKey:responseTimeMSKey];
    long newTooFastMS = [[NSUserDefaults standardUserDefaults] integerForKey:tooFastTimeMSKey];

    startTimeMS = self.minTimeMS + self.tooFastTimeMS;
    endTimeMS = self.maxTimeMS;
    newStartTimeMS = newMinMS + newTooFastMS;
    newEndTimeMS = newMaxMS;

    if ((newRespTimeMS == self.responseTimeMS && newStartTimeMS == startTimeMS && newEndTimeMS == endTimeMS)
                                                                        || (newEndTimeMS <= newStartTimeMS)) {
        return;
    }
    self.responseTimeMS = newRespTimeMS;
    if (newStartTimeMS == startTimeMS && newEndTimeMS == endTimeMS) {
        [self loadValidProb];
        return;
    }
    [self dumpValues];
    self.minTimeMS = newMinMS;
    self.maxTimeMS = newMaxMS;
    self.tooFastTimeMS = newTooFastMS;
    newStartTimeMS = self.minTimeMS + self.tooFastTimeMS;;
    newEndTimeMS = self.maxTimeMS;

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
    [self loadValidProb];
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
    long bin, oldN, endBin, minTimeMS, maxTimeMS;
    float probBinRelease, probBinFA, probBinFH, probNoFH, probFH, probFA, probNoRelease, sumFH;

    if (eotCode != kEOTCorrect && eotCode != kEOTWrong && eotCode != kEOTFailed) {
        return;
    }
//    if (self.maxTimeMS == 0 || self.minTimeMS  0) {
//        return;
//    }
    minTimeMS = self.minTimeMS + self.tooFastTimeMS;
    maxTimeMS = self.maxTimeMS;
    if (trialTimeMS < minTimeMS || (trialTimeMS >= maxTimeMS && eotCode != kEOTFailed)) {
        return;
    }
    endBin = MIN(kBins, floor(((float)trialTimeMS - minTimeMS) / (maxTimeMS - minTimeMS) * kBins));
    oldN = n[0];
    
    for (bin = 0; bin < endBin; bin++) {
        n[bin]++;
    }
    if (eotCode == kEOTWrong) {
        n[MIN(endBin, kBins - 1)]++;
        sum[MIN(endBin, kBins - 1)]++;
    }
/*
We want to compare ourselves to the nominal correct rate in a psychometric function. That is taken
as the number of corrects divided by the number of corrects plus the number of misses.  So we want a
value that is the inferred FHs relative to some number of misses. To get this, we walk across the bins,
computing the accumlating probability of a release, and for a release, the probability of a FH or FA.
For each bin, the probability of a release is the probability that no release will yet have occurred
(probNoRelease) times the rate of FA for that bin (sum[bin] / n[bin], grossed up for the fact that some
releases were undetected because they were FH (as given by the probability in validProb[bin]). The
 probNoRelease for the next bin is simply the fraction lost to FH and FA in the current bin.
*/
    sumFH = probFH = probFA = 0.0;
    probNoFH = probNoRelease = 1.0;
    for (bin = 0; bin < kBins; bin++) {
        if (n[bin] > 5 && n[bin] - sum[bin] > 0) {                 // enough data?
            probBinRelease = probNoRelease * (float)sum[bin] / n[bin] / (1.0 - validProb[bin]);
            probBinFH = probBinRelease * validProb[bin];
            probBinFA = probBinRelease - probBinFH;
            probFH = 1.0 - (1.0 - probFH) * (1.0 - probBinFH);
            probFA = 1.0 - (1.0 - probFA) * (1.0 - probBinFA);
            sumFH += sum[bin] * probBinRelease * validProb[bin];
        }
        else {                                                  // not enough data, skip to next bin
            probBinRelease = 0.0;
        }
//        NSLog(@"bin %ld: probFH: %.3f, probFA: %.3f, probNoRelease %.3f, probBinRelease %.3f probBinFH %.3f probBinFA %.3f",
//              bin, probFH, probFA, probNoRelease, probBinRelease, probBinFH, probBinFA);
        probNoRelease = MAX(0.0, probNoRelease - probBinRelease);   // probability of entering next bin;
    }
    self.faFraction = probFA;
    self.fhFraction = probFH;
    self.missFraction = probNoRelease;
    self.fhRate = probFH  / (probFH + probNoRelease);  // FHs divided by FH + misses
    self.faRate = probFA  / (probFA + probNoRelease);  // FHs divided by FH + misses
}

@end
