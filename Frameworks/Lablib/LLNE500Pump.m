//
//  LLNE500Pump.m
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

#define kLLNE500HostKey             @"LLNE500Host"
#define kLLNE500PortKey             @"LLNE500Port"
#define kLLNE500TimeOutS            1
#define kLLNE500VerboseKey          @"LLNE500Verbose"
#define kLLNE500WindowVisibleKey    @"kLLNE500WindowVisible"
#define kLLNE500NumStatusStrings    9

enum {kReceiveJSON = 1, kStop};

#import "LLNE500Pump.h"

NSString *NE500StatusStrings[kLLNE500NumStatusStrings] = {
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

CFReadStreamRef NE500ReadStream;
CFWriteStreamRef NE500WriteStream;
NSInputStream *NE500InputStream;
NSOutputStream *NE500OutputStream;

@implementation LLNE500Pump

@synthesize exists;

- (void)closeStreams;
{
    [streamsLock lock];
    [NE500InputStream close];
    [NE500OutputStream close];
    [NE500InputStream release];
    [NE500OutputStream release];
    NE500InputStream = nil;
    NE500OutputStream = nil;
    [streamsLock unlock];
}

- (void)dealloc;
{
    [self closeStreams];
    [statusDict release];
    [streamsLock release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLNE500WindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (void)doMicroliters:(float)microliters;
{
    [self writeMessage:[NSString stringWithFormat:@"VOL %.2f\r", microliters]];
    [self writeMessage:@"RUN\r"];
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
    [defaultSettings setObject:@"10.1.1.1" forKey:kLLNE500HostKey];
    [defaultSettings setObject:[NSNumber numberWithInt:100] forKey:kLLNE500PortKey];
    [defaultSettings setObject:[NSNumber numberWithBool:NO] forKey:kLLNE500VerboseKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];
    
    streamsLock = [[NSLock alloc] init];
    statusDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"(withdrawing)\n", @"W", @"(infusing)\n", @"I",
        @"(stopped)\n", @"S", @"(paused)\n", @"P", @"(phase paused)\n", @"T", @"(waiting for trigger)\n", @"U",
        @"(purging)\n", @"X", nil];

    if ([self window] == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLNE500Pump" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLNE500WindowVisibleKey] || YES) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    initialized = NO;
    exists = [self writeMessage:@"VER\r"];
    if (exists) {
        [self initPump];
    }
    return self;
}

- (BOOL)initPump;
{
    if ([self writeMessage:@"BP 0\r"]) {
        [self writeMessage:@"AL 1\r"];
        [self writeMessage:@"DIA 10.00\r"];
        [self writeMessage:@"RAT 60.00 UM\r"];
        [self writeMessage:@"VOL UL\r"];
        [self writeMessage:@"DIR INF\r"];
        initialized = YES;
    }
    return initialized;
}

- (BOOL)openStreams;
{
    long status;
    double startTime;

//    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLNE500HostKey]];
//    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLNE500PortKey];

    [streamsLock lock];
//    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &NE500ReadStream, &NE500WriteStream);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)@"10.1.1.1", 100, &NE500ReadStream, &NE500WriteStream);
    startTime = [LLSystemUtil getTimeS];
    NE500InputStream = (NSInputStream *)NE500ReadStream;
    NE500OutputStream = (NSOutputStream *)NE500WriteStream;
    [NE500InputStream retain];
    [NE500OutputStream retain];
    [NE500InputStream open];
    [NE500OutputStream open];
    while ((status = [NE500InputStream streamStatus]) == NSStreamStatusOpening) {
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"openStreams: Timeout error on input stream opening\n" textColor:[NSColor redColor]];
            [streamsLock unlock];
            [self closeStreams];
            return NO;
        }
    };
    status = [NE500InputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [streamsLock unlock];
            [self postInfo:@"openStreams: Error opening input stream\n" textColor:[NSColor redColor]];
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
    while ((status = [NE500InputStream streamStatus]) != NSStreamStatusOpen) {};

    while ((status = [NE500OutputStream streamStatus]) == NSStreamStatusOpening) {};
    status = [NE500OutputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [self postInfo:@"openStreams: error opening output stream\n" textColor:[NSColor redColor]];
            [NE500InputStream close];
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
    while ((status = [NE500OutputStream streamStatus]) != NSStreamStatusOpen) {};
    [streamsLock unlock];
    return YES;
}

// Service method for doing the actual posting to console in the main run loop

- (void)post:(NSAttributedString *)attrStr;
{
    [[consoleView textStorage] appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
}

// Post a message about the results of an exchange with the pump

- (void)postExchange:(NSString *)message reply:(uint8_t *)pBuffer length:(NSInteger)length;
{
    NSString *statusString;
    NSMutableAttributedString *attrStr;
    NSDictionary *attr;

    attr = [NSDictionary dictionaryWithObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

    attrStr = [[NSMutableAttributedString alloc] initWithString:message attributes:attr];
    [attrStr replaceCharactersInRange:NSMakeRange([attrStr length] - 1, 1) withString:@": "];
    if (pBuffer[0] != 2 || pBuffer[length - 1] != 3) {
        attr = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
        [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:@"Badly formed reply\n"
                    attributes:attr] autorelease]];
    }
    else if (strncmp((char *)&pBuffer[1], "00", 2) != 0) {
        attr = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
        [attrStr appendAttributedString:[[[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"Wrong pump address: %c%c\n", pBuffer[1], pBuffer[2]]
                    attributes:attr] autorelease]];
    }
    else {
        pBuffer[length - 1] = '\0';
        statusString = [statusDict objectForKey:[NSString stringWithFormat:@"%c", pBuffer[3]]];
        statusString = (statusString == nil) ? @"(unrecognized status code)\n" : statusString;
        attr = [NSDictionary dictionaryWithObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
        if (length == 5) {
            [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:statusString
                                                                             attributes:attr] autorelease]];
        }
        else {
            [attrStr appendAttributedString:[[[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"%s %@", &pBuffer[3], statusString]
                    attributes:attr] autorelease]];
        }
    }
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

// Post information about informational and error messages

- (void)postInfo:(NSString *)str textColor:(NSColor *)theColor;
{
    NSAttributedString *attrStr;
    NSDictionary *attr = [NSDictionary dictionaryWithObject:theColor forKey:NSForegroundColorAttributeName];

    attrStr = [[NSAttributedString alloc] initWithString:str attributes:attr];
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

- (BOOL)writeMessage:(NSString *)message;
{
    long i;
    NSError *error;
    uint32_t bufferLength;
    const char *cString;
    NSInteger readLength;
    uint8_t pBuffer[kBufferLength];
    long result;
    double startTime;

    if (![self openStreams]) {
        initialized = NO;
        return NO;
    }
    if (!initialized) {
        if (![self initPump]) {
            return NO;
        }
    }
    cString = [message cStringUsingEncoding:NSUTF8StringEncoding];
    bufferLength = (uint32_t)strlen(cString);
    result = [NE500OutputStream write:(uint8_t *)cString maxLength:bufferLength];
    if (result != bufferLength) {
        error = [NE500OutputStream streamError];
        [self postInfo:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                             error.code, error.localizedDescription] textColor:[NSColor redColor]];
        if (![[self window] isVisible]) {
            [[self window] makeKeyAndOrderFront:self];
        }
        [self closeStreams];
        initialized = NO;
        return NO;
    }
    startTime = [LLSystemUtil getTimeS];
    while (![NE500InputStream hasBytesAvailable]) {
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"Timeout error on response\n" textColor:[NSColor redColor]];
            [self closeStreams];
            return NO;
        }
    };
    usleep(10000);                                          // pump needs 10 ms from the arrival of first character
    for (i= 0; i < kBufferLength; i++) {
        pBuffer[i] = 0;
    }
    readLength = [NE500InputStream read:pBuffer maxLength:kBufferLength];
    [self closeStreams];
    [self postExchange:message reply:pBuffer length:readLength];
    return YES;
}

@end
