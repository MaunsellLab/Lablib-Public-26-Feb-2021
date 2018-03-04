/*
  LLFalseHits.m
  Lablib

  Created by John Maunsell on 2/26/18.

 Estimates the false hit (FH) rate. As opposed to false alarms (FA), which include all early responses, false hits are
 responses that occur without a stimulus during a period when they are counted as a hit (H). Thus, the number of
 corrects is the sum of the false hits and true hits.  If the FA rate is high, a susbtantial fraction of H can be FH.
 Estimating the FH is a little involved.  It is influenced by four parameters:
    minTime -- earliest time in a trial when a valid stimulus can appear (relative to trial start)
    maxTime -- lastest time in the trial when a valid stimulus can appear (relative to trial start)
    tooFastTime -- the minimum allowable RT; earlier responses are considered wrong (relative to stimulus onset)
    responseTime -- the response window (relative to stimulus onset)

 The reaction time window is positioned relative to stimulus onset, and has a length of responseTime - tooFastTime
 (i.e., the end of the valid response time is responseTime past stimulus onset).

 The relationship of trial outcomes (H, miss (M), FA) relative to stimulus onset and trial timing parameters is
 straightforward.  The relationship to trial outcomes and trial times (independent of stimulus onset) is less often
 considered, but is important for estimating FH rate:

    t < minTime + tooFastTime -- are responses are FA
    t >= minTime + tooFastTime && t <= maxTime -- response might be a FA, FH, TH or M
    t > maxTime && t <= maxTime + responseTime -- response might be a FH, TH or M
    t > maxTime + responseTime -- all responses are M

 Obviously, there is no point in exploring responses beyond maxTime + responseTime (which are generally excluded
 from data collection in any case.  We also exclude responses < minTime + tooFastTime.  While a FA rate can by
 computed in this interval, that FA rate doesn't affect performace measures, and there is little reason to believe
 that this early FA rate remain stationary throughout trials (given that they are invariably unrewarded).

 FAs cannot be detected during the period between maxTime and maxTime + responseTime, so it cannot contributed to the
 estimate of FH rate. If FH rate were to increase greatly with time, and there were many Hs in this late period, then
 an estimate based on earlier intervals will underestimate the FH rate. This distortion will also happen if maxTime
 is very short relative to responseTime.  However, in most cases a rising FH rate means that relatively few trials
 get to maxTime, so the number of Hs beyond maxTime will not be large.  A falling FH is not a concern for the same
 reason.

 Given the above considerations, the FH rate is estimated using the trial period starting at minTime + tooFastTime
 and ending at maxTime. For high-performing subjects this period will be much greater than maxTime. The approach
 assumes that stimuli onsets are uniformly distributed betwen minTime and maxTime. Departures from uniformity will
 matter only if the FA rate varies appreciably over this period.

 We count the number of FA binned over time (sumFA[kBins]) and the number of times that any trial included the entirety
 of each bin (n[kBins]). We also compute the probability that a spontanous response in each bin would be a FH
 (validProb[kBins]).  While this latter probability is approximately MIN(1, responseTimeMS/(maxTime - minTime), it
 differs importantly.  Spontaneous responses at minTime+1 are almost never FHs, because that requires that the
 stimulus time be precisely at minTime.  The probability ramps up over the bins that span minTime to
 minTime + responseTime.  validProb can be used to estimate the number of FH, but not using sumFH/n directly.  The
 latter term is the FA rate, not the response rate, because some responses are FH and not counted in sumFA.  The
 response rate is obtained by correcting this term for this: (sumFH/n)/(1.0 - validProb).  This release rate is
 multiplied by validProb to estimate the FH rate.

 The -updateWithResponse method is used to supply the responses.  Each time a response is received, the FH rate is
 updated using an algorithm that sums the probability of a FH across all the bins.  Each bin's contribution is the
 product of 1) the probability that no response has occurred before that bin, 2) the probability of a response in that
 bin, and 3) the probability that a response would be counted as a H.  The estimated FH rate should approximate the
 lower asymptote on the psychometric function (gamma).

 The FH rate  returned is an estimate of FH / (FH + Miss), which should be directly comparable to the standard
 measure of Hits (Hits / Hits+Miss), and equivalent to the lower asymptote on a psychometric function (gamma).
 Note that the FH rate returned generally won't correspond closely to the  percentage of early (kEOTWrong) trials.
 Those typically include in their count responses that occur before any time in the trial. This code is specifically
 directed at estimating the fraction of trials on which the animal produced a false alarm that could have been
 counted as a correct.  It should generally be compared to the percentage correct.

 LLFalseHits monitors the four parameters (which are handed to the initializer as NSString *keys to entries in
 [NSUserDefaults standardUserDefaults].  If these parameters change, LLFalseAlarm will rebin, transferring the old
 data to any overlapping bins, and discarding the rest.
*/

