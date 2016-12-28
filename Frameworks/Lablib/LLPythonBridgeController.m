//
//  LLPythonBridgePlugin.m
//  Derived from the MWorks version created by David Cox on 12/21/09.
//

#import "LLPythonBridgeController.h"

#define CONDUIT_RESOURCE_NAME  "python_bridge_plugin_conduit"
#define LOAD_BUTTON_TITLE   @"Launch"
#define TERMINATE_BUTTON_TITLE  @"Terminate"
#define STATUS_LOADING  @"Loading..."
#define STATUS_NONE_LOADED @"None loaded"
#define STATUS_ACTIVE   @"Active"
#define STATUS_TERMINATING  @"Terminating..."

#define DEFAULTS_SCROLL_TO_BOTTOM_ON_OUTPUT_KEY @"autoScrollPythonOutput"
#define kPythonVersion      2.7
#define kLLRecentPythonScriptsKey   @"LLRecentPythonScripts"

#ifdef __x86_64__
#  define PYTHON_ARCH @"x86_64"
#else
#  define PYTHON_ARCH @"i386"
#endif

//#import <MWorksCocoa/NSString+MWorksCocoaAdditions.h>
//#import <MWorksCore/IPCEventTransport.h>

@implementation LLPythonBridgeController

@synthesize path;
@synthesize status;
@synthesize loadButtonTitle;
@synthesize scrollToBottomOnOutput;


-(void)awakeFromNib;
{
    [self setLoadButtonTitle:LOAD_BUTTON_TITLE];
    [self setPath:Nil];
    [self setStatus:STATUS_NONE_LOADED];
    in_grouped_window = NO;
    self.scrollToBottomOnOutput = [[NSUserDefaults standardUserDefaults]
                                   boolForKey:DEFAULTS_SCROLL_TO_BOTTOM_ON_OUTPUT_KEY];
    
    // Automatically terminate script at application shutdown
    [[NSNotificationCenter defaultCenter] addObserverForName:NSApplicationWillTerminateNotification object:nil
                            queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
                                [self terminateScript]; }];
}

- (IBAction)chooseScript:(id)sender;
{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];         // Create & configure the open dialog object.

    [openDlg setCanChooseFiles:YES];
    [openDlg setCanChooseDirectories:NO];
    [openDlg setAllowsMultipleSelection:NO];
    
    
    // Display the dialog.  If the OK button was pressed, process the files.
    if ([openDlg runModal] == NSFileHandlingPanelOKButton) {
        NSArray *files = [openDlg URLs];                    // get array of fullpaths of all selected
        if ([files count] != 1) {                           // should be only a single array
            return;
        }
        for (int file = 0; file < [files count]; file++) {  // loop through all the files and process them.
            NSString* file_name = [[files objectAtIndex:file] path];
            if (file_name == nil) {
                return;
            }
            path = file_name;
            [self launchScriptAtPath:path];
            [self closeScriptChooserSheet:self];
        }
    }
}

- (IBAction)closeScriptChooserSheet:(id)sender;
{
    [[self window] endSheet:scriptChooseSheet];
}

- (void)doSettings;
{    
    if ([self window] == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"LLPythonBridgeController" owner:self
                                             topLevelObjects:&topLevelObjects];
        [topLevelObjects retain];
    }
    [[self window] makeKeyAndOrderFront:self];
}

- (IBAction)doScriptChooserSheet:(id)sender;
{
    [[self window] beginSheet:scriptChooseSheet completionHandler:(void (^)(NSModalResponse returnCode))nil];
}

- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode
{
    [sheet orderOut:nil];
}

- (void) setInGroupedWindow:(BOOL)isit {
    in_grouped_window = isit;
}

