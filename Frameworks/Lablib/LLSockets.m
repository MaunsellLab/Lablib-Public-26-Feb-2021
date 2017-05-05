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

//#define kBufferLength   1024

#define kLLSocketsHostKey           @"LLSocketsHost"
#define kLLSocketNumStatusStrings   9
#define kLLSocketsPortKey           @"LLSocketsPort"
#define kLLSocketsRigIDKey          @"LLSocketsRigID"
#define kLLSocketsMinTimeoutS       0.100
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

@implementation LLSockets

+ (NSThread *)networkThread;
{
    static NSThread *networkThread = nil;
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        networkThread = [[NSThread alloc] initWithTarget:self selector:@selector(networkThreadMain:) object:nil];
        [networkThread start];
    });
    return networkThread;
}

+ (void)networkThreadMain:(id)unused;
{
    do {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] run];
        }
    } while (YES);
}

- (void)removeFromCurrentThread:(NSStream *)stream;
{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)scheduleInCurrentThread:(NSStream *)stream;
{
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}


- (void)closeStreams;
{
    [streamsLock lock];
    [inputStream close];
    [outputStream close];
//    [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
//    [outputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [self performSelector:@selector(removeFromCurrentThread:) onThread:[[self class] networkThread]
               withObject:inputStream waitUntilDone:YES];
    [self performSelector:@selector(removeFromCurrentThread:) onThread:[[self class] networkThread]
               withObject:outputStream waitUntilDone:YES];

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

    timeoutS = kLLSocketsMinTimeoutS;
    timeoutTotalS = timeoutN = 0;
    deviceNameDict = [[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"LaserControllerX", @"rig1",
                                 @"LaserControllerXRig2", @"rig2",
                                 @"LaserControllerXRig3", @"rig3",
                                 @"LaserControllerXRig4", @"rig4",
                                 @"LEDdaq", @"rig2P",
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
//    long status;
//    double startTime;
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;

    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsHostKey]];
    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLSocketsPortKey];
    
    [streamsLock lock];
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    [inputStream retain];
    [outputStream retain];
    CFRelease(readStream);
    CFRelease(writeStream);
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [self performSelector:@selector(scheduleInCurrentThread:) onThread:[[self class] networkThread]
               withObject:inputStream waitUntilDone:YES];
    [self performSelector:@selector(scheduleInCurrentThread:) onThread:[[self class] networkThread]
               withObject:outputStream waitUntilDone:YES];
    inputStreamOpen = outputStreamOpen = outputSpaceAvailable = NO;
    [inputStream open];
    [outputStream open];
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
 Occasionally, for reasons I cannot work out, inputStream will get an NSStreamEventHasBytesAvailable event immediately
 after completing a buffer read.  I could see how an event might get created if the read were done piecemeal, with 
 the first incarnation draining all the bytes after event occurred, leaving the second event with nothing to read. 
 But when I measure things, the reads are essentially always occurring atomically.  For now it seems safe to ignore
 these apparently supurious events.
 
*/

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode;
{
    long index;
    NSInteger lengthBytes;
    NSMutableData *JSONData = nil;
    NSError *error;
    uint32_t bytesToRead = 0;
    uint8_t *pBytes = (uint8_t *)&bytesToRead;

    switch (eventCode) {
        case NSStreamEventHasBytesAvailable:
            if (stream == inputStream) {
                JSONData = [[NSMutableData alloc] init];
                while ([inputStream hasBytesAvailable]) {
                    lengthBytes = [(NSInputStream *)stream read:readBuffer maxLength:kReadBufferSize];
                    if (lengthBytes > 0) {
                        index = 0;
                        while (bytesRead < 4) {
                            *pBytes++ = readBuffer[index++];
                            bytesRead++;
                            if (index >= lengthBytes) {
                                break;
                            }
                        }
                        if (index >= lengthBytes) {
                            continue;
                        }
                        if (bytesRead >= 4) {
                            [JSONData appendBytes:(const void *)&readBuffer[index] length:lengthBytes - index];
                            bytesRead += lengthBytes - index;
                        }
                    }
                    else if (lengthBytes < 0) {
                        if ([inputStream.streamError code] != 0) {
                                NSLog(@"LLSockets: error %ld reading data %@", [inputStream.streamError code],
                                      [inputStream.streamError localizedDescription]);
                        }
                    }
                    if (bytesRead == bytesToRead) {
                        responseDict = [[NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error] retain];
                        break;
                    }
                }
                [JSONData release];
            }
            break;
        case NSStreamEventErrorOccurred:
//            NSLog(@"LLSockets: NSStreamEventErrorOccurred");
            break;
        case NSStreamEventNone:
            NSLog(@"LLSockets: NSStreamEventNone");
            break;
        case NSStreamEventOpenCompleted:
            if (stream == inputStream) {
                inputStreamOpen = YES;
            }
            else if (stream == outputStream) {
                outputStreamOpen = YES;
            }
            break;
        case NSStreamEventEndEncountered:
//            NSLog(@"***LLSockets: NSStreamEventEndEncountered");
            break;
        case NSStreamEventHasSpaceAvailable:
            outputSpaceAvailable = YES;
            break;
    }
}

