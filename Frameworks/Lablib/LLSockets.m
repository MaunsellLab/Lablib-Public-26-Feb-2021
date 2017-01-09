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
#define kLLSocketsPortKey           @"LLSocketsPort"
#define kLLSocketsRigIDKey          @"LLSocketsRigID"
#define kLLSocketsVerboseKey        @"LLSocketsVerbose"
#define kLLSocketsWindowVisibleKey  @"kLLSocketsWindowVisible"
#define kLLSocketNumStatusStrings   9

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
    [streamsLock release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLSocketsWindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (id)init;
{
    NSMutableDictionary *defaultSettings;
//    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsHostKey]];
//    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLSocketsPortKey];
    
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
    while ((status = [inputStream streamStatus]) == NSStreamStatusOpening) {};
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

- (void)writeDictionary:(NSMutableDictionary *)dict;
{
    NSData *JSONData;
    NSError *error;
    uint32_t JSONLength, bufferLength;
    NSInteger readLength;
    uint8_t pBuffer[kBufferLength];
    long result;
    double startTime, endTime;

    startTime = [LLSystemUtil getTimeS];
    if (![self openStreams]) {
        return;
    }
    
    [dict setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey] forKey:@"rigID"];
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
    
    while (![inputStream hasBytesAvailable]) {};
    readLength = [inputStream read:pBuffer maxLength:kBufferLength];
    pBuffer[readLength] = 0;
    [self closeStreams];
    
    endTime = [LLSystemUtil getTimeS];
    if (readLength == JSONLength) {
        [self postToConsole:[NSString stringWithFormat:@"Successfully sent dictionary of %d bytes\n", JSONLength]
            textColor:[NSColor blackColor]];
    }
    else {
        [self postToConsole:[NSString stringWithFormat:@"Communication error: Sent %d bytes, but server echoed %ld\n",
                             JSONLength, (long)readLength] textColor:[NSColor blackColor]];
        [self postToConsole:[NSString stringWithFormat:@"Received: %s\n", pBuffer]
            textColor:[NSColor redColor]];
        if (![[self window] isVisible]) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsVerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@"Received: %s\n", pBuffer] textColor:[NSColor blackColor]];
        [self postToConsole:[NSString stringWithFormat:@"Delay to write %.1f ms\n", 1000.0 * (endTime - startTime)]
              textColor:[NSColor blackColor]];
    }

}

@end
