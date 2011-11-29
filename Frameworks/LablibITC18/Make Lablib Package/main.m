//
//  main.m
//  Make Lablib Package
//
//  Created by John Maunsell on 6/26/11.
//  Copyright 2011 Harvard Medical School. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <AppleScriptObjC/AppleScriptObjC.h>

int main(int argc, char *argv[])
{
    [[NSBundle mainBundle] loadAppleScriptObjectiveCScripts];
    return NSApplicationMain(argc, (const char **)argv);
}