/*
 writeDictionary is the main function for communicating with the server.  I tried to set things up with the
 client and server maintaining a connection across multiple transmissions, but it always got in trouble.  The
 current approach opens and closes a connection for each dictionary transfer.
*/

- (NSMutableDictionary *)writeDictionary:(NSMutableDictionary *)dict;
{
    BOOL success;
    NSData *JSONData;
    NSString *deviceName, *rigID;
    uint32_t JSONLength, bufferLength;
    NSError *error;
    uint8_t *pBuffer;
    long totalWritten, writtenBytes;
    double startTime, endTime;
    static long retries = 0;

    if (![self openStreams]) {
        return nil;
    }

    // LLSockets controls the GUI window with the Rig ID field, so it is responsible for passing the Rig ID
    // to the PC.  It is added to every dictionary that is sent to the PC

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
    pBuffer = (uint8_t *)malloc(bufferLength);
    *(uint32_t *)pBuffer = JSONLength;
    [JSONData getBytes:&pBuffer[sizeof(uint32_t)] length:JSONLength];
    startTime = [LLSystemUtil getTimeS];
    while (!outputStreamOpen) {
        if ([LLSystemUtil getTimeS] - startTime > timeoutS) {
            [self closeStreams];
            if (retries >= 2) {
                [self postToConsole:@" Giving up\n" textColor:[NSColor redColor]];
                return nil;
            }
            if ((retries == 0) && ![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            [self postToConsole:@"Timed out waiting for open output stream, retrying\n" textColor:[NSColor redColor]];
            retries++;
            responseDict = [self writeDictionary:dict];
            retries--;
            return responseDict;
        }
    };
    timeoutTotalS += [LLSystemUtil getTimeS] - startTime;
    timeoutN++;
    timeoutS = MAX(kLLSocketsMinTimeoutS, timeoutTotalS * 10.0 / timeoutN);
    responseDict = nil;
    bytesRead = 0;                      // clear for reading the response
    totalWritten = 0;
    while (totalWritten < bufferLength) {
        while (!outputSpaceAvailable) {};
        outputSpaceAvailable = NO;
        writtenBytes = [outputStream write:(pBuffer + totalWritten) maxLength:(bufferLength - totalWritten)];
        if (writtenBytes >= 0) {
            totalWritten += writtenBytes;
        }
        else {
            error = [outputStream streamError];
            [self postToConsole:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                                 error.code, error.localizedDescription] textColor:[NSColor redColor]];
            if (![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            [self closeStreams];
            return nil;
        }
    }
    startTime = [LLSystemUtil getTimeS];
    while (responseDict == nil) {
        if ([LLSystemUtil getTimeS] - startTime > timeoutS) {
            [self closeStreams];
            if (retries >= 2) {
                [self postToConsole:
                            [NSString stringWithFormat:@"Sent %d bytes, read %ld before timeout (%ld ms), giving up\n",
                            JSONLength, bytesRead, (long)(timeoutS * 1000.0)] textColor:[NSColor redColor]];
                return nil;
            }
            if ((retries == 0) && ![[self window] isVisible]) {
                [[self window] makeKeyAndOrderFront:self];
            }
            [self postToConsole:
                            [NSString stringWithFormat:@"Sent %d bytes, read %ld before timeout (%ld ms), retrying\n",
                            JSONLength, bytesRead, (long)(timeoutS * 1000.0)] textColor:[NSColor redColor]];
            retries++;
            responseDict = [self writeDictionary:dict];
            retries--;
            return nil;
        }
    }
    timeoutTotalS += [LLSystemUtil getTimeS] - startTime;
    timeoutN++;
    timeoutS = MAX(kLLSocketsMinTimeoutS, timeoutTotalS * 10.0 / timeoutN);
    [self closeStreams];
    endTime = [LLSystemUtil getTimeS];
    [self postToConsole:[NSString stringWithFormat:@"Sent %d bytes, received %ld bytes (%.1f ms) %@ %@\n",
            JSONLength, bytesRead, 1000.0 * (endTime - startTime), [dict objectForKey:@"command"],
            retries > 0 ? @"(successful retry)" : @""]
            textColor:(bytesRead > 0) ? [NSColor blackColor] : [NSColor redColor]];
    success = [[responseDict objectForKey:@"success"] boolValue];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsVerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@"%@\n", dict] textColor:[NSColor blackColor]];
        if (success) {
            [self postToConsole:@"   Received: success\n" textColor:[NSColor blackColor]];
        }
        else {
            [self postToConsole:[NSString stringWithFormat:@"   Received: %@\n",
                    [responseDict objectForKey:@"errorMessage"]] textColor:[NSColor redColor]];
        }
    }
    else if (!success) {
        if ([responseDict objectForKey:@"errorMessage"] != nil) {
            [self postToConsole:[NSString stringWithFormat:@"   Received: %@\n",
                                 [responseDict objectForKey:@"errorMessage"]] textColor:[NSColor redColor]];
        }
        else {
            [self postToConsole:
                    [NSString stringWithFormat:@"\"%@\" failed with no message\n", [dict objectForKey:@"command"]]
                    textColor:[NSColor redColor]];
        }
    }
    [self closeStreams];
    [responseDict autorelease];
    return responseDict;
}

@end
