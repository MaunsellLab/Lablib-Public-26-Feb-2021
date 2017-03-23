//
//  LLSockets.m
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//

#include <LLSystemUtil.h>

/* Constants for stream status:
 
 typedef enum {
 NSStreamStatusNotOpen = 0,
 NSStreamStatusOpening = 1,
 NSStreamStatusOpen = 2,
 NSStreamStatusReading = 3,
 NSStreamStatusWriting = 4,
 NSStreamStatusAtEnd = 5,
 NSStreamStatusClosed = 6,
 NSStreamStatusError = 7
 };
 
 Constants for Stream Events
 
 typedef enum NSStreamEvent : NSUInteger {
 NSStreamEventNone = 0,
 NSStreamEventOpenCompleted = 1UL << 0,
 NSStreamEventHasBytesAvailable = 1UL << 1,
 NSStreamEventHasSpaceAvailable = 1UL << 2,
 NSStreamEventErrorOccurred = 1UL << 3,
 NSStreamEventEndEncountered = 1UL << 4
 } NSStreamEvent;
 */

#define kBufferLength   1024

#define kLLSocketsHostKey           @"LLSocketsHost"
#define kLLSocketNumStatusStrings   9
#define kLLSocketsPortKey           @"LLSocketsPort"
#define kLLSocketsRigIDKey          @"LLSocketsRigID"
#define kLLSocketsTimeoutS          0.100
#define kLLSocketsVerboseKey        @"LLSocketsVerbose"
#define kLLSocketsWindowVisibleKey  @"kLLSocketsWindowVisible"

enum {kReceiveJSON = 1, kStop};

#import "LLSockets.h"

NSString *statusStrings[kLLSocketNumStatusStrings] = {
    @"NSStreamStatusNotOpen",
    @"NSStreamStatusOpening",
    @"NSStreamStatusOpen",
    @"NSStreamStatusReading",
    @"NSStreamStatusWriting",
    @"NSStreamStatusAtEnd",
    @"NSStreamStatusClosed",
    @"NSStreamStatusError",
    @"Unknown status code"
};

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;
NSInputStream *inputStream;
NSOutputStream *outputStream;

@implementation LLSockets

- (void)closeStreams;
{
    [streamsLock lock];
    [inputStream close];
    [outputStream close];
    [inputStream release];
    [outputStream release];
    inputStream = nil;
    outputStream = nil;
    [streamsLock unlock];
}

- (void)dealloc;
{
    [self closeStreams];
    [deviceNameDict release];
    [streamsLock release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLSocketsWindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (id)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }
    defaultSettings = [[NSMutableDictionary alloc] init];
    [defaultSettings setObject:@"http://127.0.0.1" forKey:kLLSocketsHostKey];
    [defaultSettings setObject:@"Rig0" forKey:kLLSocketsRigIDKey];
    [defaultSettings setObject:[NSNumber numberWithInt:9990] forKey:kLLSocketsPortKey];
    [defaultSettings setObject:[NSNumber numberWithBool:NO] forKey:kLLSocketsVerboseKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];
    
    deviceNameDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"LaserControllerX", @"rig1",
                                 @"LaserControllerXRig2", @"rig2",
                                 @"LaserControllerXRig3", @"rig3",
                                 @"LaserControllerXRig4", @"rig4",
                                 nil] retain];

    streamsLock = [[NSLock alloc] init];

    if ([self window] == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLSockets" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsWindowVisibleKey] || YES) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    [self postToConsole:@"LLSockets initialized\n" textColor:[NSColor blackColor]];
    return self;
}

