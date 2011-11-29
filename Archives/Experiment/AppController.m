//
//  AppController.m
//  Experiment
//
// This controller is set to be a delegate for the application.
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "Experiment.h" 
#import "UtilityFunctions.h"
#import "AppController.h"
#import "BehaviorController.h"
#import "SpikeController.h"
#import "SummaryController.h"
#import "XTController.h"

#ifdef USE_ITC
#import <LablibITC18/LablibITC18.h>
#endif

#define kEyeXChannel			0
#define kEyeYChannel			1

// Preferences dialog

NSString *doDataDirectoryKey = @"doDataDirectory";

// Behavior settings dialog

NSString *acquireMSKey = @"acquireMS";
NSString *blockLimitKey = @"blockLimit";
NSString *fixateKey = @"fixate";
NSString *fixWindowWidthKey = @"fixWindowWidthDeg";
NSString *fixSpotSizeKey = @"fixSpotSizeDeg";
NSString *intertrialMSKey = @"intertrialMS";
NSString *nontargetContrastKey = @"nontargetContrastPC";
NSString *respSpotSizeKey = @"responseSpotSizeDeg";
NSString *responseTimeMSKey = @"responseMS";
NSString *respWindow0AziKey = @"respWind0Azi";
NSString *respWindow0EleKey = @"respWind0Ele";
NSString *respWindow1AziKey = @"respWind1Azi";
NSString *respWindow1EleKey = @"respWind1Ele";
NSString *respWindowWidthKey = @"responseWindowWidthDeg";
NSString *rewardKey = @"rewardMS";
NSString *saccadeTimeMSKey = @"saccadeMS";
NSString *soundsKey = @"playSounds";
NSString *tooFastMSKey = @"tooFastMS";
NSString *triesKey = @"tries";

// Stimulus settings dialog

NSString *gapMSKey = @"gapMS";
NSString *intervalMSKey = @"intervalMS";
NSString *preIntervalMSKey = @"preintervalMS"; 
NSString *postIntervalMSKey = @"postintervalMS";
NSString *stimTypeKey = @"stimType";

// Stimulus settings dialog: visual stimulation 

NSString *azimuthDegKey = @"azimuthDeg";
NSString *elevationDegKey = @"elevationDeg";
NSString *kdlPhiDegKey = @"kdlPhiDeg";
NSString *kdlThetaDegKey = @"kdlThetaDeg";
NSString *orientationDegKey = @"orientationDeg";
NSString *radiusDegKey = @"radiusDeg";
NSString *sigmaDegKey = @"sigmaDeg";
NSString *spatialFreqCPDKey = @"spatialFreqCPD";
NSString *spatialPhaseDegKey = @"spatialPhaseDeg";
NSString *temporalFreqHzKey = @"temporalFreqHz";

NSString *contrastFactorKey = @"contrastFactor";
NSString *contrastsKey = @"contrasts";
NSString *maxContrastKey = @"maxContrast";

// Stimulus settings dialog: electrical stimulation

NSString *currentsKey = @"currents";
NSString *currentFactorKey = @"currentFactor";
NSString *frequencyKey = @"frequencyHz";
NSString *pulseWidthUSKey = @"pulseWidthUS";
NSString *DAChannelKey = @"DAChannel";
NSString *gateBitKey = @"gateBit";
NSString *doGateKey = @"doGate";
NSString *markerPulseBitKey = @"markerPulseBit";
NSString *doMarkerPulsesKey = @"doMarkerPulse";
NSString *maxCurrentKey = @"maxCurrent";
NSString *uAPerVKey = @"uAPerV";

// Data events

NSString *writingDataFileKey = @"writingDataFile";

