//
//  LLNE500Pump
//  Lablib
//
//  Created by John Maunsell on 02/02/17.
//
//

#import <Foundation/Foundation.h>

typedef struct {
    NSInputStream *in;
    NSOutputStream *out;
} LLStreams;


@interface LLNE500Pump : NSWindowController<NSStreamDelegate> {

    IBOutlet NSTextView     *consoleView;
    NSDictionary            *errorDict;
    BOOL                    exists;
    IBOutlet NSTextField    *hostTextField;
    BOOL                    notCommunicating;
    IBOutlet NSTextField    *portTextField;
    float                   previousUL;
    IBOutlet NSTextField    *rigIDTextField;
    NSArray                 *topLevelObjects;
    NSDictionary            *statusDict;
    LLStreams               streams;
    NSLock                  *streamsLock;
}

- (void)closeStreams;
- (void)doMicroliters:(float)microliters;
- (void)postExchange:(NSString *)message reply:(uint8_t *)pBuffer length:(NSInteger)length;
- (void)postInfo:(NSString *)str textColor:(NSColor *)theColor;
- (BOOL)writeMessage:(NSString *)message;

@property (readonly) BOOL exists;

@end
