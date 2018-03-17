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

#import "LLNE500Pump.h"
#include <LLSystemUtil.h>

#define kBufferLength   1024

#define kLLNE500DiameterMMKey       @"LLNE500DiameterMM"
#define kLLNE500HostKey             @"LLNE500Host"
#define kLLNE500MinDelayS           0.0125
#define kLLNE500PortKey             @"LLNE500Port"
#define kLLNE500TimeOutS            0.250
#define kLLNE500ULPerMKey           @"LLNE500ULPerM"
#define kLLNE500WindowVisibleKey    @"LLNE500WindowVisible"

@implementation LLNE500Pump

@synthesize exists;

- (void)closeStreams;
{
    [streams.in close];                                 // Should have streamLock during each call of closeStreams
    [streams.out close];
    [streams.in release];
    [streams.out release];
}

- (void)dealloc;
{
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.LLNE500DiameterMM"];
    [[NSUserDefaultsController sharedUserDefaultsController] removeObserver:self forKeyPath:@"values.LLNE500ULPerM"];
    [[NSUserDefaults standardUserDefaults] setBool:self.window.visible forKey:kLLNE500WindowVisibleKey];
    [errorDict release];
    [statusDict release];
    [streamsLock release];
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

- (instancetype)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }

    // Register default settings

    defaultSettings = [[NSMutableDictionary alloc] init];
    defaultSettings[kLLNE500DiameterMMKey] = [NSNumber numberWithInt:4.0];
    defaultSettings[kLLNE500HostKey] = @"10.1.1.1";
    defaultSettings[kLLNE500ULPerMKey] = [NSNumber numberWithInt:600.0];
    defaultSettings[kLLNE500PortKey] = @100;
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];
    
    streamsLock = [[NSLock alloc] init];
    statusDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"(withdrawing)\n", @"W", @"(infusing)\n", @"I",
                @"(stopped)\n", @"S", @"(paused)\n", @"P", @"(phase paused)\n", @"T", @"(waiting for trigger)\n", @"U",
                @"(purging)\n", @"X", nil];
    errorDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"(command not currently applicable)\n", @"?NA",
                @"(data out of range)\n", @"?OOR", @"(invalid communication packet)\n", @"?COM",
                 @"(command ingnored -- phase start)\n", @"?IGN", @"(unrecognized command)\n", @"?",
                 @"(pump was reset)\n", @"?R", @"(pump motor stalled)\n", @"?S",
                 @"(safe mode communication timeout)\n", @"?T", @"(pump program error)\n", @"?E",
                 @"(settings out of range)\n", @"?O", nil];

    if (self.window == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLNE500Pump" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLNE500WindowVisibleKey] || YES) {
            [self.window makeKeyAndOrderFront:self];
        }
    }
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.LLNE500DiameterMM"
                                                                 options:NSKeyValueObservingOptionNew context:nil];
    [[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.LLNE500ULPerM"
                                                                 options:NSKeyValueObservingOptionNew context:nil];
    previousUL = -1;
    exists = NO;                                        // flag that we haven't contacted the pump yet.
    [self writeMessage:@"VER\r"];                       // attempt to set up the pump
    return self;
}

