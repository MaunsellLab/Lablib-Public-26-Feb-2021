//
//  LLNE500Pump.m
//  Lablib
//
//  Created by John Maunsell on 02/11/2017.
//
// The NE500 Pump is controlled through a StarTech TCP-RS232 converter.  The code here will work with only two
// changes to the default settings for the StarTech device.  The first step is to get the pump and StarTech device
// on the same network as the computer you're using, and to manually set the computer to the same subnet.  The
// StarTech default address is 10.1.1.1, so the computer might be 10.1.1.2.  Once that is arrange, you need to use
// a browser to change the StarTech setting.  These changes can be made using a browser and going 10.1.1.1.  The
// login and password are both "admin" for the StarTech device.  Under UART Control, change the StarTech baudrate
// 19200, which is all the NE500 pump can handle.  Under TCP mode, change the Port Number to 100, which is what
// we use by convention (although any other port number should work if you set it appropriately in this code.

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

#define kLLNE500DiameterMMKey       @"LLNE500DiameterMM"
#define kLLNE500HostKey             @"LLNE500Host"
#define kLLNE500PortKey             @"LLNE500Port"
#define kLLNE500TimeOutS            0.250
#define kLLNE500ULPerMKey           @"LLNE500ULPerM"
#define kLLNE500WindowVisibleKey    @"LLNE500WindowVisible"
//#define kLLNE500NumStatusStrings    9

#import "LLNE500Pump.h"

//NSString *NE500StatusStrings[kLLNE500NumStatusStrings] = {
//    @"NSStreamStatusNotOpen",
//    @"NSStreamStatusOpening",
//    @"NSStreamStatusOpen",
//    @"NSStreamStatusReading",
//    @"NSStreamStatusWriting",
//    @"NSStreamStatusAtEnd",
//    @"NSStreamStatusClosed",
//    @"NSStreamStatusError",
//    @"Unknown status code"
//};

@implementation LLNE500Pump

@synthesize exists;

// Assume we have the lock

- (void)closeStreams:(NSInputStream *)inStream outStream:(NSOutputStream *)outStream;
{
    [inStream close];
    [outStream close];
    [inStream release];
    [outStream release];
}

- (void)dealloc;
{
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.LLNE500DiameterMM"];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.LLNE500ULPerM"];
    [statusDict release];
    [streamsLock release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLNE500WindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (void)doMicroliters:(float)microliters;
{
    if (microliters != previousUL) {
        [self writeMessage:[NSString stringWithFormat:@"VOL %.2f\r", microliters]];
        previousUL = microliters;
    }
    [self writeMessage:@"RUN\r"];
}
- (id)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }
    defaultSettings = [[NSMutableDictionary alloc] init];
    [defaultSettings setObject:[NSNumber numberWithInt:4.0] forKey:kLLNE500DiameterMMKey];
    [defaultSettings setObject:@"10.1.1.1" forKey:kLLNE500HostKey];
    [defaultSettings setObject:[NSNumber numberWithInt:600.0] forKey:kLLNE500ULPerMKey];
    [defaultSettings setObject:[NSNumber numberWithInt:100] forKey:kLLNE500PortKey];
    //[defaultSettings setObject:[NSNumber numberWithBool:NO] forKey:kLLNE500VerboseKey];
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
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.LLNE500DiameterMM"
                                                                 options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.LLNE500ULPerM"
                                                                 options:NSKeyValueObservingOptionNew context:nil];
    previousUL = -1;
    exists = NO;                                        // flag that we haven't contacted the pump yet.
    [self writeMessage:@"VER\r"];
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    NSString *key;

    key = [keyPath pathExtension];
    if ([key isEqualTo:kLLNE500DiameterMMKey]) {
        [self writeMessage:[NSString stringWithFormat:@"DIA %5.1f\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500DiameterMMKey]]];
    }
    else if ([key isEqualTo:kLLNE500ULPerMKey]) {
        [self writeMessage:[NSString stringWithFormat:@"RAT %5.1f UM\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500ULPerMKey]]];
    }
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
        [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:@"Reply missing <STX> or <ETX>\n"
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
    long i, status, result;
    NSError *error;
    uint32_t bufferLength;
    const char *cString;
    NSInteger readLength;
    uint8_t pBuffer[kBufferLength];
    double startTime;
    CFReadStreamRef NE500ReadStream;
    CFWriteStreamRef NE500WriteStream;
    NSInputStream *NE500InputStream;
    NSOutputStream *NE500OutputStream;

    NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:kLLNE500HostKey];
    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLNE500PortKey];

    [streamsLock lock];
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)urlString, port,
                                       &NE500ReadStream, &NE500WriteStream);
    startTime = [LLSystemUtil getTimeS];
    NE500InputStream = (NSInputStream *)NE500ReadStream;
    NE500OutputStream = (NSOutputStream *)NE500WriteStream;
    [NE500InputStream retain];
    [NE500OutputStream retain];
    [NE500InputStream open];
    [NE500OutputStream open];
    while ((status = [NE500InputStream streamStatus]) == NSStreamStatusOpening) {
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"writeMessage: Timeout error on input stream opening\n" textColor:[NSColor redColor]];
            [self closeStreams:NE500InputStream outStream:NE500OutputStream];
            [streamsLock unlock];
            return NO;
        }
        usleep(5000);
    };
    status = [NE500InputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [self closeStreams:NE500InputStream outStream:NE500OutputStream];
            [streamsLock unlock];
            [self postInfo:@"writeMessage: Error opening input stream\n" textColor:[NSColor redColor]];
            if (![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            previousUL = -1;
            exists = NO;
            return exists;
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
            [self postInfo:@"writeMessage: error opening output stream\n" textColor:[NSColor redColor]];
            [NE500InputStream close];
            [streamsLock unlock];
            if (![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            previousUL = -1;
            exists = NO;
            return exists;
            break;
        case NSStreamStatusOpen:
        default:
            break;
    };
    while ((status = [NE500OutputStream streamStatus]) != NSStreamStatusOpen) {};
    [streamsLock unlock];

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
        [self closeStreams:NE500InputStream outStream:NE500OutputStream];
        previousUL = -1;
        exists = NO;
        return exists;
    }
    startTime = [LLSystemUtil getTimeS];
    while (![NE500InputStream hasBytesAvailable]) {
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"Timeout error on response\n" textColor:[NSColor redColor]];
            [self closeStreams:NE500InputStream outStream:NE500OutputStream];
            previousUL = -1;
            exists = NO;
            return exists;
        }
        usleep(5000);
    };
    usleep(15000);                                          // pump needs 15 ms from the arrival of first character
    for (i= 0; i < kBufferLength; i++) {
        pBuffer[i] = 0;
    }
    readLength = [NE500InputStream read:pBuffer maxLength:kBufferLength];
    [self closeStreams:NE500InputStream outStream:NE500OutputStream];
    [self postExchange:message reply:pBuffer length:readLength];

    // If we've succeeded where previously we've failed (or not been initialized), then we need to reinitialize
    // the pump.  Setting 'exists' here first avoids infinite recursion.

    if (!exists) {
        exists = YES;
        [self writeMessage:@"BP 0\r"];
        [self writeMessage:@"AL 1\r"];
        [self writeMessage:[NSString stringWithFormat:@"DIA %5.1f\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500DiameterMMKey]]];
        [self writeMessage:[NSString stringWithFormat:@"RAT %5.1f UM\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500ULPerMKey]]];
        [self writeMessage:@"VOL UL\r"];
        [self writeMessage:@"DIR INF\r"];
    }
    return exists;
}

@end
