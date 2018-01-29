//
//  LLTrialBlock.h
//  Lablib
//
//  Created by John Maunsell on Sat Dec 27 2003.
//  Copyright (c) 2003. All rights reserved.
//

@interface LLTrialBlock : NSObject {

@protected
    long            blocks;                // number of blocks to do
    long            blocksDone;            // number of blocks completed
    long            currentTrialIndex;
    long            triesCount;
    long            trialsPerBlock;
    long            trialsRemainingCurrentBlock;
    long            *trials;
}

@property (NS_NONATOMIC_IOSONLY) long blocks;
@property (NS_NONATOMIC_IOSONLY, readonly) long blocksDone;
@property (NS_NONATOMIC_IOSONLY, readonly) long blocksRemaining;
- (void)countCurrentTrial:(BOOL)correct;
@property (NS_NONATOMIC_IOSONLY, readonly) long currentTrialIndex;
- (instancetype)initWithTrialCount:(long)trialNum triesCount:(long)repeats blockCount:(long)blockCount;
- (void)newBlock;
@property (NS_NONATOMIC_IOSONLY, readonly) long nextTrialIndex;
- (void)reset;
- (void)setTrialCount:(long)count;
- (void)setTriesCount:(long)count;
@property (NS_NONATOMIC_IOSONLY, readonly) long trialsDoneCurrentBlock;
@property (NS_NONATOMIC_IOSONLY, readonly) long trialsPerBlock;
@property (NS_NONATOMIC_IOSONLY, readonly) long trialsRemaining;
@property (NS_NONATOMIC_IOSONLY, readonly) long trialsRemainingCurrentBlock;

@end
