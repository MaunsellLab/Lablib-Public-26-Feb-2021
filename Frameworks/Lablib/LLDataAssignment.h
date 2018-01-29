//
//  LLDataAssignment.h
//  Lablib
//
//  Created by John Maunsell on 12/22/05.
//  Copyright 2005. All rights reserved.
//

typedef NS_ENUM(unsigned int, LLDataAssignmentType) {kLLSampleData, kLLTimestampData, kLLAssignmentTypes};

@interface LLDataAssignment : NSObject {

    long channel;
    long device;
    NSString *name;
    long type;
    long groupIndex;
}

- (long)channel;
- (long)device;
@property (NS_NONATOMIC_IOSONLY, readonly) long groupIndex;
- (instancetype)initWithName:(NSString *)theName channel:(long)theChannel device:(long)theDevice 
            type:(long)theType groupIndex:(long)index;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
- (void)setChannel:(NSNumber *)newChannel;
- (void)setDevice:(NSNumber *)newDevice;
@property (NS_NONATOMIC_IOSONLY, readonly) long type;

@end
