//
//  LLMatlabEngine.h
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//
//

#define kBufferLength   32768

@interface LLMatlabEngine : NSWindowController {

    NSDictionary        *attrBlack;
    NSDictionary        *attrBlue;
    NSDictionary        *attrRed;
    IBOutlet NSTextView *consoleView;
    NSLock              *engineLock;
    char                outputBuffer[kBufferLength];
    NSArray             *topLevelObjects;
}

- (void)addMatlabPathForPlugin:(NSString *)pluginName;
- (void)close;
- (void *)engine;
- (void)evalString:(NSString *)string;
- (void)post:(NSAttributedString *)attrStr;

- (IBAction)windowFront:(id)sender;

@end