- (BOOL)openStreams;
{
    long status;
    double startTime;
    
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsHostKey]];
    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLSocketsPortKey];
    
    [streamsLock lock];
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    [inputStream retain];
    [outputStream retain];
    [inputStream open];
    [outputStream open];
    startTime = [LLSystemUtil getTimeS];
    while ((status = [inputStream streamStatus]) == NSStreamStatusOpening) {
        if ([LLSystemUtil getTimeS] - startTime > 0.250) {
            [streamsLock unlock];
            [self closeStreams];
            return NO;
        }
    }
    status = [inputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [streamsLock unlock];
            [self postToConsole:@"openStreams: error opening input stream\n" textColor:[NSColor redColor]];
            [self closeStreams];
            if (![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            return NO;
            break;
        case NSStreamStatusOpen:
        default:
            break;
    };
    while ((status = [inputStream streamStatus]) != NSStreamStatusOpen) {};
    
    while ((status = [outputStream streamStatus]) == NSStreamStatusOpening) {};
    status = [outputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [self postToConsole:@"openStreams: error opening output stream\n" textColor:[NSColor redColor]];
            [inputStream close];
            [streamsLock unlock];
            if (![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            return NO;
            break;
        case NSStreamStatusOpen:
        default:
            break;
    };
    while ((status = [outputStream streamStatus]) != NSStreamStatusOpen) {};
    [streamsLock unlock];
    return YES;
}

- (void)post:(NSAttributedString *)attrStr;
{
    [[consoleView textStorage] appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
}

- (void)postToConsole:(NSString *)str textColor:(NSColor *)theColor;
{
    NSAttributedString *attrStr;
    NSDictionary *attr = [NSDictionary dictionaryWithObject:theColor forKey:NSForegroundColorAttributeName];
    
    attrStr = [[NSAttributedString alloc] initWithString:str attributes:attr];
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

/*
 writeDictionary is the main function for communicating with the server.  I tried to set things up with the
 client and server maintaining a connection across multiple transmissions, but it always got in trouble.  The
 current approach opens and closes a connection for each dictionary transfer.
 */

- (NSMutableDictionary *)writeDictionary:(NSMutableDictionary *)dict;
{
    NSData *JSONData;
    NSMutableDictionary *returnDict;
    NSError *error;
    NSString *deviceName, *rigID;
    uint32_t JSONLength, bufferLength;
    NSInteger readLength;
    uint8_t pBuffer[kBufferLength];
    long result;
    double startTime, endTime;
    static long retries = 0;

    startTime = [LLSystemUtil getTimeS];
    if (![self openStreams]) {
        return nil;
    }
    
    rigID = [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey];
    deviceName = [deviceNameDict objectForKey:rigID];
    if (deviceName == nil) {
        [self postToConsole:[NSString stringWithFormat:@"%@ is an unknown  rig ID\n", rigID]
                  textColor:[NSColor redColor]];
        return nil;
    }
    [dict setObject:deviceName forKey:@"deviceName"];
    JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    JSONLength = (uint32_t)[JSONData length];
    bufferLength = JSONLength + sizeof(uint32_t);
    *(uint32_t *)pBuffer = JSONLength;
    [JSONData getBytes:&pBuffer[sizeof(uint32_t)] length:JSONLength];
    
    result = [outputStream write:pBuffer maxLength:bufferLength];
    
    if (result != bufferLength) {
        error = [outputStream streamError];
        [self postToConsole:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                             error.code, error.localizedDescription] textColor:[NSColor redColor]];
        if (![[self window] isVisible]) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    
    while (![inputStream hasBytesAvailable]) {
        if ([LLSystemUtil getTimeS] - startTime > kLLSocketsTimeoutS) {
            [self closeStreams];
            if (retries >= 2) {
                [self postToConsole:[NSString stringWithFormat:@"Sent %d bytes, response timeout (%ld ms), giving up\n",
                                     JSONLength, (long)(kLLSocketsTimeoutS * 1000.0)] textColor:[NSColor redColor]];
                retries = 0;
                return nil;
            }
            if ((retries++ == 0) && ![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            [self postToConsole:[NSString stringWithFormat:@"Sent %d bytes, response timeout (%ld ms), retrying\n",
                                     JSONLength, (long)(kLLSocketsTimeoutS * 1000.0)] textColor:[NSColor redColor]];
            returnDict = [self writeDictionary:dict];
            retries--;
            return returnDict;
        }
    };
    readLength = [inputStream read:pBuffer maxLength:kBufferLength];
    pBuffer[readLength] = 0;
    [self closeStreams];
    endTime = [LLSystemUtil getTimeS];

    JSONData = [NSData dataWithBytes:pBuffer length:readLength];
    returnDict = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
    [self postToConsole:[NSString stringWithFormat:@"Sent %d bytes, received %ld bytes (%.1f ms) %@\n",
            JSONLength, (long)readLength, 1000.0 * (endTime - startTime), retries > 0 ? @"(successful retry)" : @""]
            textColor:(readLength > 0) ? [NSColor blackColor] : [NSColor redColor]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsVerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@" Sent: %@\n", dict] textColor:[NSColor blackColor]];
        [self postToConsole:[NSString stringWithFormat:@" Received: %s\n", pBuffer] textColor:[NSColor blackColor]];
    }
    return returnDict;
}

@end
