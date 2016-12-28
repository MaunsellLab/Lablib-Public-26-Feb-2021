//
//  LLSockets.h
//  Lablib
//
//  Created by John Maunsell on 12/26/16.
//
//

#import <Foundation/Foundation.h>

@interface LLSockets : NSWindowController<NSStreamDelegate> {
@public
    BOOL                    scrollToBottomOnOutput;
    NSArray                 *topLevelObjects;
    IBOutlet NSTextField    *hostTextField;
    IBOutlet NSTextField    *portTextField;
    IBOutlet NSTextView     *consoleView;
}

- (void)setupAndOpen;
- (void)open;
- (void)close;
- (void)postToConsole:(NSAttributedString *)attstr;
- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)event;
- (void)readIn:(NSString *)s;
- (void)writeDictionary:(NSDictionary *)dict;
- (void)writeOut:(NSString *)s;

- (IBAction)loadButtonPress:(id)sender;

@end
