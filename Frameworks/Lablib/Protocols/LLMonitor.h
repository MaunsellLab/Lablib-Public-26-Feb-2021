/*
 *  LLMonitor.h
 *  Lablib
 *  
 *  Protocol specifying required methods for object that can make reports
 *
 *  Created by John Maunsell on Fri Apr 18 2003.
 *  Copyright (c) 2003. All rights reserved.
 *
 */

extern NSString *LLMonitorUpdated;

@protocol LLMonitor <NSObject>

@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *IDString;
@property (NS_NONATOMIC_IOSONLY, getter=isConfigurable, readonly) BOOL configurable;
- (void)configure;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSAttributedString *report;

@end
