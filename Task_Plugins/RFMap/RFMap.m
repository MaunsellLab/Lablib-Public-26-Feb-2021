//
//  RFMap.m
//  RFMap
//
//  Created by John Maunsell on 12/30/04.
//  Copyright 2004. All rights reserved.
//

#import "RF.h"
#import "RFMap.h"
#import "RFSummaryController.h"
#import "RFXTController.h"

#define kPI                  (atan(1) * 4)
#define kDegPerRadian        (180.0 / kPI)
#define kPositionUpdateS    0.25

NSString *RFAcquireMSKey = @"RFAcquireMS";
NSString *RFDisplayModeKey = @"RFDisplayMode";
NSString *RFDisplayUnitsKey = @"RFDisplayUnits";
NSString *RFDoFixateKey = @"RFDoFixate";
NSString *RFDoGridKey = @"RFDoGrid";
NSString *RFDoSoundsKey = @"RFDoSounds";
NSString *RFFixateMSKey = @"RFFixateMS";
NSString *RFFixSpotAzimuthDegKey = @"RFFixSpotAzimuthDeg";
NSString *RFFixSpotElevationDegKey = @"RFFixSpotElevationDeg";
NSString *RFFixSpotRadiusDegKey = @"RFFixSpotRadiusDeg";
NSString *RFFixWindowWidthDegKey = @"RFFixWindowWidthDeg";
NSString *RFGridSpacingDegKey = @"RFGridSpacingDeg";
NSString *RFIntertrialMSKey = @"RFIntertrialMS";
NSString *RFMeanFixateMSKey = @"RFMeanFixateMS";
NSString *RFRewardMSKey = @"RFRewardMS";
NSString *RFStimTypeKey = @"RFStimType";
NSString *RFTaskStatusKey = @"RFTaskStatus";

// Stimulus Settings

NSString *RFDoMouseGateKey = @"RFDoMouseGate";
NSString *RFOrientationStepDegKey = @"RFOrientationStepDeg";
NSString *RFSizeFactorKey = @"RFSizeFactor";
NSString *RFWidthFactorKey = @"RFWidthFactor";

RFBehavior                behaviorMode = kBehaviorRunning;
BOOL                    resetFlag = NO;
LLScheduleController    *scheduler = nil;
RFMapStimuli            *stimuli = nil;

DataAssignment eyeRXDataAssignment = {@"eyeRXData",     @"Synthetic", 2, 5.0};
DataAssignment eyeRYDataAssignment = {@"eyeRYData",     @"Synthetic", 3, 5.0};
DataAssignment eyeRPDataAssignment = {@"eyeRPData",     @"Synthetic", 4, 5.0};
DataAssignment eyeLXDataAssignment = {@"eyeLXData",     @"Synthetic", 5, 5.0};
DataAssignment eyeLYDataAssignment = {@"eyeLYData",     @"Synthetic", 6, 5.0};
DataAssignment eyeLPDataAssignment = {@"eyeLPData",     @"Synthetic", 7, 5.0};
//DataAssignment eyeDataAssignment[] = {
//                                    {@"eyeData",    @"Synthetic", 0, 5.0},
//                                    {nil,            @"Synthetic", 1, 5.0}};
DataAssignment leverDataAssignment = {@"leverData",    @"Synthetic", 0, 1};    
DataAssignment VBLDataAssignment = {@"VBLData",    @"Synthetic", 1, 1};    
DataAssignment spikeDataAssignment = {@"spikeData", @"Synthetic", 2, 1};

LLDataDef stimCenterStructDef[] = {
    {@"float",    @"azimuthDeg", 1, offsetof(StimCenter, azimuthDeg)},
    {@"float",    @"elevationDeg", 1, offsetof(StimCenter, elevationDeg)},
    {nil}};

EventDefinition RFEvents[] = {
    {@"stimCenter",            sizeof(StimCenter),    {@"struct", @"stimCenter", 1, 0, sizeof(StimCenter), stimCenterStructDef}},
    {@"stimulusType",         sizeof(long),            {@"long"}},
    {@"taskMode",             sizeof(long),            {@"long"}},
    {@"reset",                sizeof(long),            {@"long"}},
};

LLTaskPlugIn    *task = nil;

@implementation RFMap

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

// Erase the stimulus display

    stimuli = [[RFMapStimuli alloc] init];
    [stimuli erase];
    
