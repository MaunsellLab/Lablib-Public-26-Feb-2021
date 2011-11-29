//
//  BehaviorSettings.m
//  Experiment
//
//  Created by John Maunsell on Fri Apr 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "BehaviorSettings.h"
#import "Experiment.h"

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

@implementation BehaviorSettings
/*
- (IBAction)changeAcquire:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:acquireMSKey];
}

- (IBAction)changeBlocks:(id)sender {

	long blockLimit = [sender intValue];
	
    [[NSUserDefaults standardUserDefaults] setInteger:blockLimit forKey:blockLimitKey];
	[dataDoc putEvent:@"blockLimit" withData:&blockLimit];
}

- (IBAction)changeFixate:(id)sender {

    [[NSUserDefaults standardUserDefaults] setBool:([sender intValue] == NSOnState) 
                                forKey:fixateKey];
}

- (IBAction)changeFixSpotSize:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:fixSpotSizeKey];
}

- (IBAction)changeFixWidth:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:fixWindowWidthKey];
}

- (IBAction)changeIntertrial:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:intertrialMSKey];
}

- (IBAction)changeNontargetContrast:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:nontargetContrastKey];
}

- (IBAction)changeRespSpotSize:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respSpotSizeKey];
}

- (IBAction)changeRespTime:(id)sender {

    long responseTimeMS = [sender intValue];

    [[NSUserDefaults standardUserDefaults] setInteger:responseTimeMS forKey:responseTimeMSKey];
	[dataDoc putEvent:@"responseTimeMS" withData:&responseTimeMS];
}

- (IBAction)changeRespWidth:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respWindowWidthKey];
}

- (IBAction)changeRespWind0Azi:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respWindow0AziKey];
}

- (IBAction)changeRespWind0Ele:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respWindow0EleKey];
}

- (IBAction)changeRespWind1Azi:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respWindow1AziKey];
}

- (IBAction)changeRespWind1Ele:(id)sender {

    [[NSUserDefaults standardUserDefaults] setFloat:[sender floatValue] forKey:respWindow1EleKey];
}

- (IBAction)changeReward:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:rewardKey];
}

- (IBAction)changeSounds:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:soundsKey];
}

- (IBAction)changeSaccade:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:saccadeTimeMSKey];
}

- (IBAction)changeTooFast:(id)sender {

    [[NSUserDefaults standardUserDefaults] setInteger:[sender intValue] forKey:tooFastMSKey];
}

- (IBAction)changeTries:(id)sender {
	
	long tries = [sender intValue];
	
    [[NSUserDefaults standardUserDefaults] setInteger:tries forKey:triesKey];
	[dataDoc putEvent:@"tries" withData:&tries];
}
*/
- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

- (id)init {

    if ((self = [super initWithWindowNibName:@"BehaviorSettings"])) {
        [self setWindowFrameAutosaveName:@"BehaviorSettingsWindow"];
		[self window];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:)
				name:LLSettingsChanged object:Nil];
    }   
    return self;
}

- (void)loadEntries {

 //   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
/*
	[acquireField setIntValue:[defaults integerForKey:acquireMSKey]];
    [blocksField setIntValue:[defaults integerForKey:blockLimitKey]];
    [fixateCheckBox setIntValue:[defaults integerForKey:fixateKey]];
    [fixSpotSizeField setFloatValue:[defaults floatForKey:fixSpotSizeKey]];
    [fixWidthField setFloatValue:[defaults integerForKey:fixWindowWidthKey]];
    [intertrialField setIntValue:[defaults integerForKey:intertrialMSKey]];
    [nontargetContrastField setIntValue:[defaults integerForKey:nontargetContrastKey]];
    [respSpotSizeField setFloatValue:[defaults floatForKey:respSpotSizeKey]];
    [respTimeField setIntValue:[defaults integerForKey:responseTimeMSKey]];
    [respWidthField setFloatValue:[defaults floatForKey:respWindowWidthKey]];
    [respWindow0AziField setFloatValue:[defaults floatForKey:respWindow0AziKey]];
    [respWindow0EleField setFloatValue:[defaults floatForKey:respWindow0EleKey]];
    [respWindow1AziField setFloatValue:[defaults floatForKey:respWindow1AziKey]];
    [respWindow1EleField setFloatValue:[defaults floatForKey:respWindow1EleKey]];

    [rewardField setIntValue:[defaults integerForKey:rewardKey]];
    [saccadeTimeField setIntValue:[defaults integerForKey:saccadeTimeMSKey]];
    [soundsCheckBox setIntValue:[defaults integerForKey:soundsKey]];
    [tooFastField setIntValue:[defaults integerForKey:tooFastMSKey]];
    [triesField setIntValue:[defaults integerForKey:triesKey]]; */
}

- (void)settingsChanged:(NSNotification *)notification {

//	[self loadEntries];
}

- (void)windowDidLoad {

//	[self loadEntries];
}

@end
