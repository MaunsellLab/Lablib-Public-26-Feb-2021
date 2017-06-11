//
//  LLPluginDefaults.m
//  Lablib
//
//  Created by John Maunsell on June 9, 2017.
//  Copyright 217. All rights reserved.
//

#import "LLPluginDefaults.h"


@implementation LLPluginDefaults

- (NSArray *)arrayForKey:(NSString *)defaultName;
{
	NSArray *array;
	
	array = [[NSUserDefaults standardUserDefaults] arrayForKey:defaultName];
	return array;
}

- (BOOL)boolForKey:(NSString *)defaultName;
{
	BOOL value;
	
	value = [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
	return value;
}

- (NSData *)dataForKey:(NSString *)defaultName;
{
	NSData *data;
	
	data = [[NSUserDefaults standardUserDefaults] dataForKey:defaultName];
	return data;
}

- (void)dealloc;
{
    [[NSUserDefaults standardUserDefaults] removeSuiteNamed:domainName];
    [domainName release];
    [super dealloc];
}

- (NSDictionary *)dictionaryForKey:(NSString *)defaultName;
{
	NSDictionary *dictionary;
	
	dictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:defaultName];
	return dictionary;
}

- (float)floatForKey:(NSString *)defaultName;
{
	float value;
	
	value = [[NSUserDefaults standardUserDefaults] floatForKey:defaultName];
	return value;
}

- (id)init;
{
	if ((self = [super init]) != nil) {
        domainName = @"lablib.knot.unnamed";
        [domainName retain];
	}
	return self;
}

- (id)initWithPluginName:(NSString *)name;
{
	if ((self = [super init]) != nil) {
        domainName = [NSString stringWithFormat:@"lablib.knot.%@", name];
        [domainName retain];
        [[NSUserDefaults standardUserDefaults] addSuiteNamed:domainName];
	}
	return self;
}

- (NSInteger)integerForKey:(NSString *)defaultName;
{
	int value;
	
	value = (int)[[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
	return value;
}

- (id)objectForKey:(NSString *)defaultName;
{
	id object;
	
	object = [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
	return object;
}

- (BOOL)objectIsForcedForKey:(NSString *)key;
{
	BOOL result;
	
	result = [[NSUserDefaults standardUserDefaults] objectIsForcedForKey:key];
	return result;
}

- (void)registerDefaults:(NSDictionary *)dictionary;
{
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:dictionary forName:domainName];
}

- (void)removeObjectForKey:(NSString *)defaultName;
{
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultName];
}

- (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
{
	[[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
}

- (void)setFloat:(float)value forKey:(NSString *)defaultName;
{
	[[NSUserDefaults standardUserDefaults] setFloat:value forKey:defaultName];
}

- (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;
{
	[[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
}

- (void)setObject:(id)value forKey:(NSString *)defaultName;
{
	[[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
}

- (NSArray *)stringArrayForKey:(NSString *)defaultName;
{
	return [[NSUserDefaults standardUserDefaults] stringArrayForKey:defaultName];
}

- (NSString *)stringForKey:(NSString *)defaultName;
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:defaultName];
}

- (BOOL)synchronize;
{
	return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
