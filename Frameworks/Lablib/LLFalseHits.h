//
//  LLFalseHits.h
//  Lablib
//
//  Created by John Maunsell on 2/26/18.
//

#define kBins       10

@interface LLFalseHits : NSObject {
@private
    NSString *maxTimeMSKey;
    NSString *minTimeMSKey;
    float n[kBins];                           // number of time bin was occupied
    long  numCorr;
    long  numCorrLate;
    long  numMissed;
    long  numTrialsEarly;
    long  numTrials;
    float probBinFA[kBins];
    float probBinFH[kBins];
    float probBinRelease[kBins];
    NSString *responseTimeMSKey;
    float sumFA[kBins];                     // number of FAs in each time bin
    NSString *tooFastTimeMSKey;
    float validProb[kBins];                 // probability that a FA was inside the response window
}

@property (NS_NONATOMIC_IOSONLY) float corrFraction;
@property (NS_NONATOMIC_IOSONLY) float faFraction;
@property (NS_NONATOMIC_IOSONLY) float faRate;
@property (NS_NONATOMIC_IOSONLY) float fhFraction;
@property (NS_NONATOMIC_IOSONLY) float fhRate;
@property (NS_NONATOMIC_IOSONLY) long maxTimeMS;
@property (NS_NONATOMIC_IOSONLY) long minTimeMS;
@property (NS_NONATOMIC_IOSONLY) float missFraction;
@property (NS_NONATOMIC_IOSONLY) long responseTimeMS;
@property (NS_NONATOMIC_IOSONLY) long tooFastTimeMS;

- (void)clear;
- (void)dumpValues;
- (instancetype)initWithMaxMSKey:(NSString *)theMaxKey minMSKey:(NSString *)theMinKey
                    tooFastMSKey:(NSString *)theTooFastKey responseTimeMSKey:(NSString *)theResponseKey;
- (void)setKeyFor:(NSString **)pKey toKey:(NSString *)theKey;
- (void)updateWithResponse:(long)eotCode atTrialTimeMS:(long)trialTimeMS;

@end
