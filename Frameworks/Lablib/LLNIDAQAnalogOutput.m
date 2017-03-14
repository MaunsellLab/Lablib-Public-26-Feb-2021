//
//  LLNIDAQAnalogOutput.m
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLNIDAQAnalogOutput.h"


@implementation LLNIDAQAnalogOutput

- (id)initWithNIDAQ:(LLNIDAQ *)theNIDAQ;
{
    if ([super init] != nil) {
        nidaq = theNIDAQ;
        task = [nidaq createTaskWithName:@""];
    }
    return self;
}


@end




