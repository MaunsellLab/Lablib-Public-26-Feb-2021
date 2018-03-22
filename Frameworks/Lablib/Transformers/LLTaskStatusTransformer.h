//
//  LLTaskStatusTransformer.h
//  Lablib
//
//  Created by John Maunsell on 12/28/04.
//  Copyright 2004. All rights reserved.
//

// An LLTaskStatusTransformer can be set to perform several different
// transformations  on the value stored by LLTaskStatus.

typedef NS_ENUM(unsigned int, LLTaskStatusFlag) {kLLTaskStatusIdle,        // Return BOOL for task mode is idle
        kLLTaskStatusIdleAndNoFile,        // Return BOOL for idle and no data file open
        kLLTaskStatusNoFile};

@interface LLTaskStatusTransformer:NSValueTransformer {

    long type;
}

- (void)setTransformerType:(long)newType;

@end
