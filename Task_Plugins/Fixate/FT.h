/*
 *  FT.h
 *  Fixate
 *
 *  Created by John Maunsell on 12/25/04.
 *  Copyright 2004. All rights reserved.
 *
 */

#import "FTStimuli.h"

#define    kRewardBit                0x0001
typedef NS_ENUM(unsigned int, FTChannel) {kLeverChannel = 0, kVBLChannel, kFirstSpikeChannel};

// ??? These should be removed

#define     kLeverBit                (0x0001 << kLeverChannel)
#define        kRewardBit                0x0001
#define        kSpikeChannels            2                        // One channels spikes, one channel stim pulses
#define        kSamplePeriodMS            5
#define        kSamplePeriodS            (kSamplePeriodMS / 1000.0)
#define        kTimestampTickMS        1
#define        kMaxHists                8

extern NSString *FTAcquireMSKey;
extern NSString *FTDoFixateKey;
extern NSString *FTDoSoundsKey;
extern NSString *FTFixateJitterPCKey;
extern NSString *FTFixateMSKey;
extern NSString *FTFixWindowWidthDegKey;
extern NSString *FTIntertrialMSKey;
extern NSString *FTRewardMSKey;
extern NSString *FTFixBackColorKey;
extern NSString *FTFixForeColorKey;
extern NSString *FTTaskModeKey;

extern LLTaskPlugIn                *task;
extern LLScheduleController        *scheduler;
extern FTStimuli                *stimuli;
