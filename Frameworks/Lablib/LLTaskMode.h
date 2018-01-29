//
//  LLTaskMode.h
//  Experiment
//
//  Created by John Maunsell on Tue Sep 16 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLStandardDataEvents.h"

extern NSString *LLTaskModeChange;

@interface LLTaskMode : NSObject {

    BOOL        dataFileOpen;
    NSString    *key;
    long        mode;
}

@property (NS_NONATOMIC_IOSONLY) BOOL dataFileOpen;
@property (NS_NONATOMIC_IOSONLY, getter=isEnding, readonly) BOOL ending;
@property (NS_NONATOMIC_IOSONLY, getter=isIdle, readonly) BOOL idle;
@property (NS_NONATOMIC_IOSONLY, getter=isStopping, readonly) BOOL stopping;
@property (NS_NONATOMIC_IOSONLY) long mode;
- (void)setDefaults;

@end
