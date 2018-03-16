//
//  Fixate.h
//  Fixate
//
//  Created by John Maunsell on 12/23/04.
//  Copyright 2004. All rights reserved.
//

#import "FT.h"
#import "FTStateSystem.h"
#import "FTEyeXYController.h"

@interface Fixate : LLTaskPlugIn {

    NSMenuItem              *actionsMenuItem;
    NSPoint                 currentEyesUnits[kEyes];
    FTEyeXYController       *eyeXYController;                // Eye position display
    NSMenuItem              *settingsMenuItem;
    NSWindowController      *summaryController;
    NSWindowController      *xtController;
    NSArray                 *topLevelObjects;
    
    IBOutlet NSMenu         *settingsMenu;
    IBOutlet NSMenu         *actionsMenu;
//    IBOutlet NSMenuItem     *runStopMenuItem;
}

- (void)dataCollect:(NSTimer *)timer;
- (IBAction)doFixSettings:(id)sender;
- (IBAction)doJuice:(id)sender;
- (void)doJuiceOff;
- (IBAction)doReset:(id)sender;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) FTStimuli *stimuli;

@end
