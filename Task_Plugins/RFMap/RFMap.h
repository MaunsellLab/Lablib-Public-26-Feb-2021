//
//  RFMap.h
//  RFMap
//
//  Created by John Maunsell on 12/30/04.
//  Copyright 2004. All rights reserved.
//

#import "RF.h"
#import "RFSummaryController.h"
#import "RFStateSystem.h"
#import "RFEyeXYController.h"

@interface RFMap:LLTaskPlugIn {

    NSMenuItem              *actionsMenuItem;
    LLControlPanel          *controlPanel;
    NSPoint                 currentEyesUnits[kEyes];
    NSTimer                 *displayTimer;
    RFEyeXYController       *eyeXYController;                // Eye position display
    float                   originalFixOffsetDeg;            // holds incoming fix offset
//    LLSettingsController    *settingsController;
    NSMenuItem              *settingsMenuItem;
    RFSummaryController     *summaryController;
    NSArray                 *topLevelObjects;
    NSWindowController      *xtController;

    IBOutlet NSMenu         *settingsMenu;
    IBOutlet NSMenu         *actionsMenu;
    IBOutlet NSMenuItem     *runStopMenuItem;
}

- (void)dataCollect:(NSTimer *)timer;
- (void)displayPosition:(NSTimer*)theTimer;
- (void)doJuiceOff;

@property (NS_NONATOMIC_IOSONLY, readonly, strong) RFMapStimuli *stimuli;

- (IBAction)doFixSettings:(id)sender;
- (IBAction)doStimSettings:(id)sender;
- (IBAction)doJuice:(id)sender;
- (IBAction)doReset:(id)sender;
- (IBAction)postPosition:(id)sender;

@end