EventDef experimentEvents[] = {

	{@"stimulusType",		sizeof(long)},					// recorded at start of file
	{@"contrastStimParams", sizeof(StimParams)},			// stimulus descriptions
	{@"gabor",				sizeof(Gabor)},
	{@"currentStimParams",  sizeof(StimParams)},
	{@"frequencyHz",		sizeof(float)},
	{@"pulseWidthUS",		sizeof(long)},
	{@"uAPerV",				sizeof(long)},
	{@"voltageRangeV",		sizeof(float)},

	{@"preIntervalMS",		sizeof(long)},					// timing parameters
	{@"intervalMS",			sizeof(long)},
	{@"gapMS",				sizeof(long)},
	{@"postStimuliMS",		sizeof(long)},
	{@"responseTimeMS",		sizeof(long)},
	{@"tooFastTimeMS",		sizeof(long)},
	{@"tries",				sizeof(long)},
	{@"blockLimit",			sizeof(long)},
	{@"blockTrialsDone",	sizeof(long)},
	{@"blocksDone",			sizeof(long)},
	
	{@"trial",				sizeof(TrialDesc)},			// declared at start of each trial
	{@"responseWindow",		sizeof(FixWindowData)},
	{@"preStimuli",			0},							// marking the course of each trial
	{@"intervalOne",		sizeof(float)},
	{@"gap",				0},
	{@"intervalTwo",		sizeof(float)},
	{@"postStimuli",		0},
	{@"targetsOn",			0},
	{@"saccade",			0},

	{@"taskMode", 			sizeof(long)},
	{@"reset", 				sizeof(long)}, 
};

AppController *appController = Nil;

@implementation AppController

// Initialize and start the experiment state system

- (void)applicationDidFinishLaunching:(NSNotification *)notification {

    experStateSystem = [[StateSystem alloc] init];
    [dataDoc addObserver:experStateSystem];
    [experStateSystem startWithCheckIntervalMS:5];				// Start the experiment state system
}

// The data is handled within a Cocoa NSDocument, which is created here.

- (void)applicationWillFinishLaunching:(NSNotification *)notification {

	dataDoc = [[LLDataDoc alloc] init];
	[dataDoc defineEvents:[LLStandardDataEvents events] number:[LLStandardDataEvents count]];
	[dataDoc defineEvents:experimentEvents number:(sizeof(experimentEvents) / sizeof(EventDef))];

    behaviorController = [[BehaviorController alloc] init];
    [dataDoc addObserver:behaviorController];

    eyeXYController = [[EyeXYController alloc] init];
    [dataDoc addObserver:eyeXYController];

    messageController = [[MessageController alloc] init];

    spikeController = [[SpikeController alloc] init];
    [dataDoc addObserver:spikeController];

    xtController = [[XTController alloc] init];
    [dataDoc addObserver:xtController];	
    
    summaryController = [[SummaryController alloc] init];
    [dataDoc addObserver:summaryController];	
    
    announceEvents();		// give windows information about current settings 
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

	long choice;
	NSString *theString;
	BOOL writingDataFile = [[NSUserDefaults standardUserDefaults] boolForKey:writingDataFileKey];
	
// Nothing to worry about before quitting
	
	if ([taskMode isIdle] && !writingDataFile) {
		return NSTerminateNow;
	}

// Task running and/or data file open.  Ask for permission to terminate

	if (![taskMode isIdle] && writingDataFile) {
        theString = @"Task is running and data file is open.  Stop, close and quit?";
	}
	else if (writingDataFile) {
        theString = @"Data file is open.  Close and quit?";
	}
	else if (![taskMode isIdle]) {
        theString = @"Task is running.  Stop and quit?";
	}
	choice = NSRunAlertPanel(@"Experiment", theString, @"OK", @"Cancel", nil);
	if (choice == NSAlertDefaultReturn) {
		[taskMode setMode:kTaskEnding];
		return NSTerminateNow;
	}
	else {
		return NSTerminateCancel;
	}
}

// This is the place to put the clean up code for the application. 
// As a delegate for the NSApplication, we are automatically registered
// for this notification.

- (void)applicationWillTerminate:(NSNotification *)aNotification {

	[settingsController synchronize];
    [dataSource setDataEnabled:NO];
    [experStateSystem stop];
	collectorShouldTerminate = YES;

// We've already check it was ok to close open file

	if ([[NSUserDefaults standardUserDefaults] boolForKey:writingDataFileKey]) {	
		[dataDoc closeDataFile];
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:writingDataFileKey];
	}
    [dataDoc removeObserver:experStateSystem];
    [dataDoc removeObserver:behaviorController];
    [dataDoc removeObserver:eyeXYController];
    [dataDoc removeObserver:spikeController];
    [dataDoc removeObserver:xtController];

    [summaryController release];
}

// The main nib has been loaded now, so we can initialize with impunity 

