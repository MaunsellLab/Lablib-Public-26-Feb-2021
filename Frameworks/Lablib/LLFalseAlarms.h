//
//  LLFalseAlarms.h
//  Lablib
//
//  Created by John Maunsell on 2/26/18.
//

#define kBins       10

@interface LLFalseAlarms : NSObject {
@private
    long n[kBins];                          // number of times a time bin was occupied
    NSString *maxTimeMSKey;
    NSString *minTimeMSKey;
    NSString *responseTimeMSKey;
    long sum[kBins];                        // number of FAs in each time bin
    NSString *tooFastTimeMSKey;
    float validProb[kBins];                 // probability that a FA was inside the response window
}

@property (NS_NONATOMIC_IOSONLY) long maxTimeMS;
@property (NS_NONATOMIC_IOSONLY) long minTimeMS;
@property (NS_NONATOMIC_IOSONLY) long responseTimeMS;
@property (NS_NONATOMIC_IOSONLY) long tooFastTimeMS;
@property (NS_NONATOMIC_IOSONLY) float rate;

- (void)clear;
- (instancetype)initWithMaxMSKey:(NSString *)theMaxKey minMSKey:(NSString *)theMinKey
                    tooFastMSKey:(NSString *)theTooFastKey responseTimeMSKey:(NSString *)theResponseKey;
//- (void)maxTimeMSKey:(NSString *)theKey;
//- (void)minTimeMSKey:(NSString *)theKey;
- (void)setKeyFor:(NSString **)pKey toKey:(NSString *)theKey;
- (void)updateWithResponse:(long)eotCode atTrialTimeMS:(long)trialTimeMS;

@end
