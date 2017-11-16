//
//  LLSettingsController.h
//  Lablib
//
//  Created by John Maunsell on Sat Jun 14 2003.
//  Copyright (c) 2017. All rights reserved.
//

extern NSString *LLSettingsChanged;

@interface LLSettingsController : NSWindowController {

    BOOL                    allowNextSelectionChange;
    NSString                *baseDomain;
    NSString                *prefix;
    NSBundle                *plugin;
    NSString                *settingsDomain;
    NSMutableArray            *settingsFileNames;

    IBOutlet NSButton         *deleteButton;
    IBOutlet NSButton         *duplicateButton;
    IBOutlet NSButton         *newButton;
    IBOutlet NSButton         *okButton;
    IBOutlet NSTableView    *settingsTable;
}

- (void)checkRunTimes:(long)subjectNumber;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL extractSettings;
- (void)incrementRunTimes:(long)subjectNumber minRunTime:(float *)pMinTimeS totalRunTime:(float *)pTotalTimeS;
- (instancetype)initForPlugin:(NSBundle *)thePlugin prefix:(NSString *)prefix;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL loadSettings;
- (void)loadSettingsFileNames;
- (NSString *)pathToDomain:(NSString *)name;
- (NSString *)pathToFile:(NSString *)name;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL registerDefaults;
- (void)selectSettings;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *settingsFileName;
- (void)synchronize;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *uniqueSettingsName;

- (IBAction)deleteSettings:(id)sender;
- (IBAction)duplicateSettings:(id)sender;
- (IBAction)newSettings:(id)sender;
- (IBAction)ok:(id)sender;

@end