- (void)awakeFromNib {

	long index;
	unsigned long spikeBits;
	LLMouseIODevice *mouseDataSource;

#ifdef USE_ITC
	LLITC18IODevice *ITC18DataSource;
#endif

	taskMode = [[LLTaskMode alloc] init];						// Set up a task mode controller
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskModeChange:)
				name:LLTaskModeChange object:Nil];
	
// Set up a report controller.  This must be done before things that attach reportables (e.g., stimulus Window)

	monitorController = [[LLMonitorController alloc] init];
	
// Set up the stimulus window.  This needs to be done before setting up the mouseData (below)
 
    stimulusWindow = [[StimWindow alloc] init];

// Set up the eye calibration system and a fixation window

	eyeCalibration = [[LLEyeCalibrator alloc] init]; 

// Set up the controller that will handle getting data from input devices, files, etc.
// We create hardware data sources for synthetic data, mouse data, and ITC-18 data (lab I/O).

    dataSourceController = [[LLIODeviceController alloc] initWithSamplePeriodMS:kSamplePeriodMS
                timestampTicksPerMS:kTimestampTickMS];

    synthDataSource = [[LLSynthIODevice alloc] init];
	[dataSourceController addIODevice:synthDataSource];	// don't release synthDataSource, we use it all the time

	mouseDataSource = [[LLMouseIODevice alloc] init];
	[mouseDataSource setOrigin:[stimulusWindow centerPointPix]];
	[dataSourceController addIODevice:mouseDataSource];
	[mouseDataSource release];							// release this, we won't need it again
	
#ifdef USE_ITC
	ITC18DataSource = [[[LLITC18IODevice alloc] initWithDevice:0] autorelease];
	[dataSourceController addIODevice:ITC18DataSource];
	[monitorController addMonitor:[ITC18DataSource monitor]];

	stimTrainDevice = [[LLITC18StimTrainDevice alloc] initWithDevice:1];
#endif

// Now that the hardware sources are set up, we can tell them which bits to monitor
	
	spikeBits = (0x1 << kVBLChannel);
	for (index = spikeBits = 0; index < kSpikeChannels; index++) {
		spikeBits |= (0x1 << (kVBLChannel + 1 + index));
	}
	[dataSourceController enableTimestampBits:spikeBits];
    dataSource = [dataSourceController dataSource];		// get the currently enabled data source

// Start the method that will collect data from the event buffer

    [NSThread detachNewThreadSelector:@selector(collectData) toTarget:self withObject:nil];
}

- (IBAction)changeDataSource:(id)sender {
	
	dataSource = [dataSourceController selectSource];
}

- (IBAction)changeSettings:(id)sender {

    [settingsController selectSettings];
}

- (void)collectData {

    short samples[kADChannels];
	TimestampData timestamp;
	NSDate *nextRelease;
    NSAutoreleasePool *threadPool;
	
    threadPool = [[NSAutoreleasePool alloc] init];
	nextRelease = [NSDate dateWithTimeIntervalSinceNow:kLLAutoreleaseIntervalS];
    while (!collectorShouldTerminate) {
		leverIsDown = [dataSource digitalInputValues] & kLeverBit;
        while ([dataSource ADData:samples]) {
            [dataDoc putEvent:@"sample01" withData:&samples];		// put sample channels 0 and 1
			currentEyeDeg = [eyeCalibration degPointFromUnitPoint:
						NSMakePoint(samples[kEyeXChannel], samples[kEyeYChannel])];
        }
        while ([dataSource timestampData:&timestamp]) {
			if (timestamp.channel == kVBLChannel) {
				if ([[NSUserDefaults standardUserDefaults] integerForKey:stimTypeKey] == kVisualStimulus) {
					[dataDoc putEvent:@"videoRetrace" withData:&timestamp.time];
				}
			}
			else if (timestamp.channel >= kFirstSpikeChannel && 
								timestamp.channel < kFirstSpikeChannel + kSpikeChannels) {
				timestamp.channel -= kFirstSpikeChannel;				// Make spike channels zero based
				[dataDoc putEvent:@"spike" withData:&timestamp];
			}
        }
		[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:kSamplePeriodMS / 1000.0]];
		if ([nextRelease timeIntervalSinceNow] < 0.0) {
			[threadPool release];
			threadPool = [[NSAutoreleasePool alloc] init];
			nextRelease = [NSDate dateWithTimeIntervalSinceNow:kLLAutoreleaseIntervalS];
		}
    }
    [threadPool release];
    collectorDidTerminate = YES;
}

