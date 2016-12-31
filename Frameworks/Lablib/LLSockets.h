//
//  LLSockets.h
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//
//

#import <Foundation/Foundation.h>

@interface LLSockets : NSWindowController<NSStreamDelegate> {
//@public
//    IBOutlet NSButton       *connectButton;
    IBOutlet NSTextView     *consoleView;
    IBOutlet NSTextField    *hostTextField;
//    BOOL                    outputStreamHasSpaceAvailable;
    IBOutlet NSTextField    *portTextField;
//    NSLock                  *postingLock;
//    IBOutlet NSTextField    *statusTextField;
//    BOOL                    streamsSetUp;
    NSArray                 *topLevelObjects;
    NSLock                  *streamsLock;
}

//- (void)createAndOpen;
//- (void)close;
- (void)closeStreams;
//- (void)open;
- (BOOL)openStreams;
- (void)postToConsole:(NSString *)str textColor:(NSColor *)textColor;
//- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event;
//- (void)takeDownStreams;
//- (void)readIn:(NSString *)s;
- (void)writeDictionary:(NSDictionary *)dict;
//- (void)writeOut:(NSString *)s;

//- (IBAction)doConnectButton:(id)sender;

@end
