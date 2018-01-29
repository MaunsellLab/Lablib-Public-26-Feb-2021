//
//  FTEndtrialState.m
//  Fixate Task
//
//  Created by John Maunsell on Thu May 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "FTEndtrialState.h"

@implementation FTEndtrialState

- (void)doJuiceOff;
{
    [task.dataController digitalOutputBitsOn:kRewardBit];
}

- (void)stateAction {

    long trialCertify;
    NSSound *juiceSound;
    
    [stimuli erase];
    [task.dataDoc putEvent:@"fixOff"];
    
// The computer may have failed to create the display correctly.  We check that now
// If the computer failed, the monkey will still get rewarded for correct trial,
// but the trial will be done over.  Other computer checks can be added here.

    trialCertify = 0;
    switch (eotCode) {
    case kEOTCorrect:
        [task.dataController digitalOutputBitsOff:kRewardBit];
        [scheduler schedule:@selector(doJuiceOff) toTarget:self withObject:Nil 
            delayMS:[[NSUserDefaults standardUserDefaults] integerForKey:FTRewardMSKey]];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoSoundsKey]) {
            juiceSound = [NSSound soundNamed:kCorrectSound];
            if (juiceSound.playing) {   // won't play again if it's still playing
                [juiceSound stop];
            }
            [juiceSound play];            // play juice sound
        }
        break;
    case kEOTWrong:
    default:
        if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoSoundsKey]) {
            [[NSSound soundNamed:kNotCorrectSound] play];
        }
        break;
    }
    [task.dataDoc putEvent:@"trialCertify" withData:(void *)&trialCertify];
    [task.dataDoc putEvent:@"trialEnd" withData:(void *)&eotCode];
    [task.synthDataDevice setSpikeRateHz:2.5 atTime:[LLSystemUtil getTimeS]];
    [task.synthDataDevice setEyeTargetOff];
    [task.synthDataDevice doLeverUp];
    if (task.mode == kTaskStopping) {                        // Requested to stop
        task.mode = kTaskIdle;
    }
}

- (NSString *)name {

    return @"Endtrial";
}

- (LLState *)nextState {

    if (task.mode == kTaskIdle) {
        return [task.stateSystem stateNamed:@"Idle"];
    }
    else {
        return [task.stateSystem stateNamed:@"Intertrial"];
    }
}

@end