// There is no guarantee that dealloc will actually be called, so we only do the releases here.

- (void) dealloc {

    while ([experStateSystem running]) {};					// wait for state system to stop, then release it
    [experStateSystem release];

	[aboutPanel release];
    [stimulusWindow release];								// release window controllers
    [behaviorController release];
    [eyeXYController release];
    [messageController release];
    [spikeController release];
    [xtController release];
	
    while (!collectorDidTerminate) {};						// wait for event collection to stop, then release
	[synthDataSource release];
    [dataSourceController release];

	[monitorController release];
    [dataDoc release];										// release data document and scheduler
    [eyeCalibration release];
	
    [defaults synchronize];									// synchronize defaults with disk
    [defaults release];
	[settingsController release];

	[taskMode release];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    [super dealloc];
}

- (void)displayFileName:(NSString *)fileName {

	NSRect frameRect = [controlPanel frame];
	long heightIncPix = ([fileName length] > 0) ? 30 : -30;
	
	[fileNameDisplay setStringValue:[NSString stringWithFormat:@"Saving Data to %@", fileName]];
	frameRect.size.height += heightIncPix;
	frameRect.origin.y -= heightIncPix;
	[controlPanel setFrame:frameRect display:YES animate:YES];
}

- (IBAction)doJuice:(id)sender {

	long juiceMS;
	NSSound *juiceSound;
	
	if ([sender respondsToSelector:@selector(juiceMS)]) {
		juiceMS = (long)[sender performSelector:@selector(juiceMS)];
	}
	else {
		juiceMS = [[NSUserDefaults standardUserDefaults] integerForKey:rewardKey];
	}
	[dataSource digitalOutputBitsOff:kRewardBit];
	[scheduler schedule:@selector(doJuiceOff) toTarget:self withObject:Nil delayMS:juiceMS];
	if ([[NSUserDefaults standardUserDefaults] boolForKey:soundsKey]) {
			juiceSound = [NSSound soundNamed:kCorrectSound];
			if ([juiceSound isPlaying]) {   // won't play again if it's still playing
				[juiceSound stop];
			}
			[juiceSound play];			// play juice sound
	}
}

- (void)doJuiceOff {

	[dataSource digitalOutputBitsOn:kRewardBit];
}

- (IBAction)doRunStop:(id)sender {
	
    switch ([taskMode mode]) {
    case kTaskIdle:
        [taskMode setMode:kTaskRunning];
        break;
    case kTaskStopping:
		[taskMode setMode:kTaskIdle];
        break;
    case kTaskRunning:
		[taskMode setMode:kTaskStopping];
        break;
    default:
        break;
    }
}

