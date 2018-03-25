//
//  LLMatlabEngine.m
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//

#import "LLMatlabEngine.h"
#import <Lablib/LLSystemUtil.h>
typedef uint16_t char16_t;                  // Matlab engine uses a type that isn't defined by CLANG
#include "engine.h"

#define kLLMatlabDoCommandsKey      @"LLMatlabDoCommands"
#define kLLMatlabDoResponsesKey     @"LLMatlabDoResponses"
#define kLLMatlabDoErrorsKey        @"LLMatlabDoErrors"
#define kLLMatlabWindowVisibleKey   @"kLLMatlabWindowVisible"

// We make pEngine a class variable because there should only be one engine running at a time.  Additionally,
// this means that everyone who uses "Lablib" won't have to include the path to the folder containing the Matlab
// header, engine.h.

Engine  *pEngine;

@implementation LLMatlabEngine : NSWindowController

- (void)addMatlabPathForApp;
{
    NSString *appMatlabString;

    appMatlabString = [NSString stringWithFormat:@"addpath('%@/Matlab/')", [NSBundle mainBundle].resourcePath];
    [self evalString:appMatlabString postResult:NO];
//    engEvalString(pEngine, appMatlabString.UTF8String);
}

- (void)addMatlabPathForPlugin:(NSString *)pluginName;
{
    NSEnumerator *enumerator;
    NSString *matlabPath;
    NSString *searchSuffix = [NSString stringWithFormat:@"/%@.plugin", pluginName];
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleExecutable"];
    NSMutableArray *bundlePaths = [NSMutableArray arrayWithArray:[LLSystemUtil allBundlesWithExtension:@"plugin"
                            appSubPath:[NSString stringWithFormat:@"Application Support/%@/Plugins", appName]]];

    enumerator = [bundlePaths objectEnumerator];
    while ((matlabPath = [enumerator nextObject])) {
        if ([matlabPath hasSuffix:searchSuffix]) {
            matlabPath = [matlabPath stringByAppendingString:@"/Contents/Resources/Matlab/"];
            [self evalString:[NSString stringWithFormat:@"addpath('%@')", matlabPath] postResult:NO];
//            engEvalString(pEngine, [NSString stringWithFormat:@"addpath('%@')", matlabPath].UTF8String);
            break;
        }
    }
    if (matlabPath == nil) {
        [LLSystemUtil runAlertPanelWithMessageText:@"LLMatlabEngine:"
                informativeText:[NSString stringWithFormat:@"Failed to find Matlab resources for %@", pluginName]];
    }
}

- (void)close;
{
    if (pEngine != nil) {
        engClose(pEngine);
    }
    pEngine = nil;
}

- (void)dealloc;
{
    self.launchLock = nil;
    self.commandBuffer = nil;
    self.controller = nil;
    self.postBuffer = nil;
    [engineLock release];
    [attrBlack release];
    [attrBlue release];
    [attrRed release];
    [[NSUserDefaults standardUserDefaults] setBool:self.window.visible forKey:kLLMatlabWindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (instancetype)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }
    if (pEngine == nil) {
        defaultSettings = [[NSMutableDictionary alloc] init];
        defaultSettings[kLLMatlabDoCommandsKey] = @YES;
        defaultSettings[kLLMatlabDoResponsesKey] = @YES;
        defaultSettings[kLLMatlabDoErrorsKey] = @YES;
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
        [defaultSettings release];

        attrBlack = @{NSForegroundColorAttributeName: [NSColor blackColor]};
        [attrBlack retain];
        attrBlue = @{NSForegroundColorAttributeName: [NSColor blueColor]};
        [attrBlue retain];
        attrRed = @{NSForegroundColorAttributeName: [NSColor redColor]};
        [attrRed retain];

        _commandBuffer = [[NSMutableArray alloc] init];
        _postBuffer = [[NSMutableArray alloc] init];
        _launchLock = [[NSLock alloc] init];

        engineLock = [[NSLock alloc] init];
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLMatlabEngine" owner:self topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLMatlabWindowVisibleKey] || YES) {
            [self.window makeKeyAndOrderFront:self];
        }
        _launching = YES;                               // set here, takes a while for NSThread to run
        [NSThread detachNewThreadSelector:@selector(launchMatlabEngine) toTarget:self withObject:nil];
    }
    return self;
}

//- (void *)engine;
//{
//    return (void *)pEngine;
//}
//
- (NSString *)evalString:(NSString *)string;
{
    return [self evalString:string postResult:YES];
}

- (NSString *)evalString:(NSString *)string postResult:(BOOL)doPosting;
{
    return [self evalString:string postResult:doPosting ignoreLaunchLock:NO];
}

// Ask Matlab to evaluate a string.  We bundle every string in a "try/catch" block, so that if there is an error the
// text will return to us, rather than going to stderr.  We include a diagnostic "disp()" command, which lets us
// distinguish Matlab errors from other other Matlab responses.

// Note: For some reason, some of the exceptions coming back from Matlab seems to have no "stack" entry.  In that
// case, the command to ask for the information at ex.stack(1) causes Matlab to give up and send a message about
// 'index exceeds matrix limit' to stderr.  So I've put in a check on the length of the stack.

