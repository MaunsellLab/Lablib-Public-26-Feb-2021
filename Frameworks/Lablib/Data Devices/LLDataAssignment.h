//
//  LLDataAssignment.h
//  Lablib
//
//  Created by John Maunsell on 12/22/05.
//  Copyright 2005. All rights reserved.
//

typedef NS_ENUM(unsigned int, LLDataAssignmentType) {kLLSampleData, kLLTimestampData, kLLAssignmentTypes};

@interface LLDataAssignment : NSObject {

}

@property (NS_NONATOMIC_IOSONLY) long channel;
@property (NS_NONATOMIC_IOSONLY) long device;
@property (NS_NONATOMIC_IOSONLY) long groupIndex;
@property (NS_NONATOMIC_IOSONLY, copy) NSString *name;
@property (NS_NONATOMIC_IOSONLY) long type;

//- (long)channel;
//- (long)device;
- (instancetype)initWithName:(NSString *)theName channel:(long)theChannel device:(long)theDevice
            type:(long)theType groupIndex:(long)index;
- (void)setChannelWithNSNumber:(NSNumber *)newChannel;
- (void)setDeviceWithNSNumber:(NSNumber *)newDevice;

@end