// The release notes for 10.3 say that the options for addObserver are ignore
// (http://developer.apple.com/releasenotes/Cocoa/AppKit.html).   THis means that the change dictionary
// will not contain the new values of the change.  For now it must be read directly from the model

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	static BOOL tested = NO;
	NSString *key;
	id newValue;
	long longValue;
	long uAPerV;
	float maxCurrent;

	if (!tested) {
		newValue = [change objectForKey:NSKeyValueChangeNewKey];
		if (![[newValue className] isEqualTo:@"NSNull"]) {
			NSLog(@"NSKeyValueChangeNewKey is not NSNull, JHRM needs to change how values are accessed");
		}
		tested = YES;
	}
	key = [keyPath pathExtension];
	if ([key isEqualTo:triesKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:triesKey];
		[dataDoc putEvent:triesKey withData:&longValue];
	}
	else if ([key isEqualTo:blockLimitKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:blockLimitKey];
		[dataDoc putEvent:blockLimitKey withData:&longValue];
	}
	else if ([key isEqualTo:responseTimeMSKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:responseTimeMSKey];
		[dataDoc putEvent:responseTimeMSKey withData:&longValue];
	}
	else if ([key isEqualTo:gapMSKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:gapMSKey];
		[dataDoc putEvent:gapMSKey withData:&longValue];
		requestReset();
	}
	else if ([key isEqualTo:intervalMSKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:intervalMSKey];
		[dataDoc putEvent:intervalMSKey withData:&longValue];
		requestReset();
	}
	else if ([key isEqualTo:preIntervalMSKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:preIntervalMSKey];
		[dataDoc putEvent:preIntervalMSKey withData:&longValue];
		requestReset();
	}
	else if ([key isEqualTo:postIntervalMSKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:postIntervalMSKey];
		[dataDoc putEvent:postIntervalMSKey withData:&longValue];
		requestReset();
	}
	else if ([key isEqualTo:stimTypeKey]) {
		longValue = [[NSUserDefaults standardUserDefaults] integerForKey:stimTypeKey];
		[dataDoc putEvent:@"stimulusType" withData:&longValue];
		requestReset();
	}
	else if ([key isEqualTo:contrastFactorKey] || 
				[key isEqualTo:maxContrastKey] ||
				[key isEqualTo:contrastsKey]) {
		[dataDoc putEvent:@"contrastStimParams" withData:getStimParams(kVisualStimulus)];
		requestReset();
	}
	else if ([key isEqualTo:currentFactorKey] || [key isEqualTo:maxCurrentKey] ||
												[key isEqualTo:currentsKey]) {
		if ([key isEqualTo:maxCurrentKey]) {
			maxCurrent = [[NSUserDefaults standardUserDefaults] floatForKey:maxCurrentKey];
			uAPerV = [[NSUserDefaults standardUserDefaults] integerForKey:uAPerVKey];
			if (maxCurrent > uAPerV * kITC18DAVoltageRangeV) {
				NSRunAlertPanel(@"StimulusSettings", 
					@"%.0f is more current than can be produced at %d uA per V", @"OK", nil, nil,
					maxCurrent, uAPerV);
				[[NSUserDefaults standardUserDefaults] setFloat:(uAPerV * kITC18DAVoltageRangeV) 
					forKey:maxCurrentKey];
			}
		}
		[dataDoc putEvent:@"contrastStimParams" withData:getStimParams(kElectricalStimulus)];
		requestReset();
	}
}

- (id)init {

	NSString *userDefaultsValuesPath;
    NSDictionary *userDefaultsValuesDict;

	if ((self = [super init]) == nil) {
		return nil;
	}
	
	[LLSystemUtil preventSleep];								// don't let the computer sleep
	appController = self;

// Load the default values for the user defaults.  These are the values that are used the first time
// the program is run.  Subsequent changes to values are preserved and used.  The default values are
// kept in UserDefaults.plist, which is in the application folder.  It is easier to edit this file with the 
// XML Editor rather than the XCode editor (although that is possible for quick changes.

    userDefaultsValuesPath = [[NSBundle mainBundle] 
						pathForResource:@"UserDefaults" ofType:@"plist"];
    userDefaultsValuesDict = [NSDictionary dictionaryWithContentsOfFile:userDefaultsValuesPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];

// I haven't figured out how to enter an NSColor as data in a plist...

	userDefaultsValuesDict = [NSDictionary 
					dictionaryWithObject:[NSArchiver archivedDataWithRootObject:[NSColor blueColor]] 
					forKey:eyeXYColorKey];
    [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsValuesDict];

// Create transformers that are needed to display values in dialogs (before nib is loaded);

	[NSValueTransformer setValueTransformer:[[[LLFactorToOctaveStepTransformer alloc] init] autorelease] 
					forName:@"FactorToOctaveStepTransformer"];

// Set up to respond to changes to the behavior values

	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.tries"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.blockLimit"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.responseTimeMS"
		options:NSKeyValueObservingOptionNew context:nil];

// Set up to respond to changes of the stimulus values

	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.gapMS"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.intervalMS"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.preintervalMS"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.postintervalMS"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.stimType"
		options:NSKeyValueObservingOptionNew context:nil];
		
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.contrasts"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.maxContrast"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.contrastFactor"
		options:NSKeyValueObservingOptionNew context:nil];
		
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.currents"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.maxCurrent"
		options:NSKeyValueObservingOptionNew context:nil];
	[[NSUserDefaultsController sharedUserDefaultsController] addObserver:self forKeyPath:@"values.currentFactor"
		options:NSKeyValueObservingOptionNew context:nil];

	settingsController = [[LLSettingsController alloc] init];
	defaults = [settingsController defaultSettings];
    [defaults retain];
	
	return self;
}

