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
#define kLLNE500VerboseKey       @"LLNE500Verbose"
#define kLLNE500WindowVisibleKey  @"kLLNE500WindowVisible"
#define kLLNE500NumStatusStrings   9

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
    [streamsLock release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLNE500WindowVisibleKey];
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
    [defaultSettings setObject:@"10.1.1.1" forKey:kLLNE500HostKey];
//    [defaultSettings setObject:@"Rig0" forKey:kLLSocketsRigIDKey];
    [defaultSettings setObject:[NSNumber numberWithInt:100] forKey:kLLNE500PortKey];
    [defaultSettings setObject:[NSNumber numberWithBool:NO] forKey:kLLNE500VerboseKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];
    
    streamsLock = [[NSLock alloc] init];

    if ([self window] == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLNE500Pump" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLNE500WindowVisibleKey] || YES) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    [self postToConsole:@"LLNE500Pump initialized\n" textColor:[NSColor blackColor]];
    return self;
}

- (BOOL)openStreams;
{
    long status;
    
//    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLNE500HostKey]];
//    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLNE500PortKey];

    [streamsLock lock];
//    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &NE500ReadStream, &NE500WriteStream);
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)@"10.1.1.1", 23, &NE500ReadStream, &NE500WriteStream);
    NE500InputStream = (NSInputStream *)NE500ReadStream;
    NE500OutputStream = (NSOutputStream *)NE500WriteStream;
    [NE500InputStream retain];
    [NE500OutputStream retain];
    [NE500InputStream open];
    [NE500OutputStream open];
    while ((status = [NE500InputStream streamStatus]) == NSStreamStatusOpening) {};
    status = [NE500InputStream streamStatus];
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
    while ((status = [NE500InputStream streamStatus]) != NSStreamStatusOpen) {};
    
    while ((status = [NE500OutputStream streamStatus]) == NSStreamStatusOpening) {};
    status = [NE500OutputStream streamStatus];
    switch (status) {
        case NSStreamStatusError:
            [self postToConsole:@"openStreams: error opening output stream\n" textColor:[NSColor redColor]];
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

    //    [dict setObject:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsRigIDKey] forKey:@"rigID"];
    JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    JSONLength = (uint32_t)[JSONData length];
    bufferLength = JSONLength + sizeof(uint32_t);
    *(uint32_t *)pBuffer = JSONLength;
    [JSONData getBytes:&pBuffer[sizeof(uint32_t)] length:JSONLength];

    result = [NE500OutputStream write:pBuffer maxLength:bufferLength];

    if (result != bufferLength) {
        error = [NE500OutputStream streamError];
        [self postToConsole:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                             error.code, error.localizedDescription] textColor:[NSColor redColor]];
        if (![[self window] isVisible]) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }

    while (![NE500InputStream hasBytesAvailable]) {};
    readLength = [NE500InputStream read:pBuffer maxLength:kBufferLength];
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLNE500VerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@"Received: %s\n", pBuffer] textColor:[NSColor blackColor]];
        [self postToConsole:[NSString stringWithFormat:@"Delay to write %.1f ms\n", 1000.0 * (endTime - startTime)]
                  textColor:[NSColor blackColor]];
    }
}

- (void)writeMessage:(NSString *)message;
{
    NSError *error;
    uint32_t bufferLength;
    const char *cString;
//    NSInteger readLength;
//    uint8_t pBuffer[kBufferLength];
    long result;
    double startTime;
//    double endTime;

    startTime = [LLSystemUtil getTimeS];
    if (![self openStreams]) {
        return;
    }
    cString = [message cStringUsingEncoding:NSUTF8StringEncoding];
    bufferLength = (uint32_t)strlen(cString);
    result = [NE500OutputStream write:(uint8_t *)cString maxLength:bufferLength];
    if (result != bufferLength) {
        error = [NE500OutputStream streamError];
        [self postToConsole:[NSString stringWithFormat:@"Output stream error (%ld): %@\n",
                             error.code, error.localizedDescription] textColor:[NSColor redColor]];
        if (![[self window] isVisible]) {
            [[self window] makeKeyAndOrderFront:self];
        }
    }
    [self closeStreams];
/*
    while (![NE500InputStream hasBytesAvailable]) {};
    readLength = [NE500InputStream read:pBuffer maxLength:kBufferLength];
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
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLNE500VerboseKey]) {
        [self postToConsole:[NSString stringWithFormat:@"Received: %s\n", pBuffer] textColor:[NSColor blackColor]];
        [self postToConsole:[NSString stringWithFormat:@"Delay to write %.1f ms\n", 1000.0 * (endTime - startTime)]
                  textColor:[NSColor blackColor]];
    }
 */
}

