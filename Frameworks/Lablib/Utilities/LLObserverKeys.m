//
//  LLObserverKeys.m
//  Created by John Maunsell on 1/7/18.
//
// Intended to standardize and simplify adding and removing LLTaskPlugin as an observer of key values.  Eventually
// this class might want to maintain a dictionary of what is and is not observed, but we really shouldn't need that
// if this class is used correctly.

#import "LLObserverKeys.h"

@implementation LLObserverKeys

- (void)addObserver:(id)observer forKey:(NSString *)keyPath alreadyLocked:(BOOL)preLocked;
{
    if (!preLocked) {
        [self.observerLock lock];
    }
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:observer
                                                  forKeyPath:[NSString stringWithFormat:@"values.%@", keyPath]
                                                  options:NSKeyValueObservingOptionNew context:nil];
    [self.observerLock unlock];
}

- (void)addObserver:(id)observer forKey:(NSString *)keyPath;
{
    [self addObserver:observer forKey:keyPath alreadyLocked:NO];
}

- (void)addObserver:(id)observer forKeys:(NSString **)keyPaths alreadyLocked:(BOOL)preLocked;
{
    long index;

    if (!preLocked) {
        [self.observerLock lock];
    }
    for (index = 0; keyPaths[index] != nil; index++) {
        [[NSUserDefaultsController sharedUserDefaultsController] addObserver:observer
                                                  forKeyPath:[NSString stringWithFormat:@"values.%@", keyPaths[index]]
                                                  options:NSKeyValueObservingOptionNew context:nil];
    }
    [self.observerLock unlock];
}

- (void)addObserver:(id)observer forKeys:(NSString **)keyPaths;
{
    [self addObserver:(id)observer forKeys:(NSString **)keyPaths alreadyLocked:NO];
}

- (void)dealloc;
{
    self.observerLock = nil;
    [super dealloc];
}

- (instancetype)init;
{
    if (self = [super init]) {
        _observerLock = [[NSLock alloc] init];
    }
    return self;
}

- (void)removeObserver:(id)observer forKeys:(NSString **)keyPaths leaveLocked:(BOOL)keepLock;
{
    long index;

    [self.observerLock lock];
    for (index = 0; keyPaths[index] != nil; index++) {
        [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:observer
                        forKeyPath:[NSString stringWithFormat:@"values.%@", keyPaths[index]]];
    }
    if (!keepLock) {
        [self.observerLock unlock];
    }
}

- (void)removeObserver:(id)observer forKeys:(NSString **)keyPaths;
{
    [self removeObserver:observer forKeys:keyPaths leaveLocked:NO];
}

- (void)removeObserver:(id)observer forKey:(NSString *)keyPath leaveLocked:(BOOL)keepLock;
{
    [self.observerLock lock];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:observer
                                        forKeyPath:[NSString stringWithFormat:@"values.%@", keyPath]];
    if (!keepLock) {
        [self.observerLock unlock];
    }
}

- (void)removeObserver:(id)observer forKey:(NSString *)keyPath;
{
    [self removeObserver:observer forKey:keyPath leaveLocked:NO];
}


@end