// Create on-line display windows

    [self.dataDoc defineEvents:[LLStandardDataEvents eventsWithDataDefs] count:[LLStandardDataEvents countOfEventsWithDataDefs]];
    [task.self.dataDoc defineEvents:RFEvents count:(sizeof(RFEvents) / sizeof(EventDefinition))];

    [controlPanel.window orderFront:self];
    
    eyeXYController = [[RFEyeXYController alloc] init];
    [task.self.dataDoc addObserver:eyeXYController];

    summaryController = [[RFSummaryController alloc] init];
    [task.self.dataDoc addObserver:summaryController];
 
    xtController = [[RFXTController alloc] init];
    [task.self.dataDoc addObserver:xtController];
    
    // Set up the data collector to handle our data types
    //[self.dataController assignGroupedSampleData:eyeDataAssignment groupCount:2];
    [self.dataController assignSampleData:eyeRXDataAssignment];
    [self.dataController assignSampleData:eyeRYDataAssignment];
    [self.dataController assignSampleData:eyeRPDataAssignment];
    [self.dataController assignSampleData:eyeLXDataAssignment];
    [self.dataController assignSampleData:eyeLYDataAssignment];
    [self.dataController assignSampleData:eyeLPDataAssignment];
    
    [self.dataController assignTimestampData:VBLDataAssignment];
    [self.dataController assignTimestampData:spikeDataAssignment];
    [self.dataController assignDigitalInputDevice:@"Synthetic"];
    [self.dataController assignDigitalOutputDevice:@"Synthetic"];
    collectorTimer = [NSTimer scheduledTimerWithTimeInterval:kSamplePeriodS target:self 
            selector:@selector(dataCollect:) userInfo:nil repeats:YES];

    [task.self.dataDoc addObserver:stateSystem];
    [stateSystem startWithCheckIntervalMS:5];                // Start the experiment state system
    
// Most users want the fixation spot to hold still during RFMap, so we set it to zero 
// here, and restore it when we exit

    originalFixOffsetDeg = task.eyeCalibrator.calibrationOffsetDeg;
    task.eyeCalibrator.calibrationOffsetDeg = 0.0;

// Set up a timer to display azimuth and elevation

    displayTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:kPositionUpdateS target:self 
            selector:@selector(displayPosition:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:displayTimer forMode:NSDefaultRunLoopMode];
    self.active = YES;
}

// The following function is called after the nib has finished loading.  It is the correct
// place to initialize nib related components, such as menus.

- (void)awakeFromNib;
{
    if (actionsMenuItem == nil) {
        actionsMenuItem = [[NSMenuItem alloc] init]; 
        [actionsMenu setTitle:NSLocalizedString(@"Actions", @"Action Menu Title")];
        actionsMenuItem.submenu = actionsMenu;
        [actionsMenuItem setEnabled:YES];
    }
    if (settingsMenuItem == nil) {
        settingsMenuItem = [[NSMenuItem alloc] init]; 
        [settingsMenu setTitle:NSLocalizedString(@"Settings", @"Settings Menu Title")];
        settingsMenuItem.submenu = settingsMenu;
        [settingsMenuItem setEnabled:YES];
    }
}


