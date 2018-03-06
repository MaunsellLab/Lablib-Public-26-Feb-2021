//
//  NSString+ShellExecution.m
//  Lablib
//
//  Created by John Maunsell on 11/24/17.
//

#import "NSString+ShellExecution.h"

@implementation NSString (ShellExecution)

-(NSString *)runAsCommand;
{
    NSPipe *pipe = [NSPipe pipe];

    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];

    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];

    return [[[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding] autorelease];
}

@end