// Observe key values in the dialog window, and update the pump when they change

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    NSString *key;

    key = keyPath.pathExtension;
    if ([key isEqualTo:kLLNE500DiameterMMKey]) {
        [self writeMessage:[NSString stringWithFormat:@"DIA %5.1f\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500DiameterMMKey]]];
    }
    else if ([key isEqualTo:kLLNE500ULPerMKey]) {
        [self writeMessage:[NSString stringWithFormat:@"RAT %5.1f UM\r",
                            [[NSUserDefaults standardUserDefaults] floatForKey:kLLNE500ULPerMKey]]];
    }
}

// We open (and close) streams for each command that is sent to the pump

- (BOOL)openStreams;
{
    long status;
    double startTime;
    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLNE500PortKey];
    NSString *urlString = [[NSUserDefaults standardUserDefaults] stringForKey:kLLNE500HostKey];

    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)urlString, port,
                                       (CFReadStreamRef *)&streams.in, (CFWriteStreamRef *)&streams.out);
    startTime = [LLSystemUtil getTimeS];
    [streams.in retain];
    [streams.out retain];
    [streams.in open];
    [streams.out open];
    while ((status = streams.in.streamStatus) == NSStreamStatusOpening) {
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"openStreams: Timeout error on input stream opening\n" textColor:[NSColor redColor]];
            [self closeStreams];
            return NO;
        }
        usleep(5000);
    }
    if (streams.in.streamStatus == NSStreamStatusError) {
        [self closeStreams];
        [self postInfo:@"openStreams: Error opening input stream\n" textColor:[NSColor redColor]];
        if (!self.window.visible) {
            [self.window makeKeyAndOrderFront:self];
        }
        return NO;
    }
    while ((status = streams.in.streamStatus) != NSStreamStatusOpen) {};
    while ((status = streams.out.streamStatus) == NSStreamStatusOpening) {};
    if (status == NSStreamStatusError) {
        [self postInfo:@"openStreams: error opening output stream\n" textColor:[NSColor redColor]];
        [streams.in close];
        if (!self.window.visible) {
            [self.window makeKeyAndOrderFront:self];
        }
        return NO;
    }
    while ((status = streams.out.streamStatus) != NSStreamStatusOpen) {};
    return YES;
}

// Service method for doing the actual posting to console in the main run loop

- (void)post:(NSAttributedString *)attrStr;
{
    [consoleView.textStorage appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange(consoleView.textStorage.length, 0)];
}

// Post a message about the results of an exchange with the pump

- (void)postExchange:(NSString *)message reply:(uint8_t *)pBuffer length:(NSInteger)length;
{
    NSString *statusString, *errorString;
    NSMutableAttributedString *attrStr;
    NSDictionary *attr;

    attr = @{NSForegroundColorAttributeName: [NSColor blackColor]};

    attrStr = [[NSMutableAttributedString alloc] initWithString:message attributes:attr];
    [attrStr replaceCharactersInRange:NSMakeRange(attrStr.length - 1, 1) withString:@": "];
    if (pBuffer[0] != 2 || pBuffer[length - 1] != 3) {  // look for <STX> and <ETX> that start and end TX.
        attr = @{NSForegroundColorAttributeName: [NSColor redColor]};
        [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:@"Reply missing <STX> or <ETX>\n"
                    attributes:attr] autorelease]];
    }
    else if (strncmp((char *)&pBuffer[1], "00", 2) != 0) {  // should always get the default pump address, "00"
        attr = @{NSForegroundColorAttributeName: [NSColor redColor]};
        [attrStr appendAttributedString:[[[NSAttributedString alloc]
                    initWithString:[NSString stringWithFormat:@"Wrong pump address: %c%c\n", pBuffer[1], pBuffer[2]]
                    attributes:attr] autorelease]];
    }
    else {
        pBuffer[length - 1] = '\0';                         // null terminate the string
        if (pBuffer[3] != '?') {
            statusString = statusDict[[NSString stringWithFormat:@"%c", pBuffer[3]]];
            statusString = (statusString == nil) ? @"(unrecognized status code)\n" : statusString;
            if (length == 5) {                                  // only the pump state character
                attr = @{NSForegroundColorAttributeName: [NSColor blueColor]};
                [attrStr appendAttributedString:[[[NSAttributedString alloc] initWithString:statusString
                        attributes:attr] autorelease]];
            }
            else if (pBuffer[4] != '?') {                       // state character plus additional data, no error
                attr = @{NSForegroundColorAttributeName: [NSColor blueColor]};
                [attrStr appendAttributedString:[[[NSAttributedString alloc]
                        initWithString:[NSString stringWithFormat:@"%s %@", &pBuffer[4], statusString]
                        attributes:attr] autorelease]];
            }
            else {
                attr = @{NSForegroundColorAttributeName: [NSColor redColor]};
                errorString = errorDict[[NSString stringWithFormat:@"%s", &pBuffer[4]]];
                if (errorString == nil) {
                    errorString = [NSString stringWithFormat:@"(unrecognized error code: %s)\n", &pBuffer[4]];
                }
                [attrStr appendAttributedString:[[[NSAttributedString alloc]
                        initWithString:errorString attributes:attr] autorelease]];
            }
        }
    }
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

