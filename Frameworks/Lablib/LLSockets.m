//
//  LLSockets.m
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//
//

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

#define kLLSocketsHostKey   @"LLSocketsHost"
#define kLLSocketsPort      @"LLSocketsPort"
#define kLLSocketsScroll    @"LLSocketsScroll"

enum {kReceiveJSON = 1, kStop};

#import "LLSockets.h"

CFReadStreamRef readStream;
CFWriteStreamRef writeStream;

NSInputStream *inputStream;
NSOutputStream *outputStream;

@implementation LLSockets

-(void)awakeFromNib;
{
//    [self setLoadButtonTitle:LOAD_BUTTON_TITLE];
//    [self setPath:Nil];
//    [self setStatus:STATUS_NONE_LOADED];
//    in_grouped_window = NO;
//    self.scrollToBottomOnOutput = [[NSUserDefaults standardUserDefaults]
//                                   boolForKey:DEFAULTS_SCROLL_TO_BOTTOM_ON_OUTPUT_KEY];
//    
//    // Automatically terminate script at application shutdown
//    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil
//                                                       queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
//                                                           [self terminateScript]; }];
}

- (void)dealloc;
{
    [self close];
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
    [defaultSettings setObject:[NSNumber numberWithInt:9990] forKey:kLLSocketsPort];
    [defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:kLLSocketsScroll];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];
    return self;
}

- (IBAction)loadButtonPress:(id)sender;
{
}

- (void)setupAndOpen;
{
    NSURL *url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:kLLSocketsHostKey]];
    int port = (int)[[NSUserDefaults standardUserDefaults] integerForKey:kLLSocketsPort];
    
    if ([self window] == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLSockets" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
    }
    
    NSLog(@"LLSockets: Setting up connection to %@:%i", [url absoluteString], port);
    
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (CFStringRef)[url host], port, &readStream, &writeStream);
    if (!CFWriteStreamOpen(writeStream)) {
        NSLog(@"LLSockets: Error, writeStream not open");
        return;
    }
    [self open];
}

- (void)open;
{
    NSLog(@"LLSockets: opening streams");
    inputStream = (NSInputStream *)readStream;
    outputStream = (NSOutputStream *)writeStream;
    [inputStream retain];
    [outputStream retain];
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void)postToConsole:(NSAttributedString *)attstr;
{
    [[consoleView textStorage] appendAttributedString:attstr];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLSocketsScroll]) {
        [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
    }
}

- (void)close;
{
    NSLog(@"LLSockets: Closing streams");
    [inputStream close];
    [outputStream close];
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream setDelegate:nil];
    [outputStream setDelegate:nil];
    [inputStream release];
    [outputStream release];
    inputStream = nil;
    outputStream = nil;
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event;
{
    switch (event) {
        case NSStreamEventOpenCompleted:
            NSLog(@"%@", [NSString stringWithFormat:@"LLSockets: %@putStream opened",
                          (stream == outputStream) ? @"out" : @"in"]);
            break;
        case NSStreamEventHasSpaceAvailable: {
            if (stream == outputStream) {
                NSLog(@"LLSockets: outputStream has space available");
            }
            break;
        }
        case NSStreamEventHasBytesAvailable: {
            if (stream == inputStream) {
                NSLog(@"LLSockets: NSStreamEventHasBytesAvailable");
                if (![inputStream hasBytesAvailable]) {
                    NSLog(@"LLSockets: inputStream says no bytes available");
                    break;
                }
                uint8_t buf[1024];
                unsigned int len = 0;
                
                len = (unsigned int)[inputStream read:buf maxLength:1024];
                if (len > 0) {
                    NSMutableData* data=[[NSMutableData alloc] initWithLength:0];
                    [data appendBytes: (const void *)buf length:len];
                    NSString *s = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                    [self readIn:s];
                    [data release];
                }
            } 
            break;
        }
        case NSStreamEventErrorOccurred:
            NSLog(@"%@", [NSString stringWithFormat:@"LLSockets: %@putStream error",
                          (stream == outputStream) ? @"out" : @"in"]);
            break;
        case NSStreamEventEndEncountered:
            NSLog(@"%@", [NSString stringWithFormat:@"LLSockets: %@putStream end encountered",
                          (stream == outputStream) ? @"out" : @"in"]);
            break;
        default: {
            NSLog(@"Stream is sending an Event: %lu", (unsigned long)event);
            break;
        }
    }
}

- (void)readIn:(NSString *)s;
{
    NSLog(@"LLSockets: Read in the following:");
    NSLog(@"LLSockets: %@", s);
}

- (void)writeDictionary:(NSDictionary *)dict;
{
    NSData *JSONData;
    NSError *error;
    uint32_t length;
//    id JSONObject;

    if ([outputStream streamStatus] != NSStreamStatusOpen) {
        return;
    }
    while ([outputStream streamStatus] == NSStreamStatusWriting) {};
    JSONData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    NSLog(@"LLSockets: Writing JSON data with length %lu", (unsigned long)[JSONData length]);
//    JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:&error];
//    if (JSONObject != nil) {
//        [NSJSONSerialization writeJSONObject:JSONObject toStream:outputStream options:0 error:&error];
//    }
    length = (uint32_t)[JSONData length];
    [outputStream write:(uint8_t *)&length maxLength:sizeof(uint32_t)];
    [outputStream write:(uint8_t *)[JSONData bytes] maxLength:length];
}

- (void)writeOut:(NSString *)s;
{
    uint8_t buf[1024];                              // buffer to transmit
    uint32_t *pLength = (uint32_t *)&buf;           // 4 bytes to specify length
    char *pChars = (char *)&buf[sizeof(uint32_t)];  // char * after the length specifier
    
    *pLength  = (uint32_t)strlen([s UTF8String]);   // load the length of the payload
    strcpy(pChars, (char *)[s UTF8String]);         // load the payload
    
    [outputStream write:(uint8_t *)&buf maxLength:sizeof(unsigned long) + strlen(pChars)];
    
    NSLog(@"LLSockets: Writing out the following:");
    NSLog(@"LLSockets: %@", s);
}

@end
