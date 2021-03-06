//
//  LLMatlabEngine.h
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//
//

#define kBufferLength   4096

@interface LLMatlabEngine : NSWindowController {

    NSDictionary        *attrBlack;
    NSDictionary        *attrBlue;
    NSDictionary        *attrRed;
    IBOutlet NSTextView *consoleView;
    NSLock              *engineLock;
    char                outputBuffer[kBufferLength];
    NSArray             *topLevelObjects;
}

- (void)addMatlabPathForApp;
- (void)addMatlabPathForPlugin:(NSString *)pluginName;
- (void)close;
- (void *)engine;
- (NSString *)evalString:(NSString *)string;
- (NSString *)evalString:(NSString *)string postResult:(BOOL)post;
- (void)post:(NSAttributedString *)attrStr;

- (IBAction)windowFront:(id)sender;

@end
