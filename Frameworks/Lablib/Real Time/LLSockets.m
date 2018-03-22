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
#define kLLSocketsMinTimeoutS       0.200
#define kLLSocketsVerboseKey        @"LLSocketsVerbose"
#define kLLSocketsWindowVisibleKey  @"kLLSocketsWindowVisible"

#define kDelayMSPerByte             (1.0 / 25000)
#define kMinTimeoutS                0.200

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
    [[NSUserDefaults standardUserDefaults] setBool:self.window.visible forKey:kLLSocketsWindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (instancetype)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }
    defaultSettings = [[NSMutableDictionary alloc] init];
    defaultSettings[kLLSocketsHostKey] = @"http://127.0.0.1";
    defaultSettings[kLLSocketsRigIDKey] = @"rig0";
    defaultSettings[kLLSocketsPortKey] = @9990;
    defaultSettings[kLLSocketsVerboseKey] = @NO;
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];

    
    NSLog(@"LLSockets: keyValue: %@", [[NSUserDefaults standardUserDefaults] objectForKey:kLLSocketsRigIDKey]);
    
    timeoutS = kLLSocketsMinTimeoutS;
    deviceNameDict = [@{@"rig 1": @"LaserControllerX",
                @"rig 2": @"LaserControllerXRig2",
                @"rig 3": @"LaserControllerXRig3",
                @"rig 4": @"LaserControllerXRig4",
                @"rig2p": @"LEDdaq",
                @"rig 2p": @"LEDdaq"} retain];

    streamsLock = [[NSLock alloc] init];

    if (self.window == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLSockets" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsWindowVisibleKey] || YES) {
            [self.window makeKeyAndOrderFront:self];
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
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)url.host, port, &readStream, &writeStream);
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    [inputStream retain];
    [outputStream retain];
    CFRelease(readStream);
    CFRelease(writeStream);
    inputStream.delegate = self;
    outputStream.delegate = self;
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
    [consoleView.textStorage appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange(consoleView.textStorage.length, 0)];
}

- (void)postToConsole:(NSString *)str textColor:(NSColor *)theColor;
{
    NSAttributedString *attrStr;
    NSDictionary *attr = @{NSForegroundColorAttributeName: theColor};
    
    attrStr = [[NSAttributedString alloc] initWithString:str attributes:attr];
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

- (void)removeFromCurrentThread:(NSStream *)stream;
{
    [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (NSString *)rigID;
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey].lowercaseString;
}

- (void)scheduleInCurrentThread:(NSStream *)stream;
{
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
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
                while (inputStream.hasBytesAvailable) {
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
                        if ((inputStream.streamError).code != 0) {
                                NSLog(@"LLSockets: error %ld reading data %@", (inputStream.streamError).code,
                                      (inputStream.streamError).localizedDescription);
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

- (void)setTimeoutS:(double)newTimeoutS;
{
    timeoutS = MAX(newTimeoutS, kMinTimeoutS);
}

- (double)timeoutS;
{
    return timeoutS;
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
    double startTime, endTime, thisTimeoutS;
    static long retries = 0;

    if (![self openStreams]) {
        return nil;
    }

    // LLSockets controls the GUI window with the Rig ID field, so it is responsible for passing the Rig ID
    // to the PC.  It is added to every dictionary that is sent to the PC

    rigID = [self rigID];
    deviceName = deviceNameDict[rigID.lowercaseString];
    if (deviceName == nil) {
        [self postToConsole:[NSString stringWithFormat:@"%@ is an unknown rig ID\n", rigID]
                  textColor:[NSColor redColor]];
        return nil;
    }
    dict[@"deviceName"] = deviceName;
    JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    JSONLength = (uint32_t)JSONData.length;
    bufferLength = JSONLength + sizeof(uint32_t);
    pBuffer = (uint8_t *)malloc(bufferLength);
    *(uint32_t *)pBuffer = JSONLength;
    [JSONData getBytes:&pBuffer[sizeof(uint32_t)] length:JSONLength];
    
    // Wait for output channel to finish opening
    
    startTime = [LLSystemUtil getTimeS];
    while (!outputStreamOpen) {
        if ([LLSystemUtil getTimeS] - startTime > kMinTimeoutS) {
            [self closeStreams];
            if (retries >= 2) {
                [self postToConsole:@" Giving up\n" textColor:[NSColor redColor]];
                return nil;
            }
            if ((retries == 0) && !self.window.visible) {
                [self.window makeKeyAndOrderFront:self];
            }
            [self postToConsole:@"Timed out waiting for open output stream, retrying\n" textColor:[NSColor redColor]];
            retries++;
            responseDict = [self writeDictionary:dict];
            retries--;
            return responseDict;
        }
    };
    
    // Write the data to the NIDAQ computer
    
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
            error = outputStream.streamError;
            [self postToConsole:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                                 error.code, error.localizedDescription] textColor:[NSColor redColor]];
            if (!self.window.visible) {
                [self.window makeKeyAndOrderFront:self];
            }
            [self closeStreams];
            return nil;
        }
    }
    // Get the response from the NIDAQ computer
    
    thisTimeoutS = MAX(timeoutS, bufferLength * kDelayMSPerByte);
    startTime = [LLSystemUtil getTimeS];
    while (responseDict == nil) {
        if ([LLSystemUtil getTimeS] - startTime > thisTimeoutS) {
            [self closeStreams];
            if (retries >= 2) {
                [self postToConsole:
                            [NSString stringWithFormat:@"Sent %d bytes, read %ld before timeout (%ld ms), giving up\n",
                            JSONLength, bytesRead, (long)(thisTimeoutS * 1000.0)] textColor:[NSColor redColor]];
                return nil;
            }
            if ((retries == 0) && !self.window.visible) {
                [self.window makeKeyAndOrderFront:self];
            }
            [self postToConsole:
                            [NSString stringWithFormat:@"Sent %d bytes, read %ld before timeout (%ld ms), retrying\n",
                            JSONLength, bytesRead, (long)(thisTimeoutS * 1000.0)] textColor:[NSColor redColor]];
            retries++;
            responseDict = [self writeDictionary:dict];
            retries--;
            return responseDict;
        }
    }
    endTime = [LLSystemUtil getTimeS];
    [self postToConsole:[NSString stringWithFormat:@"Sent %d bytes, received %ld bytes (%.1f ms) %@ %@\n",
            JSONLength, bytesRead, 1000.0 * (endTime - startTime), dict[@"command"],
            retries > 0 ? @"(successful retry)" : @""]
            textColor:(bytesRead > 0) ? [NSColor blackColor] : [NSColor redColor]];
    success = [responseDict[@"success"] boolValue];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsVerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@"%@\n", dict] textColor:[NSColor blackColor]];
        if (success) {
            [self postToConsole:@"   Received: success\n" textColor:[NSColor blackColor]];
        }
        else {
            [self postToConsole:[NSString stringWithFormat:@"   Received: %@\n",
                    responseDict[@"errorMessage"]] textColor:[NSColor redColor]];
        }
    }
    else if (!success) {
        if (responseDict[@"errorMessage"] != nil) {
            [self postToConsole:[NSString stringWithFormat:@"   Received: %@\n",
                                 responseDict[@"errorMessage"]] textColor:[NSColor redColor]];
        }
        else {
            [self postToConsole:
                    [NSString stringWithFormat:@"\"%@\" failed with no message\n", dict[@"command"]]
                    textColor:[NSColor redColor]];
        }
    }
    [self closeStreams];
    [responseDict autorelease];
    return responseDict;
}

@end
