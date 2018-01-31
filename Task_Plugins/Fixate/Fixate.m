//
//  Fixate.m
//  Fixate
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "FT.h"
#import "Fixate.h"
#import "FTSummaryController.h"
#import "FTXTController.h"

NSString *FTAcquireMSKey = @"FTAcquireMS";
NSString *FTDoFixateKey = @"FTDoFixate";
NSString *FTDoSoundsKey = @"FTDoSounds";
NSString *FTFixateJitterPCKey = @"FTFixateJitterPC";
NSString *FTFixateMSKey = @"FTFixateMS";
NSString *FTFixForeColorKey = @"FTFixForeColor";
NSString *FTFixBackColorKey = @"FTFixBackColor";
NSString *FTFixWindowWidthDegKey = @"FTFixWindowWidthDeg";
NSString *FTIntertrialMSKey = @"FTIntertrialMS";
NSString *FTRewardMSKey = @"FTRewardMS";
NSString *FTTaskModeKey = @"FTTaskMode";

LLScheduleController    *scheduler = nil;
FTStimuli                *stimuli = nil;

DataAssignment eyeRXDataAssignment = {@"eyeRXData",     @"Synthetic", 2, 5.0};    
DataAssignment eyeRYDataAssignment = {@"eyeRYData",     @"Synthetic", 3, 5.0};    
DataAssignment eyeRPDataAssignment = {@"eyeRPData",     @"Synthetic", 4, 5.0};    
DataAssignment eyeLXDataAssignment = {@"eyeLXData",     @"Synthetic", 5, 5.0};    
DataAssignment eyeLYDataAssignment = {@"eyeLYData",     @"Synthetic", 6, 5.0};    
DataAssignment eyeLPDataAssignment = {@"eyeLPData",     @"Synthetic", 7, 5.0};    
DataAssignment VBLDataAssignment = {@"VBLData",    @"Synthetic", 1, 1};    
DataAssignment spikeDataAssignment = {@"spikeData", @"Synthetic", 2, 1};

EventDefinition FTEvents[] = {    
    {@"taskMode",             sizeof(long),            {@"long"}},
    {@"reset",                 sizeof(long),            {@"long"}}, 
};

LLTaskPlugIn    *task = nil;

@implementation Fixate

+ (NSInteger)version;
{
    return kLLPluginVersion;
}

// Start the method that will collect data from the event buffer

- (void)activate;
{ 
    NSMenu *mainMenu = NSApp.mainMenu;
    
    if (self.active) {
        return;
    }

// Insert Actions and Settings menus into menu bar
     
    [mainMenu insertItem:actionsMenuItem atIndex:([mainMenu indexOfItemWithTitle:@"Tasks"] + 1)];
    [mainMenu insertItem:settingsMenuItem atIndex:([mainMenu indexOfItemWithTitle:@"Tasks"] + 1)];
    
// Load settings and create and clear the stimulus

    [self.settingsController loadSettings];
    [self.settingsController registerDefaults];
    stimuli = [[FTStimuli alloc] init];
    [stimuli erase];
    
// Create on-line display windows

    [self.dataDoc defineEvents:[LLStandardDataEvents eventsWithDataDefs] count:[LLStandardDataEvents countOfEventsWithDataDefs]];
    [self.dataDoc defineEvents:FTEvents count:(sizeof(FTEvents) / sizeof(EventDefinition))];

    [controlPanel.window orderFront:self];

    eyeXYController = [[FTEyeXYController alloc] init];
    [self.dataDoc addObserver:eyeXYController];

    summaryController = [[FTSummaryController alloc] init];
    [self.dataDoc addObserver:summaryController];
 
    xtController = [[FTXTController alloc] init];
    [self.dataDoc addObserver:xtController];


// Set up the data collector to handle our data types

    [self.dataController assignSampleData:eyeRXDataAssignment];
    [self.dataController assignSampleData:eyeRYDataAssignment];
    [self.dataController assignSampleData:eyeRPDataAssignment];
    [self.dataController assignSampleData:eyeLXDataAssignment];
    [self.dataController assignSampleData:eyeLYDataAssignment];
    [self.dataController assignSampleData:eyeLPDataAssignment];
//    [dataController assignTimestampData:leverDataAssignment];
    [self.dataController assignTimestampData:VBLDataAssignment];
    [self.dataController assignTimestampData:spikeDataAssignment];
    [self.dataController assignDigitalInputDevice:@"Synthetic"];
    [self.dataController assignDigitalOutputDevice:@"Synthetic"];

    self.collectorTimer = [NSTimer scheduledTimerWithTimeInterval:kSamplePeriodS target:self
            selector:@selector(dataCollect:) userInfo:nil repeats:YES];

    [self.dataDoc addObserver:self.stateSystem];
    [self.stateSystem startWithCheckIntervalMS:5];                // Start the experiment state system
    
    self.active = YES;
}