- (void)dataCollect:(NSTimer *)timer;
{
    NSData *data;
    //short *pEyeData;
    
    //if ((data = [self.dataController dataOfType:@"eyeData"]) != nil) {
    //    [self.dataDoc putEvent:@"eyeData" withData:(Ptr)[data bytes] lengthBytes:[data length]];
    //    pEyeData = (short *)([data bytes] + [data length] - 2 * sizeof(short));
    //    currentEyeDeg = [[task eyeCalibrator] degPointFromUnitPoint:NSMakePoint(pEyeData[0], pEyeData[1])];
    //}
    
    if ((data = [self.dataController dataOfType:@"eyeLXData"]) != nil) {
        [self.dataDoc putEvent:@"eyeLXData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kLeftEye].x = *(short *)(data.bytes + data.length - sizeof(short));
    }
    if ((data = [self.dataController dataOfType:@"eyeLYData"]) != nil) {
        [self.dataDoc putEvent:@"eyeLYData" withData:(Ptr)data.bytes lengthBytes:data.length];
        currentEyesUnits[kLeftEye].y = *(short *)(data.bytes + data.length - sizeof(short));
        currentEyesDeg[kLeftEye] = [task.eyeCalibrator degPointFromUnitPoint:currentEyesUnits[kLeftEye] forEye:kLeftEye];
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
        currentEyesDeg[kRightEye] = [task.eyeCalibrator degPointFromUnitPoint:currentEyesUnits[kRightEye]
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
    [collectorTimer invalidate];
    [displayTimer invalidate];
    [displayTimer release];
    
// Stop the state system, which will stop the stimulus

    [stateSystem stop];
    while (stateSystem.running) {};

    [task.self.dataDoc removeObserver:stateSystem];
    [task.self.dataDoc removeObserver:eyeXYController];
    [task.self.dataDoc removeObserver:summaryController];
    [task.self.dataDoc removeObserver:xtController];
    [task.self.dataDoc clearEventDefinitions];

// Remove Actions and Settings menus from menu bar
     
    [NSApp.mainMenu removeItem:settingsMenuItem];
    [NSApp.mainMenu removeItem:actionsMenuItem];

// Release all the display windows

    [eyeXYController deactivate];                                // requires a special method
    [eyeXYController release];
    [summaryController close];
    [summaryController release];
    [xtController close];
    [xtController release];
    [controlPanel displayText:@""];                                // need to collapse control panel 
    [controlPanel.window close];                                //  for autosave frames to be correct

// Restore the eye calibration to its original value

    task.eyeCalibrator.calibrationOffsetDeg = originalFixOffsetDeg;
    [stimuli releaseStimuli];
    [stimuli release];
    [self.settingsController extractSettings];
    self.active = NO;
}

- (void)dealloc;
{
    while (stateSystem.running) {};        // wait for state system to stop, then release it
    [task.self.dataDoc removeObserver:stateSystem];
    [stateSystem release];
    [actionsMenuItem release];
    [settingsMenuItem release];
    [scheduler release];
    [controlPanel release];
    [taskStatus release];
    [topLevelObjects release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 

    [super dealloc];
}

- (void)displayPosition:(NSTimer*)theTimer;
{
    NSString *displayString;
    NSPoint stimCenterDeg =stimWindow.mouseLocationDeg;

    switch ([[NSUserDefaults standardUserDefaults] boolForKey:RFDisplayUnitsKey]) {
    case kAzimuthElevation:
        default:
        displayString = [NSString stringWithFormat:@"Azimuth: %5.1f\nElevation: %5.1f",
                            stimCenterDeg.x, stimCenterDeg.y];
        break;
    case kEccentricityAngle:
        displayString = [NSString stringWithFormat:@"Eccentricy: %5.1f\nAngle: %5ld",
                sqrt(stimCenterDeg.x * stimCenterDeg.x + stimCenterDeg.y * stimCenterDeg.y), 
                (long)(atan2(stimCenterDeg.y, stimCenterDeg.x) * kDegPerRadian) % 180];
        break;
    }
    [controlPanel displayText:displayString];
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
    
    juiceMS = [[NSUserDefaults standardUserDefaults] integerForKey:RFRewardMSKey];
    [task.self.dataController digitalOutputBitsOff:kRewardBit];
    [scheduler schedule:@selector(doJuiceOff) toTarget:self withObject:nil delayMS:juiceMS];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:RFDoSoundsKey]) {
        juiceSound = [NSSound soundNamed:@"Correct"];
        if (juiceSound.playing) {   // won't play again if it's still playing
            [juiceSound stop];
        }
        [juiceSound play];            // play juice sound
    }
}

- (void)doJuiceOff;
{
    [task.self.dataController digitalOutputBitsOn:kRewardBit];
}

- (IBAction)doReset:(id)sender;
{
}

- (IBAction)doSettings:(id)sender;
{
    BOOL wasOn;

    if ((wasOn = [stimuli stimulusOn])) {
        [stimuli stopStimulus];
        while ([stimuli stimulusOn]) {};
    }
    [stimuli releaseStimuli];
    [self.settingsController selectSettings];
    [stimuli initializeStimuli];
    if (wasOn) {
        [stimuli startStimulus];
    }
}

// Run the settings dialog for the current stimulus

- (IBAction)doStimSettings:(id)sender;
{
    [stimuli doStimSettings];
}

- (BOOL)handleEvent:(NSEvent *)theEvent;
{
    BOOL handled = NO;
    
    if (theEvent.type == NSEventTypeKeyDown) {
        switch (theEvent.keyCode) {
        case kKeyPad7KeyCode:                        // make stimulus smaller
            [stimuli changeSize:1.0 / [[NSUserDefaults standardUserDefaults] floatForKey:RFSizeFactorKey]];
            handled = YES;
            break;
        case kKeyPad9KeyCode:                        // make stimulus larger
            [stimuli changeSize:[[NSUserDefaults standardUserDefaults] floatForKey:RFSizeFactorKey]];
            handled = YES;
            break;
        case kKeyPad1KeyCode:                         // make stimulus narrow
            [stimuli changeWidth:1.0 / [[NSUserDefaults standardUserDefaults] floatForKey:RFWidthFactorKey]];
            handled = YES;
            break;
        case kKeyPad3KeyCode:                        // make stimulus wider
            [stimuli changeWidth:[[NSUserDefaults standardUserDefaults] floatForKey:RFWidthFactorKey]];
            handled = YES;
            break;
        case kKeyPad6KeyCode:                        // rotate CW
            [stimuli rotate:-[[NSUserDefaults standardUserDefaults] floatForKey:RFOrientationStepDegKey]];
            handled = YES;
            break;
        case kKeyPad4KeyCode:                        // rotate CCW
            [stimuli rotate:[[NSUserDefaults standardUserDefaults] floatForKey:RFOrientationStepDegKey]];
            handled = YES;
            break;
        case kKeyPad0KeyCode:
        case kKeyPad2KeyCode:
        case kKeyPad5KeyCode:
        case kKeyPad8KeyCode:
        case kKeyPadPeriodKeyCode:
        case kKeyPadStarKeyCode:
        case kKeyPadPlusKeyCode:
        case kKeyPadClearKeyCode:
        case kKeyPadSlashKeyCode:
        case kKeyPadEnterKeyCode:
        case kKeyPadMinusKeyCode:
        case kKeyPadEqualsKeyCode:
            handled = YES;
            break;
        default:
            break;
        }
    }
    else if (theEvent.type == NSEventTypeLeftMouseDown) {
        handled = [stimuli mouseDown];
    }
    else if (theEvent.type == NSEventTypeLeftMouseUp) {
        handled = [stimuli mouseUp];
    }
    return handled;
}

- (BOOL)handlesEvents;
{
    return YES;                                        // declare that we want OS events
}

// After our -init is called, the host will provide essential pointers such as
// defaults, stimWindow, eyeCalibrator, etc.  Only after those are initialized, the
// following method will be called.  We therefore defer most of our initialization here

- (void)initializationDidFinish;
{
    LLMultiplierTransformer *transformer;
    
    task = self;
    self.settingsController =
                [[LLSettingsController alloc] initForPlugin:[NSBundle bundleForClass:[self class]] prefix:@"RF"];

// Set up the value transformers that are needed for some of the key bindings

    transformer = [[[LLMultiplierTransformer alloc] init] autorelease];
    transformer.multiplier = 100;
    [NSValueTransformer setValueTransformer:transformer forName:@"PercentTransformer"];

// Set up the task mode object.  We need to do this before loading the nib,
// because some items in the nib are bound to the task mode. We also need
// to set the mode, because the value in defaults will be the last entry made
// which is typically kTaskEnding.

    taskStatus = [[LLTaskStatus alloc] init];

// Load the items in the nib

    [[NSBundle bundleForClass:[self class]] loadNibNamed:@"RFMap" owner:self topLevelObjects:&topLevelObjects];
    [topLevelObjects retain];
        
// Initialize other task objects

    scheduler = [[LLScheduleController alloc] init];
    stateSystem = [[RFStateSystem alloc] init];

// Set up control panel and observer for control panel

    controlPanel = [[LLControlPanel alloc] init];
    [controlPanel.window setFrameUsingName:@"RFControlPanel"];
    controlPanel.windowFrameAutosaveName = @"RFControlPanel";
    [controlPanel.window setTitle:NSLocalizedString(@"RFMap", nil)];
    [[NSNotificationCenter defaultCenter] addObserver:self 
        selector:@selector(doControls:) name:nil object:controlPanel];

}

- (long)mode;
{
    return taskStatus.mode;
}

- (NSString *)name;
{
    return @"RFMap";
}
/*
- (NSNumber *)pluginVersion; 
{
    return [NSNumber numberWithLong:kLLPluginVersion];
}
*/
// Post a notification of the stimulus position.  The position is sent as an NSPoint in an NSValue

- (IBAction)postPosition:(id)sender;
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RFMapStimulusPositionDeg"
        object:[NSValue valueWithPoint:stimWindow.mouseLocationDeg]];
}

- (void)setMode:(long)newMode;
{
    taskStatus.mode = newMode;
    [[NSUserDefaults standardUserDefaults] setInteger:newMode forKey:RFTaskStatusKey];
    controlPanel.taskMode = taskStatus.mode;
    [task.self.dataDoc putEvent:@"taskMode" withData:&newMode];
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
            [controlPanel displayFileName:task.self.dataDoc.filePath.lastPathComponent.stringByDeletingPathExtension];
            [controlPanel setResetButtonEnabled:NO];
        }
        else {
            [controlPanel displayFileName:@""];
            [controlPanel setResetButtonEnabled:YES];
        }
    }
}

- (RFMapStimuli *)stimuli;
{
    return stimuli;
}

@end
