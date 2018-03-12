//
//  LLMatlabEngine.h
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//
//

#import "LablibMatlab.h"

@class LLMatlabController;

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

@property (NS_NONATOMIC_IOSONLY, retain) NSMutableArray *commandBuffer;
@property (NS_NONATOMIC_IOSONLY, retain) LLMatlabController *controller;
@property (NS_NONATOMIC_IOSONLY, retain) NSLock *launchLock;
@property (NS_NONATOMIC_IOSONLY) BOOL launching;
@property (NS_NONATOMIC_IOSONLY, retain) NSMutableArray *postBuffer;

- (void)addMatlabPathForApp;
- (void)addMatlabPathForPlugin:(NSString *)pluginName;
- (void)close;
//- (BOOL)deferWorkspaceLoad:(LLMatlabController *)theController;
- (NSString *)evalString:(NSString *)string;
- (NSString *)evalString:(NSString *)string postResult:(BOOL)post;
- (void)post:(NSAttributedString *)attrStr;

- (IBAction)windowFront:(id)sender;

@end
