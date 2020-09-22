//
//  LLStateSystem.h
//  Lablib
//
//  Created by John Maunsell on Sat Mar 29 2003.
//  Copyright (c) 2006. All rights reserved.
//

#import <Lablib/LLState.h>
#import <Lablib/LLStateSystemController.h>

@interface LLStateSystem : NSObject {

    LLStateSystemController *controller;
    NSMutableDictionary        *states;
}

- (void)addState:(LLState *)state;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL running;
- (void)setStartState:(LLState *)start andStopState:(LLState *)stop;
- (BOOL)startWithCheckIntervalMS:(double)checkMS;
- (LLState *)stateNamed:(NSString *)name;
- (void)stop;

@end