// The following function is called after the nib has finished loading.  It is the correct
// place to initialize nib related components, such as menus.

- (void)awakeFromNib;
{
    if (actionsMenuItem == nil) {
        actionsMenuItem = [[NSMenuItem alloc] init]; 
        actionsMenu.title = @"Actions";
        actionsMenuItem.submenu = actionsMenu;
        [actionsMenuItem setEnabled:YES];
    }
    if (settingsMenuItem == nil) {
        settingsMenuItem = [[NSMenuItem alloc] init]; 
        settingsMenu.title = @"Settings";
        settingsMenuItem.submenu = settingsMenu;
        [settingsMenuItem setEnabled:YES];
    }
}

- (void)dataCollect:(NSTimer *)timer;
{
    NSData *data;
    
    if ((data = [self.dataController dataOfType:@"eyeLXData"]) != nil) {
        [self.dataDoc putEvent:@"eyeLXData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kLeftEye].x = *(short *)(data.bytes + data.length - sizeof(short));
    }
    if ((data = [self.dataController dataOfType:@"eyeLYData"]) != nil) {
        [self.dataDoc putEvent:@"eyeLYData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kLeftEye].y = *(short *)(data.bytes + data.length - sizeof(short));
        self.currentEyesDeg[kLeftEye] = [task.eyeCalibrator degPointFromUnitPoint:currentEyesUnits[kLeftEye] forEye:kLeftEye];
    }
    if ((data = [self.dataController dataOfType:@"eyeLPData"]) != nil) {
        [self.dataDoc putEvent:@"eyeLPData" withData:(Ptr)data.bytes lengthBytes:data.length];
    }
    if ((data = [self.dataController dataOfType:@"eyeRXData"]) != nil) {
        [self.dataDoc putEvent:@"eyeRXData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kRightEye].x = *(short *)(data.bytes + data.length - sizeof(short));
    }
    if ((data = [self.dataController dataOfType:@"eyeRYData"]) != nil) {
        [self.dataDoc putEvent:@"eyeRYData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kRightEye].y = *(short *)(data.bytes + data.length - sizeof(short));
        self.currentEyesDeg[kRightEye] = [task.eyeCalibrator degPointFromUnitPoint:currentEyesUnits[kRightEye]
                                                                         forEye:kRightEye];
    }
    if ((data = [self.dataController dataOfType:@"eyeRPData"]) != nil) {
        [self.dataDoc putEvent:@"eyeRPData" withData:(Ptr)data.bytes lengthBytes:data.length];
    }
    if ((data = [self.dataController dataOfType:@"VBLData"]) != nil) {
        [self.dataDoc putEvent:@"VBLData" withData:(Ptr)data.bytes lengthBytes:data.length];
    }
    if ((data = [self.dataController dataOfType:@"spikeData"]) != nil) {
        [self.dataDoc putEvent:@"spikeData" withData:(Ptr)data.bytes lengthBytes:data.length];
    }
}
        
- (void)deactivate:(id)sender;
{
    if (!self.active) {
        return;
    }
    
// Stop data collection

    [self.dataController setDataEnabled:@NO];
    [self.stateSystem stop];
    [self.collectorTimer invalidate];
    [self.dataDoc removeObserver:self.stateSystem];
    [self.dataDoc removeObserver:eyeXYController];
    [self.dataDoc removeObserver:summaryController];
    [self.dataDoc removeObserver:xtController];
    [self.dataDoc clearEventDefinitions];

// Remove Actions and Settings menus from menu bar
     
    [NSApp.mainMenu removeItem:settingsMenuItem];
    [NSApp.mainMenu removeItem:actionsMenuItem];

// Release all the display windows

    [eyeXYController deactivate];        // requires special method
    [eyeXYController release];
    [summaryController close];
    [summaryController release];
    [xtController close];
    [xtController release];
    [controlPanel.window close];

    [stimuli release];
    [self.settingsController extractSettings];
    self.active = NO;
}

- (void)dealloc;
{
    while (self.stateSystem.running) {};        // wait for state system to stop, then release it
    [self.stateSystem release];
    
    [actionsMenuItem release];
    [settingsMenuItem release];
    
    [scheduler release];
    [controlPanel release];
    [topLevelObjects release];
    [self.settingsController release];

    [[NSNotificationCenter defaultCenter] removeObserver:self]; 

    [super dealloc];
}

- (void)doControls:(NSNotification *)notification;
{
    if ([notification.name isEqualToString:LLTaskModeButtonKey]) {
        [self doRunStop:self];
    }
    else if ([notification.name isEqualToString:LLJuiceButtonKey]) {
        [self doJuice:self];
    }
    if ([notification.name isEqualToString:LLResetButtonKey]) {
        [self doReset:self];
    }
}

- (IBAction)doFixSettings:(id)sender;
{
    [[stimuli fixSpot] runSettingsDialog];
}

- (IBAction)doJuice:(id)sender;
{
    long juiceMS;
    NSSound *juiceSound;
    
    juiceMS = [[NSUserDefaults standardUserDefaults] integerForKey:FTRewardMSKey];
    [task.dataController digitalOutputBitsOff:kRewardBit];
    [scheduler schedule:@selector(doJuiceOff) toTarget:self withObject:Nil delayMS:juiceMS];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:FTDoSoundsKey]) {
        juiceSound = [NSSound soundNamed:@"Correct"];
        if (juiceSound.playing) {   // won't play again if it's still playing
            [juiceSound stop];
        }
        [juiceSound play];            // play juice sound
    }
}

- (void)doJuiceOff;
{
    [task.dataController digitalOutputBitsOn:kRewardBit];
}

- (IBAction)doReset:(id)sender;
{
    long resetType = 0;
    
    [self.dataDoc putEvent:@"reset" withData:&resetType];
}

- (IBAction)doSettings:(id)sender;
{
    [stimuli release];
    [self.settingsController selectSettings];
    stimuli = [[FTStimuli alloc] init];
}

// After our -init is called, the host will provide essential pointers such as
// defaults, stimWindow, eyeCalibrator, etc.  Only after those are initialized, the
// following method will be called.  We therefore defer most of our initialization here

- (void)initializationDidFinish;
{
    task = self;
    
// Set up the task mode object.  We need to do this before loading the nib,
// because some items in the nib are bound to the task mode. We also need
// to set the mode, because the value in defaults will be the last entry made
// which is typically kTaskEnding.

    taskStatus = [[LLTaskStatus alloc] init];
    taskStatus.mode = kTaskIdle;
    self.settingsController =
                [[LLSettingsController alloc] initForPlugin:[NSBundle bundleForClass:[self class]] prefix:@"FT"];

// Load the items in the nib

    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"Fixate" owner:self topLevelObjects:&topLevelObjects];
    [topLevelObjects retain];
    
// Initialize other task objects

    scheduler = [[LLScheduleController alloc] init];
    self.stateSystem = [[FTStateSystem alloc] init];

// Set up control panel and observer for control panel

    controlPanel = [[LLControlPanel alloc] init];
    controlPanel.windowFrameAutosaveName = @"FTControlPanel";
    [controlPanel.window setFrameUsingName:@"FTControlPanel"];
    controlPanel.window.title = @"Fixate";
    [[NSNotificationCenter defaultCenter] addObserver:self 
        selector:@selector(doControls:) name:nil object:controlPanel];
}

- (long)mode;
{
    return taskStatus.mode;
}

- (NSString *)name;
{
    return @"Fixate";
}
/*
- (NSNumber *)pluginVersion; 
{
    return [NSNumber numberWithLong:kLLPluginVersion];
}
*/
- (void)setMode:(long)newMode;
{
    taskStatus.mode = newMode;
    controlPanel.taskMode = taskStatus.mode;
    [self.dataDoc putEvent:@"taskMode" withData:&newMode];
    switch (taskStatus.mode) {
    case kTaskRunning:
    case kTaskStopping:
        runStopMenuItem.keyEquivalent = @".";
        break;
    case kTaskIdle:
        runStopMenuItem.keyEquivalent = @"r";
        break;
    default:
        break;
    }
}
// Respond to changes in the stimulus settings

- (void)setWritingDataFile:(BOOL)state;
{
    if (taskStatus.dataFileOpen != state) {
        taskStatus.dataFileOpen = state;
        if (taskStatus.dataFileOpen) {
//            announceEvents();
            [controlPanel displayFileName:self.dataDoc.filePath.lastPathComponent.stringByDeletingPathExtension];
            [controlPanel setResetButtonEnabled:NO];
        }
        else {
            [controlPanel displayFileName:@""];
            [controlPanel setResetButtonEnabled:YES];
        }
    }
}

- (FTStimuli *)stimuli;
{
    return stimuli;
}
@end
