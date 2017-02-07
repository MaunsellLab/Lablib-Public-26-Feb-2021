//
//  LLNE500Pump
//  Lablib
//
//  Created by John Maunsell on 02/02/17.
//
//

#import <Foundation/Foundation.h>

@interface LLNE500Pump : NSWindowController<NSStreamDelegate> {

    IBOutlet NSTextView     *consoleView;
    IBOutlet NSTextField    *hostTextField;
    IBOutlet NSTextField    *portTextField;
    IBOutlet NSTextField    *rigIDTextField;
    NSArray                 *topLevelObjects;
    NSLock                  *streamsLock;
}

- (void)closeStreams;
- (BOOL)openStreams;
- (void)postToConsole:(NSString *)str textColor:(NSColor *)textColor;
- (void)writeDictionary:(NSMutableDictionary *)dict;
- (void)writeMessage:(NSString *)message;

@end
