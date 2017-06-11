//
//  LLSettingsController.h
//  Lablib
//
//  Created by John Maunsell on Sat Jun 14 2003.
//  Copyright (c) 2017. All rights reserved.
//

extern NSString *LLSettingsChanged;

@interface LLSettingsController : NSWindowController {

    BOOL					allowNextSelectionChange;
    NSString                *baseDomain;
    NSString                *prefix;
    NSBundle                *plugin;
    NSString                *settingsDomain;
	NSMutableArray			*settingsFileNames;

    IBOutlet NSButton	 	*deleteButton;
    IBOutlet NSButton	 	*duplicateButton;
    IBOutlet NSButton	 	*newButton;
    IBOutlet NSButton	 	*okButton;
    IBOutlet NSTableView	*settingsTable;
}

- (BOOL)extractSettings;
- (id)initForPlugin:(NSBundle *)thePlugin prefix:(NSString *)prefix;
- (BOOL)loadSettings;
- (void)loadSettingsFileNames;
- (BOOL)registerDefaults;
- (void)selectSettings;

- (void)createSettingsWithName:(NSString *)name dictionary:(NSDictionary *)dict;
- (NSUserDefaults *)defaultSettings;
- (NSString *)domainNameWithName:(NSString *)name;
- (void)loadDefaultsFromFileWithSuffix:(NSString *)suffix;
- (NSString *)pathToFile:(NSString *)fileName;
- (void)saveCurrentDefaultsToFileWithSuffix:(NSString *)suffix;
- (void)synchronize;
- (NSString *)uniqueSettingsName;

- (IBAction)deleteSettings:(id)sender;
- (IBAction)duplicateSettings:(id)sender;
- (IBAction)newSettings:(id)sender;
- (IBAction)ok:(id)sender;

@end