#import "LLFalseHits.h"
#import "LLStandardDataEvents.h"

@implementation LLFalseHits

- (void)clear;                                          // Flush all counters, e.g. when changing subjects
{
    long index;

    for (index = 0; index < kBins; index++) {
        n[index] = sumFA[index] = 0.0;
    }
    numCorr = numMissed = numTrials = 0.0;
    self.fhFraction= self.faFraction = self.missFraction = self.corrFraction = 0.0;
    self.fhRate = self.faRate = 0.0;
}

- (void)dealloc;
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
    NSLog(@"prob:    %@", [self makeValuesString:validProb withFormat:@"%5.2f"]);
    NSLog(@"n:       %@", [self makeValuesString:n withFormat:@"%5.0f"]);
    NSLog(@"sumFA:   %@", [self makeValuesString:sumFA withFormat:@"%5.0f"]);
    NSLog(@"FA:      %@", [self makeValuesString:probBinFA withFormat:@"%5.2f"]);
    NSLog(@"FH:      %@", [self makeValuesString:probBinFH withFormat:@"%5.2f"]);
    NSLog(@"Rel.:    %@", [self makeValuesString:probBinRelease withFormat:@"%5.2f"]);
}

- (instancetype)initWithMaxMSKey:(NSString *)theMaxKey minMSKey:(NSString *)theMinKey
                    tooFastMSKey:(NSString *)theTooFastKey responseTimeMSKey:(NSString *)theResponseKey;
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

// Compute the probability that a FA will be inside the response window. This is used by -updateResponse to compute
// the FA rate.  The response window start is moved in small steps from minTime to maxTime to capture the full range of
// stimulus onset times (and corresponding reaction window positions).

- (void)loadValidProb;
{
    long bin, windowStartMS, windowEndMS, binStartMS, binEndMS;
    float binOccupancy;
    long startTimeMS = self.minTimeMS + self.tooFastTimeMS;;
    long endTimeMS = self.maxTimeMS;
    float maxOccupancy = (self.maxTimeMS - self.minTimeMS) * (endTimeMS - startTimeMS) / kBins;

    // We're going to convolve the response window with each bin.  The result will be converted to a probability
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
            // left (earlier) than the bin, where it can't contribute to the bin. We have eliminated this condition
            // by starting with windowEndMS aligned to the start of the bin. A second condition is when the response
            // window is entirely to the right of the bin.  Because the window moves to the right, there is nothing
            // left we stop iterating:
            if (binEndMS < windowStartMS) {
                break;
            }
            // The remaining four four conditionshave the response window straddling the bin, inside the bin, or
            // crossing the start or end of the bin (depending on where it is and whether it is wider or narrower
            // than the bin.  These are all handled by taking the union with the bin.
            binOccupancy += (MIN(binEndMS, windowEndMS) - MAX(binStartMS, windowStartMS));
        }
        validProb[bin] = binOccupancy / maxOccupancy;
//
//        NSLog(@"loadValidProb: %ld %5ld to %5ld ms: binOcc %.0f maxOcc %.0f, %.3f", bin, binStartMS + self.tooFastTimeMS, binEndMS + self.tooFastTimeMS,
//            binOccupancy, maxOccupancy, validProb[bin]);
   }
}

// Compose strings for -dumpValues

- (NSString *)makeValuesString:(float *)values withFormat:(NSString *)format;
{
    long bin;
    NSMutableString *s = [[[NSMutableString alloc] init] autorelease];

    for (bin = 0; bin < kBins; bin++) {
        [s appendString:[NSString stringWithFormat:format, values[bin]]];
    }
    return s;
}

