//
//  LLNumberMatchTransformer.m
//  Lablib
//
//  Created by John Maunsell on 3/11/07.
//  Copyright 2007. All rights reserved.
//

#import <Lablib/LLNumberMatchTransformer.h>

@implementation LLNumberMatchTransformer

+ (Class)transformedValueClass;
{
    return [NSNumber class];
}

- (void)addNumber:(NSValue *)newNumber;
{
    [numbers addObject:newNumber];
}

- (void)dealloc;
{
    [numbers release];
    [super dealloc];
}

- (instancetype)init;
{
    if (self = [super init]) {
        numbers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)transformedValue:(id)number;
{
    long index;
    
    for (index = 0; index < numbers.count; index++) {
        if ([number compare:numbers[index]] == NSOrderedSame) {
            return @YES;
        }
    }
    return @NO;
}

@end
