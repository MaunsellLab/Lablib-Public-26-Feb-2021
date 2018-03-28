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
    NSTask *task;
    NSFileHandle *file;
    NSPipe *pipe;

    task = [[NSTask alloc] init];
    pipe = [NSPipe pipe];
    [task setLaunchPath: @"/bin/sh"];
    [task setArguments:@[@"-c", [NSString stringWithFormat:@"%@", self]]];
    [task setStandardOutput:pipe];
    file = [pipe fileHandleForReading];
    [task launch];

    return [[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding];
//    return [[[NSString alloc] initWithData:[file readDataToEndOfFile] encoding:NSUTF8StringEncoding] autorelease];
}

@end
