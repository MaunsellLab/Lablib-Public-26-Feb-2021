//
//  main.m
//  DataConverter
//
//  Created by John Maunsell on Sun Jul 07 2002.
//  Copyright (c) 2017. All rights reserved.
//

#import <Foundation/NSDebug.h>

int main(int argc, const char *argv[])
{
	NSDebugEnabled = YES;
	NSZombieEnabled = YES;
	NSDeallocateZombies = NO;
	NSLog(@"NSDebugEnabled: %d", NSDebugEnabled);
	NSLog(@"NSZombieEnabled: %d", NSZombieEnabled);
	NSLog(@"NSDeallocateZombies: %d", NSDeallocateZombies);

    return NSApplicationMain(argc, (const char **)argv);
}