- (void)setScrollToBottomOnOutput:(BOOL)shouldScroll {
    if (scrollToBottomOnOutput != shouldScroll) {
        [self willChangeValueForKey:@"scrollToBottomOnOutput"];
        scrollToBottomOnOutput = shouldScroll;
        [self didChangeValueForKey:@"scrollToBottomOnOutput"];
        [[NSUserDefaults standardUserDefaults] setBool:shouldScroll forKey:DEFAULTS_SCROLL_TO_BOTTOM_ON_OUTPUT_KEY];
    }
}


- (IBAction)launchRecentScript:(id)sender{
 
    path = [recent_scripts titleOfSelectedItem];
    [self launchScriptAtPath:path];
    [self closeScriptChooserSheet:self];
}

-(void)initConduit {
//    core = [delegate coreClient];
    
    // TODO: generate a unique name to avoid name collisions
//    shared_ptr<mw::IPCEventTransport> transport(new mw::IPCEventTransport(mw::EventTransport::server_event_transport, 
//                                                                          mw::EventTransport::bidirectional_event_transport,
//                                                                          CONDUIT_RESOURCE_NAME));
    
    // build the conduit, attaching it to the core/client's event stream 
//    conduit = shared_ptr<mw::EventStreamConduit>(new mw::EventStreamConduit(transport, core));
//    conduit->initialize();
}

-(void)launchScriptAtPath:(NSString *)script_path;
{
    NSArray *arguments = [NSArray arrayWithObjects:@"-arch", PYTHON_ARCH, @"/usr/bin/python", kPythonVersion,
                script_path, [NSString stringWithCString:CONDUIT_RESOURCE_NAME encoding:NSASCIIStringEncoding], nil];

    //    if (!conduit) {
//        [self initConduit];
//    }
    
    [self setPath:script_path];
    python_task = [[NSTask alloc] init];
    [python_task setLaunchPath: @"/usr/bin/arch"];
    [python_task setArguments: arguments];
    
    stdout_pipe = [NSPipe pipe];
    stderr_pipe = [NSPipe pipe];
    [python_task setStandardOutput:stdout_pipe];
    [python_task setStandardError:stderr_pipe];
    python_task_stdout = [stdout_pipe fileHandleForReading];
    python_task_stderr = [stderr_pipe fileHandleForReading];
    
    [self updateRecentScripts];
    [python_task launch];
    
    [self setLoadButtonTitle:TERMINATE_BUTTON_TITLE];
    
    [working_indicator startAnimation:self];
    [self setStatus:STATUS_LOADING];
    
    // Register notifications so that we can get stdout and stderr
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postDataFromStdout:)
                                                 name:NSFileHandleReadCompletionNotification object:python_task_stdout];
    [python_task_stdout readInBackgroundAndNotify];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postDataFromStderr:)
                                                 name:NSFileHandleReadCompletionNotification object:python_task_stderr];
    [python_task_stderr readInBackgroundAndNotify];
    
    
    // start a timer to check on the task
    task_check_timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(checkOnPythonTask) userInfo:Nil repeats:YES]; 
    [[NSRunLoop currentRunLoop] addTimer:task_check_timer forMode:NSDefaultRunLoopMode];
    
    
}

-(void)launchScriptChooserSheet{
    
//    NSWindow *parent_window;
//    
//    if(in_grouped_window){
//        parent_window = [delegate groupedPluginWindow];
//    } else {
//        parent_window = [self window];
//    }
    [[self window] beginSheet:scriptChooseSheet
       completionHandler:(void (^)(NSModalResponse returnCode))nil];

//    [NSApp beginSheet: scriptChooseSheet
//       modalForWindow: [self window]
//        modalDelegate: self
//       didEndSelector: @selector(didEndSheet:returnCode:contextInfo:)
//          contextInfo: nil];
//    
}

- (void)postToConsole:(NSAttributedString *)attstr {
    [[console_view textStorage] appendAttributedString:attstr];
    if (self.scrollToBottomOnOutput) {
        [console_view scrollRangeToVisible:NSMakeRange([[console_view textStorage] length], 0) ];
    }
}


