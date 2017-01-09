//
//  LLMatlabEngine.m
//  Lablib
//
//  Created by John Maunsell on 1/2/17.
//
// Using Matlab requires the libraries libeng.dylib and libmx.dylib.  They can be found in the Matlab folder returned
// by Matlab by the command "fullfile(matlabroot,'bin',computer('arch'))".  Typically, this is something like
// /Applications/MATLAB_R2013a.app/bin/maci64.  Note: Xcode will not work with an alias like "Matlab" that points to
// the current Matlab.  You must use actual application folder (with ".app").  The path should be added to the "Search
// Library Path" in the project settings, so that the linker can resolve the Matlab refernces.  It must also be added
// to the "Runpath Search Path", so that the Matlab dylibs can be found at run time.

// We also need "engine.h", which is a location Matlab identifies when queried with
// "fullfile(matlabroot,'extern','include')".  It will be something like
// "/Applications/MATLAB_R2013a.app/extern/include".  This should be added to the "Header Search Paths" in the
// project settings.

// The demonstration programs show starting Matlab with a null argument, but that didn't work, even when Matlab
// could be launched at the csh command line with "matlab".

//cd /usr/local/bin/
//sudo ln -s /usr/local/MATLAB/R2012a/bin/matlab matlab

#import "LLSystemUtil.h"
#import "LLMatlabEngine.h"
typedef uint16_t char16_t;                  // Matlab engine uses a type that isn't defined by CLANG
#include <engine.h>

#define kLLMatlabDoCommandsKey      @"LLMatlabDoCommands"
#define kLLMatlabDoResponsesKey     @"LLMatlabDoResponses"
#define kLLMatlabDoErrorsKey        @"LLMatlabDoErrors"
#define kLLMatlabWindowVisibleKey   @"kLLMatlabWindowVisible"

// We make pEngine a class variable because there should only be one engine running at a time.  Additionally,
// this mean that everyone who uses "Lablib" won't have to include the path to the folde containing the Matlab
// header engine.h.  For the same reason, we cast pEngine as (void *) to pass it around, so that everyone that uses
// Matlab won't have to have Matlab in their search paths.

Engine  *pEngine;

@implementation LLMatlabEngine : NSWindowController

- (void)addMatlabPathForPlugin:(NSString *)pluginName;
{
    NSEnumerator *enumerator;
    NSString *matlabPath;
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    NSMutableArray *bundlePaths = [NSMutableArray arrayWithArray:[LLSystemUtil allBundlesWithExtension:@"plugin"
                            appSubPath:[NSString stringWithFormat:@"Application Support/%@/Plugins", appName]]];

    enumerator = [bundlePaths objectEnumerator];
    while ((matlabPath = [enumerator nextObject])) {
        if ([matlabPath containsString:pluginName]) {
            matlabPath = [matlabPath stringByAppendingString:@"/Contents/Resources/Matlab/"];
            engEvalString(pEngine, [[NSString stringWithFormat:@"addpath('%@')", matlabPath] UTF8String]);
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
    [engineLock release];
    [attrBlack release];
    [attrBlue release];
    [attrRed release];
    [[NSUserDefaults standardUserDefaults] setBool:[[self window] isVisible] forKey:kLLMatlabWindowVisibleKey];
    [topLevelObjects release];
    [super dealloc];
}

- (id)init;
{
    NSMutableDictionary *defaultSettings;

    if ((self = [super init]) == nil) {
        return nil;
    }
    if (pEngine == nil) {
        NSLog(@"LLMatlabEngine: Launching Matlab");
        if (!(pEngine = engOpen("/bin/csh -c /Applications/MATLAB_R2013a.app/bin/matlab"))) {
            NSLog(@"LLMatlabEngine: Can't start Matlab engine");
            return self;
        }
        NSLog(@"LLMatlabEngine: Matlab launched");
        outputBuffer[kBufferLength - 1] = '\0';                     // Matlab won't null terminate C strings
        engOutputBuffer(pEngine, (char *)outputBuffer, kBufferLength);
    }
    defaultSettings = [[NSMutableDictionary alloc] init];
    [defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:kLLMatlabDoCommandsKey];
    [defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:kLLMatlabDoResponsesKey];
    [defaultSettings setObject:[NSNumber numberWithBool:YES] forKey:kLLMatlabDoErrorsKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultSettings];
    [defaultSettings release];

    attrBlack = [NSDictionary dictionaryWithObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
    [attrBlack retain];
    attrBlue = [NSDictionary dictionaryWithObject:[NSColor blueColor] forKey:NSForegroundColorAttributeName];
    [attrBlue retain];
    attrRed = [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
    [attrRed retain];

    engineLock = [[NSLock alloc] init];

    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLMatlabEngine" owner:self topLevelObjects:&topLevelObjects];
    [topLevelObjects retain];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kLLMatlabWindowVisibleKey] || YES) {
        [[self window] makeKeyAndOrderFront:self];
    }
    [self evalString:@"version"];

    return self;
}

- (void *)engine;
{
    return (void *)pEngine;
}

// Ask Matlab to evaluate a string.  We bundle every string in a "try/catch" block, so that if there is an error the
// text will return to us, rather than going to stderr.  We include a diagnostic "disp()" command, which lets us
// distinguish Matlab errors from other other Matlab responses.

- (void)evalString:(NSString *)string;
{
    NSUInteger errorStringIndex;
    NSString *commandStr, *outputStr;

    if (pEngine == nil) {
        return;
    }
    [engineLock lock];
//    commandStr = [NSString stringWithFormat:@"try,%@,catch ex", string];
//    commandStr = [commandStr stringByAppendingString:@",sprintf('jhrmERRORError in %s() at line "
//                  "%d: %s', ex.stack(1).name, ex.stack(1).line, ex.message),end"];
    commandStr = [NSString stringWithFormat:@"try,%@,catch ex,display('jhrmERROR'),display(ex.message),end", string];
    engEvalString(pEngine, [commandStr UTF8String]);
    [self preparePosting:[string stringByAppendingString:@"\n"] enabledKey:kLLMatlabDoCommandsKey];
    if (strlen(outputBuffer) > 0) {
        outputStr = [[NSString stringWithUTF8String:outputBuffer]   // prettify: remove '\n's and '  's
                        stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        errorStringIndex = [outputStr rangeOfString:@">> jhrmERROR"].length;
        if (errorStringIndex == 12) {                           // error string (stderr equivalent)
            outputStr = [outputStr substringFromIndex:errorStringIndex];    // strip error code
            [self preparePosting:[NSString stringWithFormat:@"  %@\n", outputStr] enabledKey:kLLMatlabDoErrorsKey];
        }
        else {
            [self preparePosting:[NSString stringWithFormat:@"  %@\n", outputStr] enabledKey:kLLMatlabDoResponsesKey];
        }
    }
    [engineLock unlock];
}

- (void)post:(NSAttributedString *)attrStr;
{
    [[consoleView textStorage] appendAttributedString:attrStr];
    [consoleView scrollRangeToVisible:NSMakeRange([[consoleView textStorage] length], 0)];
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