- (NSString *)evalString:(NSString *)string postResult:(BOOL)doPosting ignoreLaunchLock:(BOOL)ignoreLock;
{
    NSRange errorCodeRange;
    NSString *commandStr, *outputStr, *subStr, *formatting;

    // If we are still launching, buffer the commands. They will be executed by -launchMatlabEngine once it has
    // the engine launched. -launchMatlabEngine locks _launchLock and sets ignoreLaunchLock to YES when it sends
    // the buffered commands. _launchLock is used here to make sure that the string and doPosting arguments are
    // stored in the same order. If it is locked, that means that -launchMatlabEngine is currently draining the buffers,
    // so we just wait for that to complete.

    if (!ignoreLock && self.launching) {
        NSLog(@"LLMatlabEngine: Launching, buffering command: %@", string);
        [self.launchLock lock];                 // get the lock
        if (self.launching) {                   // locked and still launching
            [self.commandBuffer addObject:string];
            [self.postBuffer addObject:[NSNumber numberWithBool:doPosting]];
            [self.launchLock unlock];
            return nil;
        }
        [self.launchLock unlock];               // launch finished before we got the lock, do evalString now
    }
    if (pEngine == nil) {       // there might be no Matlab engine to run. If so, just return.
        return nil;
    }
    [engineLock lock];
    formatting = @"'File: %s, Function: %s, Line: %djhrmNEWLINE'";
    commandStr = [NSString stringWithFormat:
                  @"try,%@,"
                  "catch ex,"
                  "display('jhrmERROR'),"
                  "if length(ex.stack) > 0,"
                    "[~,name,~]=fileparts(ex.stack(1).file);,"
                    "display(sprintf(%@, name, ex.stack(1).name, ex.stack(1).line)),"
                  "end,"
                  "display(ex.message),"
                  "end",
                  string, formatting];
    engEvalString(pEngine, commandStr.UTF8String);
    [engineLock unlock];
    
    [self preparePosting:[string stringByAppendingString:@"\n"] enabledKey:kLLMatlabDoCommandsKey];
    if (strlen(outputBuffer) > 0) {
        outputStr = [@(outputBuffer)   // prettify: remove '\n's and '  's
                        stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"jhrmNEWLINE" withString:@"\n\t"];
        if (doPosting) {
            errorCodeRange = [outputStr rangeOfString:@" jhrmERROR"];
            if (errorCodeRange.length == 0) {
                [self preparePosting:[NSString stringWithFormat:@"  %@\n", outputStr]
                                                                            enabledKey:kLLMatlabDoResponsesKey];
            }
            else if (errorCodeRange.location == 2) {                // whole message is an error message
                subStr = [outputStr substringFromIndex:(errorCodeRange.length + 3)];    // strip error code
                [self preparePosting:[NSString stringWithFormat:@"  >>%@\n", subStr] enabledKey:kLLMatlabDoErrorsKey];
            }
            else {                                                  // normal message precedes error message
                subStr = [outputStr substringToIndex:errorCodeRange.location];    // strip error code
                [self preparePosting:[NSString stringWithFormat:@"  %@\n", subStr] enabledKey:kLLMatlabDoResponsesKey];
                subStr = [outputStr substringFromIndex:(errorCodeRange.location + errorCodeRange.length + 1)];
                [self preparePosting:[NSString stringWithFormat:@"  >>%@\n", subStr] enabledKey:kLLMatlabDoErrorsKey];
            }
        }
        return outputStr;
    }
    else {
        return nil;
    }
}

- (void)launchMatlabEngine;
{
    NSString *outputStr;
    NSNumber *doPost;

    NSLog(@"LLMatlabEngine: Launching Matlab");
    [engineLock lock];
    if (!(pEngine = engOpen("/bin/csh -c /Applications/MATLAB/bin/matlab"))) {
        NSLog(@"LLMatlabEngine: Can't start Matlab engine");
        [engineLock unlock];
        self.launching = NO;
        return;
    }
    NSLog(@"LLMatlabEngine: Matlab launched");
    outputBuffer[kBufferLength - 1] = '\0';                     // Matlab won't null terminate C strings
    engOutputBuffer(pEngine, (char *)outputBuffer, kBufferLength);

    // Display the Matlab version that's running

    engEvalString(pEngine, "builtin('version')");
    [engineLock unlock];
    if (strlen(outputBuffer) > 0) {
        outputStr = [@(outputBuffer)   // prettify: remove '\n's and '  's
                     stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@">> ans =" withString:@""];
        [self preparePosting:[NSString stringWithFormat:@"Matlab Version %@\n", outputStr]
                  enabledKey:kLLMatlabDoResponsesKey];
    }
    // Any commands that arrived while we were launching Matlab will have been buffered.  Execute them now in the
    // order that they were received.
    [self.launchLock lock];
    while ([self.commandBuffer count] > 0) {
        NSLog(@"LLMatlabEngine: -launchMatlabEngine: doing command: %@", [self.commandBuffer objectAtIndex:0]);
        doPost = [self.postBuffer objectAtIndex:0];
        [self evalString:[self.commandBuffer objectAtIndex:0] postResult:[doPost boolValue] ignoreLaunchLock:YES];
        [self.commandBuffer removeObjectAtIndex:0];
        [self.postBuffer removeObjectAtIndex:0];
    }
    self.launching = NO;
    [self.launchLock unlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLLMatlabDidLaunchKey object:self];
}

- (void)post:(NSAttributedString *)attrStr;
{
    [consoleView.textStorage appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange(consoleView.textStorage.length, 0)];
}

- (void)preparePosting:(NSString *)string enabledKey:(NSString *)key
{
    NSAttributedString *attrStr;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:key]) {
        return;
    }
    if ([key isEqualToString:kLLMatlabDoErrorsKey]) {
        attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrRed];
    }
    else if ([key isEqualToString:kLLMatlabDoResponsesKey]) {
        attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrBlue];
    }
    else  {
        attrStr = [[NSAttributedString alloc] initWithString:string attributes:attrBlack];
    }
    [self performSelectorOnMainThread:@selector(post:) withObject:attrStr waitUntilDone:NO];
    [attrStr release];
}

- (IBAction)windowFront:(id)sender;
{
    [self evalString:@"shg"];
}

@end 