// Post information about informational and error messages

- (void)postInfo:(NSString *)str textColor:(NSColor *)theColor;
{
    NSAttributedString *attrStr;
    NSDictionary *attr = @{NSForegroundColorAttributeName: theColor};

    attrStr = [[NSAttributedString alloc] initWithString:str attributes:attr];
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

// Communicate with pump. Open streams, send message, get reply, display reply, close streams.

- (BOOL)writeMessage:(NSString *)message;
{
    long i, result;
    NSError *error;
    uint32_t bufferLength;
    const char *cString;
    NSInteger readLength;
    uint8_t pBuffer[kBufferLength];
    double startTime;
    static double lastWriteTimeS = 0.0;

    if (lastWriteTimeS != 0) {          // NE500 needs a delay between stream close and stream open
        while ([LLSystemUtil getTimeS] - lastWriteTimeS < kLLNE500MinDelayS) {
            usleep(5000);
        }
    }
    [streamsLock lock];
    if (![self openStreams]) {      // If we've failed to communicate, clear flag to init when pump returns
        previousUL = -1;
        exists = NO;
        lastWriteTimeS = [LLSystemUtil getTimeS];
        [streamsLock unlock];
        return exists;
    }
    cString = [message cStringUsingEncoding:NSUTF8StringEncoding];
    bufferLength = (uint32_t)strlen(cString);
    result = [streams.out write:(uint8_t *)cString maxLength:bufferLength];     // write to pump
    if (result != bufferLength) {
        error = streams.out.streamError;
        [self postInfo:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                             error.code, error.localizedDescription] textColor:[NSColor redColor]];
        if (!self.window.visible) {
            [self.window makeKeyAndOrderFront:self];
        }
        [self closeStreams];
        previousUL = -1;
        exists = NO;
        lastWriteTimeS = [LLSystemUtil getTimeS];
        [streamsLock unlock];
        return exists;
    }
    startTime = [LLSystemUtil getTimeS];
    while (!streams.in.hasBytesAvailable) {                                   // get pump response
        if ([LLSystemUtil getTimeS] - startTime > kLLNE500TimeOutS) {
            [self postInfo:@"Timeout error on response\n" textColor:[NSColor redColor]];
            [self closeStreams];
            previousUL = -1;
            exists = NO;
            lastWriteTimeS = [LLSystemUtil getTimeS];
            [streamsLock unlock];
           return exists;
        }
        usleep(5000);
    };
    usleep(15000);                                          // pump needs 15 ms from the arrival of first character
    for (i= 0; i < kBufferLength; i++) {
        pBuffer[i] = 0;
    }
    readLength = [streams.in read:pBuffer maxLength:kBufferLength];
    [self closeStreams];
    [self postExchange:message reply:pBuffer length:readLength];    // post the exchange to the window
    lastWriteTimeS = [LLSystemUtil getTimeS];
    [streamsLock unlock];

    // If we've succeeded where previously we've failed (or not been initialized), then we need to reinitialize
    // the pump.  Setting 'exists' here first avoids infinite recursion. Must unlock streeamsLock before this.

    if (!exists) {
        exists = YES;
        [self writeMessage:@"BP 0\r"];
        [self writeMessage:@"AL 0\r"];
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