- (void) postDataFromStdout:(id)notification{
    
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    
    if([data length] != 0){
        NSString *str;
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSAttributedString *attstr = [[NSAttributedString alloc] initWithString:str];
        
        [self postToConsole:attstr];
        
        // reregister a request to read in the background
        [python_task_stdout readInBackgroundAndNotify];
    }
}


- (void) postDataFromStderr:(id)notification{
    
    NSData *data = [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem];
    
    if([data length] != 0){
        
        NSString *str;
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *attr = [NSDictionary dictionaryWithObject:[NSColor redColor] 
                                                         forKey:NSForegroundColorAttributeName];
        
        NSAttributedString *attstr = [[NSAttributedString alloc] initWithString:str attributes:attr];
        
        [self postToConsole:attstr];
        
        // reregister a request to read in the background
        [python_task_stderr readInBackgroundAndNotify];
    }
    
    
}


- (void)checkOnPythonTask{
    
    if(python_task != Nil && [python_task isRunning]){
        [working_indicator stopAnimation:self];
    }
    
    if(python_task == Nil || ![python_task isRunning]){
        [self setStatus:STATUS_NONE_LOADED];
        [self setLoadButtonTitle:LOAD_BUTTON_TITLE];
        [task_check_timer invalidate];
        python_task = Nil;
    }
    
    
    
    // read the stderr pipe
    //data = [python_task_stderr readDataToEndOfFile];
    //data = [python_task_stderr availableData];
//    str = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
//    
//    NSDictionary *attr = [NSDictionary dictionaryWithObject:[NSColor redColor] 
//                                                     forKey:NSForegroundColorAttributeName];
//    
//    attstr = [[NSAttributedString alloc] initWithString:str 
//                                             attributes:attr];
//    
//    [[console_view textStorage] appendAttributedString:attstr];
//    
}


-(void)terminateScript{
    if(python_task != Nil){
        [self setStatus:STATUS_TERMINATING];
        [python_task terminate];
    }
    
    python_task = Nil;
    python_task_stdout = Nil;
    
//    if (conduit) {
//        conduit->finalize();
//        conduit.reset();
//    }
    
    [self setStatus:STATUS_NONE_LOADED];
    [self setLoadButtonTitle:LOAD_BUTTON_TITLE];
}

-(IBAction)loadButtonPress:(id)sender{

    if(python_task == Nil){
        [self launchScriptChooserSheet];
    } else if(python_task != Nil){
        [self terminateScript];
    } else {
        // this is some kind of error
        NSLog(@"some kind of error occurred");
    }
}


- (void) updateRecentScripts;
{
    NSArray *recentScripts;
	NSUserDefaults *defaults;
    NSMutableArray *recentScriptsMutable;
    
    if ([self path] == nil) {
        return;
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:[self path] forKey:@"lastPythonScript"];
//    [defaults synchronize];
 
    recentScripts = [defaults arrayForKey:kLLRecentPythonScriptsKey];
    recentScriptsMutable = [NSMutableArray arrayWithArray:recentScripts];
    [recentScriptsMutable removeObject:[self path]];  // In case it's already in the list
    [recentScriptsMutable insertObject:[self path] atIndex:0];
    [defaults setObject:recentScriptsMutable forKey:kLLRecentPythonScriptsKey];
    [defaults synchronize];
}

- (NSDictionary *)workspaceState {
    NSMutableDictionary *workspaceState = [NSMutableDictionary dictionary];
    
    if (python_task) {
        [workspaceState setObject:self.path forKey:@"scriptPath"];
    }
    
    return workspaceState;
}


- (void)setWorkspaceState:(NSDictionary *)workspaceState {
    NSString *newPath = [workspaceState objectForKey:@"scriptPath"];
    if (newPath && [newPath isKindOfClass:[NSString class]]) {
        if (python_task) {
            [self terminateScript];
        }
//        [self launchScriptAtPath:[newPath mwk_absolutePath]];
        [self launchScriptAtPath:newPath];
    }
}


@end


























