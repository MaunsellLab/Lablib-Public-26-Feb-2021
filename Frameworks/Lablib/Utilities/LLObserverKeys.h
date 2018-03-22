//
//  LLObserverKeys.h
//
//  Created by John Maunsell on 1/7/18.
//

#ifndef LLObserverKeys_h
#define LLObserverKeys_h

@interface LLObserverKeys : NSObject {

}

@property (NS_NONATOMIC_IOSONLY, retain) NSLock *observerLock;

- (void)addObserver:(id)observer forKey:(NSString *)keyPath alreadyLocked:(BOOL)preLocked;
- (void)addObserver:(id)observer forKey:(NSString *)keyPath;
- (void)addObserver:(id)observer forKeys:(NSString **)keyPaths alreadyLocked:(BOOL)preLocked;
- (void)addObserver:(id)observer forKeys:(NSString **)keyPaths;
- (void)removeObserver:(id)observer forKey:(NSString *)keyPath leaveLocked:(BOOL)keepLock;
- (void)removeObserver:(id)observer forKey:(NSString *)keyPath;
- (void)removeObserver:(id)observer forKeys:(NSString **)keyPaths leaveLocked:(BOOL)keepLock;
- (void)removeObserver:(id)observer forKeys:(NSString **)keyPaths;

@end

#endif /* LLObserverKeys_h */
