//
//  LLTaskStatus.h
//
//  Created by John Maunsell on Tue Sep 16 2003.
//  Copyright (c) 2005. All rights reserved.
//

#import <Lablib/LLStandardDataEvents.h>

@interface LLTaskStatus : NSObject {

    BOOL        dataFileOpen;
    long        mode;
}

@property (NS_NONATOMIC_IOSONLY) BOOL dataFileOpen;
@property (NS_NONATOMIC_IOSONLY, getter=isEnding, readonly) BOOL ending;
@property (NS_NONATOMIC_IOSONLY, getter=isIdle, readonly) BOOL idle;
@property (NS_NONATOMIC_IOSONLY, getter=isStopping, readonly) BOOL stopping;
@property (NS_NONATOMIC_IOSONLY) long mode;
@property (NS_NONATOMIC_IOSONLY, readonly) long status;

@end
