//
//  LLSockets.h
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//
//

#import <Foundation/Foundation.h>

#define kReadBufferSize     1024

@interface LLSockets : NSWindowController<NSStreamDelegate> {

    long                    bytesRead;
    IBOutlet NSTextView     *consoleView;
    NSDictionary            *deviceNameDict;
    IBOutlet NSTextField    *hostTextField;
    NSInputStream           *inputStream;
    BOOL                    inputStreamOpen;
    NSOutputStream          *outputStream;
    BOOL                    outputSpaceAvailable;
    BOOL                    outputStreamOpen;
    IBOutlet NSTextField    *portTextField;
    uint8_t                 readBuffer[kReadBufferSize];
    NSMutableDictionary     *responseDict;
    IBOutlet NSTextField    *rigIDTextField;
    NSArray                 *topLevelObjects;
    NSLock                  *streamsLock;
    long                    timeoutN;
    double                  timeoutS;
    double                  timeoutTotalS;
}

- (void)closeStreams;
- (BOOL)openStreams;
- (void)postToConsole:(NSString *)str textColor:(NSColor *)textColor;
- (NSMutableDictionary *)writeDictionary:(NSMutableDictionary *)dict;

@end
