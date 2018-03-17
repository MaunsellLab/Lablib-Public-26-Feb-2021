//
//  LLDataAssignment.m
//  Lablib
//
//  Created by John Maunsell on 12/22/05.
//  Copyright 2005. All rights reserved.
//

#import "LLDataAssignment.h"

@implementation LLDataAssignment

//- (long)channel;
//{
//    return channel;
//}
//
- (void)dealloc;
{
    [self.name release];
    [super dealloc];
}

- (NSString *)description;
{
    return [NSString stringWithFormat:@"%@: name %@; device %ld; channel %ld; type %ld; groupIndex %ld", 
        [self class], self.name, self.device, self.channel, self.type, self.groupIndex];
}

//- (long)device;
//{
//    return device;
//}
//
//- (long)groupIndex;
//{
//    return groupIndex;
//}
//
- (instancetype)initWithName:(NSString *)theName channel:(long)theChannel device:(long)theDevice 
            type:(long)theType groupIndex:(long)index;
{
    if (self = [super init]) {
        [theName retain];                       // must retain because must use variable name in init, not setter
        _name = theName;
        _device = theDevice;
        _channel = theChannel;
        _type = theType;
        _groupIndex = index;
    }
    return self;
}

//- (NSString *)name;
//{
//    return name;
//}
//
- (void)setChannelWithNSNumber:(NSNumber *)newChannel;
{
    self.channel = newChannel.intValue;
}

- (void)setDeviceWithNSNumber:(NSNumber *)newDevice;
{
    self.device = newDevice.intValue;
}

//- (long)type;
//{
//    return type;
//}

@end
