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

// Finally, the code in this file isn't specific for a particular version of Matlab, but it requires that you
// create an alias to the Matlab application (bundle) that is called "MATLAB" and is in the Application folder
// (where Matlab should reside).  This MUST be a symbolic link -- NOT an alias.  The link can be created using
// the terminal: cd /Applications; ln -s MATLAB_R2013a.app MATLAB
// Of course, you should change "2013a" as needed to match the version of Matlab that you have.


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
    NSString *outputStr;

    if ((self = [super init]) == nil) {
        return nil;
    }
    if (pEngine == nil) {
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

        NSLog(@"LLMatlabEngine: Launching Matlab");
        if (!(pEngine = engOpen("/bin/csh -c /Applications/MATLAB/bin/matlab"))) {
//        if (!(pEngine = engOpen("/bin/csh -c /Applications/MATLAB_R2013a.app/bin/matlab"))) {
            NSLog(@"LLMatlabEngine: Can't start Matlab engine");
            return self;
        }
        NSLog(@"LLMatlabEngine: Matlab launched");
        outputBuffer[kBufferLength - 1] = '\0';                     // Matlab won't null terminate C strings
        engOutputBuffer(pEngine, (char *)outputBuffer, kBufferLength);

        // Display the Matlab version that's running
        
        engEvalString(pEngine, "builtin('version')");
        if (strlen(outputBuffer) > 0) {
            outputStr = [[NSString stringWithUTF8String:outputBuffer]   // prettify: remove '\n's and '  's
                         stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            outputStr = [outputStr stringByReplacingOccurrencesOfString:@">> ans =" withString:@""];
            [self preparePosting:[NSString stringWithFormat:@"Matlab Version %@\n", outputStr]
                                    enabledKey:kLLMatlabDoResponsesKey];
        }
//       [self evalString:@"display(sprintf('Matlab Version %s', builtin('version')))"];
    }
    return self;
}

- (void *)engine;
{
    return (void *)pEngine;
}

// Ask Matlab to evaluate a string.  We bundle every string in a "try/catch" block, so that if there is an error the
// text will return to us, rather than going to stderr.  We include a diagnostic "disp()" command, which lets us
// distinguish Matlab errors from other other Matlab responses.

// Note: For some reason, some of the exceptions coming back from Matlab seems to have no "stack" entry.  In that
// case, the command to ask for the information at ex.stack(1) causes Matlab to give up and send a message about
// 'index exceeds matrix limit' to stderr.  So I've put in a check on the length of the stack.

- (void)evalString:(NSString *)string;
{
    NSRange errorCodeRange;
    NSString *commandStr, *outputStr, *subStr, *formatting;

    if (pEngine == nil) {
        return;
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
    engEvalString(pEngine, [commandStr UTF8String]);
    [self preparePosting:[string stringByAppendingString:@"\n"] enabledKey:kLLMatlabDoCommandsKey];
    if (strlen(outputBuffer) > 0) {
        outputStr = [[NSString stringWithUTF8String:outputBuffer]   // prettify: remove '\n's and '  's
                        stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"  " withString:@" "];
        outputStr = [outputStr stringByReplacingOccurrencesOfString:@"jhrmNEWLINE" withString:@"\n\t"];
        errorCodeRange = [outputStr rangeOfString:@" jhrmERROR"];
        if (errorCodeRange.length == 0) {
            [self preparePosting:[NSString stringWithFormat:@"  %@\n", outputStr] enabledKey:kLLMatlabDoResponsesKey];
        }
        else if (errorCodeRange.location == 2) {                // whole message is an error message
            subStr = [outputStr substringFromIndex:(errorCodeRange.length + 3)];    // strip error code
            [self preparePosting:[NSString stringWithFormat:@"  >>%@\n", subStr] enabledKey:kLLMatlabDoErrorsKey];
        }
        else {                                                  // normal message precedes error message
            subStr = [outputStr substringToIndex:errorCodeRange.location];    // strip error code
            [self preparePosting:[NSString stringWithFormat:@"  %@\n", subStr] enabledKey:kLLMatlabDoResponsesKey];
            subStr = [outputStr substringFromIndex:(errorCodeRange.location + errorCodeRange.length + 1)]; // strip other
            [self preparePosting:[NSString stringWithFormat:@"  >>%@\n", subStr] enabledKey:kLLMatlabDoErrorsKey];
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
