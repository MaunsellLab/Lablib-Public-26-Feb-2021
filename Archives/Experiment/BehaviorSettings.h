//
//  BehaviorSettings.h
//  Experiment
//
//  Created by John Maunsell on Fri Apr 29 2003.
//  Copyright (c) 2003. All rights reserved.
//

extern NSString *acquireMSKey;
extern NSString *blockLimitKey;
extern NSString *fixateKey;
extern NSString *fixSpotSizeKey;
extern NSString *fixWindowWidthKey;
extern NSString *intertrialMSKey;
extern NSString *nontargetContrastKey;
extern NSString *respSpotSizeKey;
extern NSString *responseTimeMSKey;
extern NSString *respWindowWidthKey;
extern NSString *respWindow0AziKey;
extern NSString *respWindow0EleKey;
extern NSString *respWindow1AziKey;
extern NSString *respWindow1EleKey;
extern NSString *rewardKey;
extern NSString *saccadeTimeMSKey;
extern NSString *soundsKey;
extern NSString *tooFastMSKey;
extern NSString *triesKey;

@interface BehaviorSettings : NSWindowController {
/*    IBOutlet NSTextField 	*acquireField;
    IBOutlet NSTextField 	*blocksField;
    IBOutlet NSButton		*fixateCheckBox;
    IBOutlet NSTextField	*fixSpotSizeField;
    IBOutlet NSTextField	*fixWidthField;
    IBOutlet NSTextField 	*intertrialField;
    IBOutlet NSTextField	*nontargetContrastField;
    IBOutlet NSTextField 	*rewardField;
    IBOutlet NSTextField	*respSpotSizeField;
    IBOutlet NSTextField 	*respTimeField;
    IBOutlet NSTextField	*respWidthField;
    IBOutlet NSTextField	*respWindow0AziField;
    IBOutlet NSTextField	*respWindow0EleField;
    IBOutlet NSTextField	*respWindow1AziField;
    IBOutlet NSTextField	*respWindow1EleField;
    IBOutlet NSTextField	*saccadeTimeField;
    IBOutlet NSButton		*soundsCheckBox;
    IBOutlet NSTextField 	*tooFastField;
    IBOutlet NSTextField 	*triesField; */
}

- (void)loadEntries;
- (void)settingsChanged:(NSNotification *)notification;
/*
- (IBAction)changeAcquire:(id)sender;
- (IBAction)changeBlocks:(id)sender;
- (IBAction)changeFixate:(id)sender;
- (IBAction)changeFixSpotSize:(id)sender;
- (IBAction)changeFixWidth:(id)sender;
- (IBAction)changeIntertrial:(id)sender;
- (IBAction)changeNontargetContrast:(id)sender;
- (IBAction)changeRespSpotSize:(id)sender;
- (IBAction)changeRespTime:(id)sender;
- (IBAction)changeRespWidth:(id)sender;
- (IBAction)changeRespWind0Azi:(id)sender;
- (IBAction)changeRespWind0Ele:(id)sender;
- (IBAction)changeRespWind1Azi:(id)sender;
- (IBAction)changeRespWind1Ele:(id)sender;
- (IBAction)changeSaccade:(id)sender;
- (IBAction)changeSounds:(id)sender;
- (IBAction)changeTooFast:(id)sender;
- (IBAction)changeTries:(id)sender;
- (IBAction)changeReward:(id)sender; */

@end