- (IBAction)resetRequest:(id)sender {

    requestReset();
}

- (IBAction)recordDontRecord:(id)sender {

	BOOL previousDataState;

// Start recording

	if (![[NSUserDefaults standardUserDefaults] boolForKey:writingDataFileKey]) {
		[dataDoc setUseDefaultDataDirectory:[defaults boolForKey:doDataDirectoryKey]];
		previousDataState = [dataSource setDataEnabled:NO];		// Stop any data collection
		if ([dataDoc createDataFile]) {
			[[NSUserDefaults standardUserDefaults] setBool:YES forKey:writingDataFileKey];
			announceEvents();
			reset();
			[self displayFileName:[[[dataDoc filePath] lastPathComponent] stringByDeletingPathExtension]];
			[resetButton setEnabled:NO];
			[recordDontRecordMenuItem setTitle:@"Stop Recording Data"];
			[recordDontRecordMenuItem setKeyEquivalent:@"W"];   // NB: Implies command-shift-w
		}
		[dataSource setDataEnabled:previousDataState];			// restore data collection
	}
	else {														// stop recording
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:writingDataFileKey];
		[self displayFileName:@""];
		[dataDoc closeDataFile];
		[resetButton setEnabled:YES];
		[recordDontRecordMenuItem setTitle:@"Record Data To File"];
		[recordDontRecordMenuItem setKeyEquivalent:@"s"];		// NB: Implies command-s (no shift)
	}
}

- (IBAction)showAboutPanel:(id)sender {

	if (aboutPanel == Nil) {
		aboutPanel = [[LLDefaultAboutBox alloc] init];
	}
	[aboutPanel showWindow:self];
}

- (IBAction)showDisplayCalibratorPanel:(id)sender {

    [stimulusWindow showDisplayParametersPanel];
}

- (IBAction)showEyeCalibratorPanel:(id)sender {

    [eyeCalibration showWindow:self];
}

- (IBAction)showReportPanel:(id)sender {

    [monitorController showWindow:self];
}

- (void)taskModeChange:(NSNotification *)notification {

	NSNumber *taskModeValue = [notification object];
	long mode;
	
	mode = [taskModeValue longValue];
	[dataDoc putEvent:@"taskMode" withData:(void *)&mode];
	switch ([taskModeValue longValue]) {
    case kTaskRunning:
		[runStopMenuItem setTitle:@"Stop"];
		[runStopMenuItem setKeyEquivalent:@"."];
		[runStopButton setImage:[NSImage imageNamed:@"StopButton.tif"]];
		[runStopButton setTitle:@"Stop"];
		[runStopButton setToolTip:@"Stop"];
        break;
    case kTaskStopping:
		[runStopMenuItem setTitle:@"Stop Now"];
		[runStopMenuItem setKeyEquivalent:@"."];
		[runStopButton setImage:[NSImage imageNamed:@"StoppingButton.tif"]];
		[runStopButton setTitle:@"Stop"];
		[runStopButton setToolTip:@"Stop Now"];
        break;
    case kTaskIdle:
		[runStopMenuItem setTitle:@"Run"];
		[runStopMenuItem setKeyEquivalent:@"r"];
		[runStopButton setImage:[NSImage imageNamed:@"PlayButton.tif"]];
		[runStopButton setTitle:@"Run"];
		[runStopButton setToolTip:@"Run"];
        break;
    default:
        break;
    }
}

// Disable certain menu items according to task state

- (BOOL)validateMenuItem:(id <NSMenuItem>)menuItem {

	SEL action = [menuItem action];
	BOOL writingDataFile = [[NSUserDefaults standardUserDefaults] boolForKey:writingDataFileKey];
	
	if (action == @selector(changeDataSource:)) {		// Data source
		return (!writingDataFile && ([taskMode isIdle]));
	}
	if (action == @selector(recordDontRecord:)) {		// Create or close data file
		return [taskMode isIdle];
	}
	if (action == @selector(resetRequest:)) {			// Reset
		return !writingDataFile;
	}
	if (action == @selector(showBehaviorPanel:)) {		// Change behavior settings
		return !writingDataFile;
	}
	if (action == @selector(showStimulusPanel:)) {		// Stimulus settings
		return !writingDataFile;
	}
	return YES;
}

@end
