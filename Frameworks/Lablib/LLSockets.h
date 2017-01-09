//
//  LLSockets.h
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//
//

#import <Foundation/Foundation.h>

@interface LLSockets : NSWindowController<NSStreamDelegate> {

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

@end