@end

/*

 bool NE500PumpNetworkDevice::sendMessage(const std::string &pump_id, string message) {
 if (!connection->isConnected()) {
 merror(M_IODEVICE_MESSAGE_DOMAIN, "No connection to NE500 device");
 return false;
 }

 message = pump_id + " " + message + "\r";
 if (!connection->send(message)) {
 return false;
 }

 if (logPumpCommands) {
 mprintf(M_IODEVICE_MESSAGE_DOMAIN, "SENT: %s", removeControlChars(message).c_str());
 }

 // give it a moment
 shared_ptr<Clock> clock = Clock::instance();
 MWTime tic = clock->getCurrentTimeUS();

 bool broken = false;
 string result;
 bool success = true;
 bool is_alarm = false;

 while (true) {
 if (!connection->receive(result)) {
 broken = true;
 }

 // if the response is complete
 // NE500 responses are of the form: "\t01S"
 if (result.size() > 1 && result.back() == PUMP_SERIAL_DELIMITER_CHAR) {

 if(result.size() > 3){
 char status_char = result[3];


 switch(status_char){
 case 'S':
 case 'W':
 case 'I':
 break;

 case 'A':
 is_alarm = true;
 break;

 default:
 merror(M_IODEVICE_MESSAGE_DOMAIN,
 "An unknown response was received from the syringe pump: %c", status_char);
 success = false;
 break;
 }
 }

 if (result.size() > 4 && !is_alarm) {

 char error_char = result[4];
 if(error_char == '?'){
 string error_code = result.substr(5, result.size() - 6);
 string err_str("");

 if(error_code == ""){
 err_str = "Unrecognized command";
 } else if(error_code == "OOR"){
 err_str = "Out of Range";
 } else if(error_code == "NA"){
 err_str = "Command currently not applicable";
 } else if(error_code == "IGN"){
 err_str = "Command ignored";
 } else if(error_code == "COM"){
 err_str = "Communications failure";
 } else {
 err_str = "Unspecified error";
 }

 merror(M_IODEVICE_MESSAGE_DOMAIN,
 "The syringe pump returned an error: %s (%s)", err_str.c_str(), error_code.c_str());
 success = false;
 }
 }

 break;

 } else if ((clock->getCurrentTimeUS() - tic) > response_timeout) {
 merror(M_IODEVICE_MESSAGE_DOMAIN, "Did not receive a complete response from the pump");
 success = false;
 break;
 }
 }

 if (broken) {
 merror(M_IODEVICE_MESSAGE_DOMAIN,
 "Connection lost, reconnecting..."
 "Command may not have been sent correctly");
 connection->disconnect();
 connection->connect();
 }

 if (!result.empty()) {
 if (is_alarm) {
 mwarning(M_IODEVICE_MESSAGE_DOMAIN,
 "Received alarm response from NE500 device: %s",
 removeControlChars(result).c_str());
 } else if (logPumpCommands) {
 mprintf(M_IODEVICE_MESSAGE_DOMAIN, "RETURNED: %s", removeControlChars(result).c_str());
 }
 }

 return success;
 }


 void NE500PumpNetworkDevice::NE500DeviceOutputNotification::notify(const Datum &data, MWTime timeUS) {
 if (auto shared_pump_network = pump_network.lock()) {
 if (auto shared_channel = channel.lock()) {
 scoped_lock active_lock(shared_pump_network->active_mutex);
 auto sendMessage = shared_pump_network->getSendFunction();

 if (shared_channel->update(sendMessage) &&
 shared_pump_network->active)
 {
 shared_channel->dispense(sendMessage);
 }
 }
 }
 }


 END_NAMESPACE_MW

*/