// Respond to changes in trial timing

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
        tempSum[newBin] += sumFA[bin];
    }
    for (bin = 0; bin < kBins; bin++) {
        n[bin] = tempN[bin];
        sumFA[bin] = tempSum[bin];
    }
    self.minTimeMS = newMinMS;
    self.maxTimeMS = newMaxMS;
    self.responseTimeMS = newRespTimeMS;
    self.tooFastTimeMS = newTooFastMS;
    [self loadValidProb];
}

- (void)setKeyFor:(NSString **)pKey toKey:(NSString *)theKey;
{
    [self removeObserverForKey:*pKey];
    [*pKey release];
    [theKey retain];
    *pKey = theKey;
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self
        forKeyPath:[NSString stringWithFormat:@"values.%@", *pKey] options:NSKeyValueObservingOptionNew context:nil];
}

// Update the FH rate with the outcome from a trial

- (void)updateWithResponse:(long)eotCode atTrialTimeMS:(long)trialTimeMS;
{
    long bin, endBin, minTimeMS, maxTimeMS;
    float probNoFH, probFH, probFA, probNoRelease, sumFH;

    if (eotCode != kEOTCorrect && eotCode != kEOTWrong && eotCode != kEOTFailed) {
        return;
    }
    minTimeMS = self.minTimeMS + self.tooFastTimeMS;
    maxTimeMS = self.maxTimeMS;
    if (trialTimeMS < minTimeMS) {
        return;
    }
    endBin = MIN(kBins, floor(((float)trialTimeMS - minTimeMS) / (maxTimeMS - minTimeMS) * kBins));
    for (bin = 0; bin < endBin; bin++) {            // increment all bins we passed through
        n[bin]++;
    }
    numTrials++;                                    // increment the trial count
    switch (eotCode) {                              // increment outcome counts
        case kEOTFailed:
            numMissed++;
            break;
        case kEOTCorrect:
            numCorr++;
            break;
        case kEOTWrong:
            n[MIN(endBin, kBins - 1)]++;
            sumFA[MIN(endBin, kBins - 1)]++;
            break;
        default:
            break;
    }
/*
We want to compare ourselves to the nominal correct rate in a psychometric function. That is taken
as the number of corrects divided by the number of corrects plus the number of misses.  We want a
value that is the inferred FHs relative to some number of misses. To get this, we walk across the bins,
computing the accumlating probability of a release, and for a release, the probability of a FH or FA.
For each bin, the probability of a release is the probability that no release will yet have occurred
(probNoRelease) times the rate of FA for that bin (sumFA[bin] / n[bin], grossed up for the fact that some
releases were undetected because they were FH (as given by the probability in validProb[bin]). The
 probNoRelease for the next bin is simply the fraction lost to FH and FA in the current bin.
*/
    sumFH = probFH = probFA = 0.0;
    probNoFH = probNoRelease = 1.0;
    for (bin = 0; bin < kBins; bin++) {
        if (n[bin] > 5 && n[bin] - sumFA[bin] > 0) {                        // enough data?
            probBinRelease[bin] = probNoRelease * sumFA[bin] / n[bin] / (1.0 - validProb[bin]);
            probBinFH[bin] = probBinRelease[bin] * validProb[bin];
            probBinFA[bin] = probBinRelease[bin] - probBinFH[bin];
            probFH = 1.0 - (1.0 - probFH) * (1.0 - probBinFH[bin]);
            probFA = 1.0 - (1.0 - probFA) * (1.0 - probBinFA[bin]);
            sumFH += sumFA[bin] * probBinRelease[bin] * validProb[bin];
            probNoRelease = MAX(0.0, probNoRelease - probBinRelease[bin]);  // probability of entering next bin;
        }
        else {                                                              // not enough data, skip to next bin
            probBinRelease[bin] = 0.0;
        }
    }
    self.missFraction = (float)numMissed / numTrials;                       // probability of a miss;
    self.corrFraction = (float)numCorr / numTrials;                         // probability of correct;
    self.faFraction = probFA;
    self.fhFraction = probFH;
    self.fhRate = self.fhFraction  / (self.fhFraction +  self.missFraction);  // FHs divided by FH + misses
    self.faRate = self.faFraction  / (self.faFraction +  self.missFraction);  // FHs divided by FH + misses
}

@end
