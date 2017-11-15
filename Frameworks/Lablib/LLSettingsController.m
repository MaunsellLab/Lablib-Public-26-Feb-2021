//
//  LLSettingsController.m
//  Lablib
//
//  Created by John Maunsell on Sat Jun 14 2003.
//  Copyright (c) 2003-2017. All rights reserved.
//

/*
Support is provided for a dialog that allows the creation, deletion, selection and
renaming of different settings.  Because settings affect all operations, this dialog
is task-modal, and should only be accessed when the task is not running.  Similarly,
any dialog containing entries from the NSUserDefaults should be closed before calling
this dialog, because their contents will be stale after any changes.  Because these
routines can change the contents of NSUserDefaults, anything that displays values from
NSUserDefaults (e.g., dialogs) should be loaded fresh each time they appear.
*/

#import "LLSettingsController.h"
#import "LLSystemUtil.h"

#define kActiveSettings     @"LLActiveSettings"
#define kPreferencesPath    [NSString stringWithFormat:@"%@/Library/Preferences", NSHomeDirectory()]

NSString *LLSettingsChanged = @"LLSettings Changed";
NSString *kDefaultSettingsName = @"Settings 0";
NSString *LLSettingsNameKey = @"LLSettingsName";

@implementation LLSettingsController

- (void)checkRunTimes:(long)subjectNumber;
{
    double timeNow, timeStored;

    timeNow = [NSDate timeIntervalSinceReferenceDate];
    timeStored = [[NSUserDefaults standardUserDefaults]
                                floatForKey:[NSString stringWithFormat:@"%@LastRunTime%ld", prefix, subjectNumber]];
    if (timeNow - timeStored >= 12 * 60 * 60) {                 // More than 12 h ago (or timeStored nil)?
        [[NSUserDefaults standardUserDefaults] setFloat:0       // Then clear the run times
                                forKey:[NSString stringWithFormat:@"%@MinRunTime%ld", prefix, subjectNumber]];
        [[NSUserDefaults standardUserDefaults] setFloat:0
                                forKey:[NSString stringWithFormat:@"%@TotalRunTime%ld", prefix, subjectNumber]];
        [[NSUserDefaults standardUserDefaults] setFloat:[NSDate timeIntervalSinceReferenceDate]
                                forKey:[NSString stringWithFormat:@"%@LastRunTime%ld", prefix, subjectNumber]];
    }
}

- (NSString *)createNewSettingsFile;
{
    NSString *newName = [self uniqueSettingsName];

    [[NSUserDefaults standardUserDefaults]
            setPersistentDomain:[self userDefaults] forName:[self pathToDomain:newName]];
    [settingsFileNames addObject:newName];				// add the new name to the list of settings names
    return newName;
}

- (void)dealloc;
{
    [settingsFileNames release];
    [settingsDomain release];
    [plugin release];
    [prefix release];
    [baseDomain release];
    [super dealloc];
}

- (IBAction)deleteSettings:(id)sender;
{
    NSAlert *theAlert = [[NSAlert alloc] init];

    [theAlert setMessageText:[self className]];
    if ([settingsFileNames count] == 1) {
        [theAlert setInformativeText:NSLocalizedString(@"There must always be least one settings file", nil)];
        [theAlert beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
            if (result == NSModalResponseOK) {
            }
        }];
    }
    else {
        [theAlert setInformativeText:
         NSLocalizedString(@"Really delete settings? This operation cannot be undone.", nil)];
        [theAlert addButtonWithTitle:NSLocalizedString(@"Delete", @"Common Delete")];
        [theAlert addButtonWithTitle:NSLocalizedString(@"Cancel", @"Common Cancel")];
        [theAlert beginSheetModalForWindow:[self window] completionHandler:^(NSInteger result) {
            long row;
            NSString *fileName, *settingsFileName;
            NSDirectoryEnumerator *dirEnum;
            switch (result) {
                case NSAlertFirstButtonReturn:					// DELETE the settings
                    row = [settingsTable selectedRow];			// row to delete
                    NSLog(@"Deleting %@", [self pathToFile:[settingsFileNames objectAtIndex:row]]);
                    [[NSUserDefaults standardUserDefaults]
                            removePersistentDomainForName:[self pathToFile:[settingsFileNames objectAtIndex:row]]];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    settingsFileName = [NSString stringWithFormat:@"%@.%@",
                                        baseDomain, [settingsFileNames objectAtIndex:row]];
                    dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:kPreferencesPath];
                    while ((fileName = [dirEnum nextObject])) {
                        if ([fileName hasPrefix:settingsFileName]) {
                            [[NSFileManager defaultManager] removeItemAtPath:
                             [NSString stringWithFormat:@"%@/Library/Preferences/%@", NSHomeDirectory(), fileName]
                             error:nil];
                        }
                        [dirEnum skipDescendents];				// don't go into any directories
                    }
                    [settingsFileNames removeObjectAtIndex:row];//  and their name
                    [settingsTable reloadData];					// update table display
                    break;
                case NSAlertSecondButtonReturn:                 // CANCEL the deletion
                default:
                    break;
            }
        }];
    }
    [theAlert release];
}

// Respond to the duplicate button. In this case, we make a new file with the contents of the current
// settings, and we save the current settings with their current name.

- (IBAction)duplicateSettings:(id)sender;
{
    long index, j;
    NSString *tempName, *newName;
    NSDictionary *settingsDict;

    index = [settingsTable selectedRow];				// get the settings to duplicate
    tempName = [NSString stringWithFormat:@"%@ Copy", [settingsFileNames objectAtIndex:index]];
    newName = tempName;
    j = 1;
    while ([settingsFileNames containsObject:newName]) {
        newName = [NSString stringWithFormat:@"%@ %ld", tempName, j++];
    }
    settingsDict = [[NSUserDefaults standardUserDefaults]
                    persistentDomainForName:[self pathToDomain:[settingsFileNames objectAtIndex:index]]];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:settingsDict forName:[self pathToDomain:newName]];
    [settingsFileNames addObject:newName];				// add the new name to the name array
//    index = [settingsFileNames indexOfObject:newName];
    [settingsTable reloadData];							// Make sure number of rows is up to date
}

- (BOOL)extractSettings;
{
    NSString *key, *windowFramePrefix;
    NSMutableDictionary *knotDict, *settingsDict;
    NSEnumerator *enumerator;
    id theObject;

    knotDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            persistentDomainForName:[NSBundle mainBundle].bundleIdentifier]];
    settingsDict = [[NSMutableDictionary alloc] init];
    enumerator = [knotDict keyEnumerator];
    windowFramePrefix = [NSString stringWithFormat:@"NSWindow Frame %@", prefix];
    for (key in enumerator) {
        if ([key hasPrefix:prefix] || [key hasPrefix:windowFramePrefix]) {
            theObject = [[NSUserDefaults standardUserDefaults] objectForKey:key];
            if (theObject != nil) {
                [settingsDict setObject:theObject forKey:key];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
        }
    }
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:settingsDict forName:settingsDomain];
    [[NSUserDefaults standardUserDefaults] synchronize];        // write any changes to disk
    [settingsDict release];
    return YES;
}

- (void)incrementRunTimes:(long)subjectNumber minRunTime:(float *)pMinTimeS totalRunTime:(float *)pTotalTimeS;
{
    NSString *minRunKey = [NSString stringWithFormat:@"%@MinRunTimeS", prefix];
    NSString *totalRunKey = [NSString stringWithFormat:@"%@TotalRunTimeS", prefix];

    *pMinTimeS += [[NSUserDefaults standardUserDefaults] floatForKey:minRunKey];
    *pTotalTimeS += [[NSUserDefaults standardUserDefaults] floatForKey:totalRunKey];
    [[NSUserDefaults standardUserDefaults] setFloat:*pMinTimeS forKey:minRunKey];
    [[NSUserDefaults standardUserDefaults] setFloat:*pTotalTimeS forKey:totalRunKey];
    [[NSUserDefaults standardUserDefaults] setFloat:[NSDate timeIntervalSinceReferenceDate]
                forKey:[NSString stringWithFormat:@"%@LastRunTime%ld", prefix, subjectNumber]];
}

- (instancetype)initForPlugin:(NSBundle *)thePlugin prefix:(NSString *)thePrefix;
{
    NSString *settingsName;
    NSDictionary *baseDict;

    if ((self = [super initWithWindowNibName:@"LLSettingsController"]) != nil) {
        plugin = thePlugin;
        [plugin retain];
        prefix = thePrefix;
        [prefix retain];
        baseDomain = [NSString stringWithFormat:@"lablib.knot.%@",
                                            [plugin objectForInfoDictionaryKey:@"CFBundleExecutable"]];
        [baseDomain retain];
        [self window];
        [self setWindowFrameAutosaveName:@"LLSettingsController"];
        [[self window] makeFirstResponder:settingsTable];
        settingsFileNames = [[NSMutableArray alloc] init];

        // If there is no base domain plist, create one.  loadSettings will check for existence of settings file.

        if ((baseDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:baseDomain]) == nil) {
            NSLog(@"Found no base domain -- creating one");
            [self loadSettingsFileNames];
            if ([settingsFileNames count] == 0) {                       // no settings files, make one
                NSLog(@"Found no settings files -- creating one");
                settingsName = [self createNewSettingsFile];
                settingsDomain = [self pathToDomain:settingsName];
                [settingsDomain retain];
            }
            else {                                                      // take first usable settings file
                settingsDomain = [self pathToDomain:[settingsFileNames objectAtIndex:0]];
                [settingsDomain retain];
            }
            [[NSUserDefaults standardUserDefaults] setPersistentDomain:@{kActiveSettings:settingsDomain}
                                                                            forName:baseDomain];
        }
    }
    return self;
}

- (BOOL)loadSettings;
{
    long subjectNumber;
    NSDictionary *pluginDict, *settingsDict;
    NSMutableDictionary *knotDict;

    if ((pluginDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:baseDomain]) == nil) {
        return NO;
    }

    // if there is not no setting file specified, take the first one found

    [settingsDomain release];
    if ((settingsDomain = [pluginDict objectForKey:kActiveSettings]) == nil) {
        [self loadSettingsFileNames];
        if ([settingsFileNames count] == 0) {               // no settings files, make one
            NSLog(@"Found no settings files -- creating one");
            [self createNewSettingsFile];
        }
        settingsDomain = [self pathToDomain:[settingsFileNames objectAtIndex:0]];
        [[NSUserDefaults standardUserDefaults] setPersistentDomain:@{kActiveSettings:settingsDomain} forName:baseDomain];
    }
    [settingsDomain retain];
    settingsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:settingsDomain];
    NSLog(@"Loading domain named %@", settingsDomain);

    knotDict = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]
                                            persistentDomainForName:[NSBundle mainBundle].bundleIdentifier]];
    [knotDict addEntriesFromDictionary:settingsDict];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:knotDict forName:[NSBundle mainBundle].bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];

    // If there is a subject number, check whether the run times should be reset.

    subjectNumber = [[NSUserDefaults standardUserDefaults] integerForKey:
                                                        [NSString stringWithFormat:@"%@SubjectNumber", prefix]];
    [self checkRunTimes:subjectNumber];
    return YES;
}

- (void)loadSettingsFileNames;
{
    NSString *fileName;
    NSArray *pathComponents;
    NSDirectoryEnumerator *dirEnum;

    [settingsFileNames removeAllObjects];
    dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:kPreferencesPath];

    // The OS sometimes creates temporary files, with an extension appended on the full name.  This puts the
    // base settings file with a count of 5 and its normal extension "plist" at index 3. We check for that.

    while ((fileName = [dirEnum nextObject])) {
        if ([fileName hasPrefix:baseDomain]) {
            pathComponents = [fileName componentsSeparatedByString:@"."];
            if ([pathComponents count] == 5) {   // avoid the base settings plist file
                if (![[pathComponents objectAtIndex:3] isEqualTo:@"plist"]) {
                    [settingsFileNames addObject:[pathComponents objectAtIndex:3]];
                }
            }
        }
        [dirEnum skipDescendents];				// don't go into any directories
    }
}

// Create new settings (which will assume the registered default values).

- (IBAction)newSettings:(id)sender;
{
    long index;
    NSString *newName;

    newName = [self createNewSettingsFile];
    index = [settingsFileNames indexOfObject:newName];  // update the settings table in the dialog
    [settingsTable reloadData];							// make sure number of rows is up to date
    [settingsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    [settingsTable scrollRowToVisible:index];
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView;
{
    return (int)[settingsFileNames count];
}

- (IBAction)ok:(id)sender;
{
    [NSApp stopModal];
}

- (NSString *)pathToDomain:(NSString *)name;
{
    return [NSString stringWithFormat:@"%@/Library/Preferences/%@.%@", NSHomeDirectory(), baseDomain, name];
}

- (NSString *)pathToFile:(NSString *)name;
{
    return [NSString stringWithFormat:@"%@.plist", [self pathToDomain:name]];
}


// Find the file "UserDefaults.plist" in the resources of the named plugin and register the contents in
// a persistent domain.  This should be called immediately after calling loadSettingsDefaultsForPlugin,
// so it will fill any holes that need to be plugged.

- (BOOL)registerDefaults;
{
    NSDictionary *pluginValuesDict;

    pluginValuesDict = [self userDefaults];
    [[NSUserDefaults standardUserDefaults] registerDefaults:pluginValuesDict];
    return YES;
}

- (void)saveSettingsDomainName;
{
    NSMutableDictionary *theDict;

    theDict = [NSMutableDictionary dictionaryWithDictionary:
               [[NSUserDefaults standardUserDefaults] persistentDomainForName:baseDomain]];
    [theDict setObject:settingsDomain forKey:kActiveSettings];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:theDict forName:baseDomain];
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
{
    BOOL allow = allowNextSelectionChange;

    allowNextSelectionChange = YES;
    return allow;
}

- (void)selectSettings;
{
    long settingsIndex;
    NSString *pName, *newSettingsName;

    if (settingsDomain == nil) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] synchronize];		// make sure persistent domain is up to date

    // Load the array of names with all candidate files

    [self loadSettingsFileNames];
    if ([settingsFileNames count] == 0) {
        [duplicateButton setEnabled:NO];
        [deleteButton setEnabled:NO];
    }
    else {
        [settingsFileNames sortUsingSelector:@selector(caseInsensitiveCompare:)];
        [duplicateButton setEnabled:YES];
        [deleteButton setEnabled:YES];
    }
    [settingsTable reloadData];                                 // make sure number of rows is up to date
    pName = [[settingsDomain componentsSeparatedByString:@"."] lastObject];
    settingsIndex = [settingsFileNames indexOfObject:pName];
    if (settingsIndex != NSNotFound) {
        [settingsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:settingsIndex] byExtendingSelection:NO];
        [settingsTable scrollRowToVisible:settingsIndex];
    }
    [NSApp runModalForWindow:[self window]];
    [[self window] orderOut:self];
    if ([settingsTable selectedRow] >= 0) {
        newSettingsName = [settingsFileNames objectAtIndex:[settingsTable selectedRow]];
        if (![pName isEqualToString:newSettingsName]) {
            NSLog(@"Switching settings from %@ to %@", settingsDomain, [self pathToDomain:newSettingsName]);
            [self extractSettings];
            [settingsDomain release];
            settingsDomain = [self pathToDomain:newSettingsName];
            [settingsDomain retain];
            [self saveSettingsDomainName];
            [self loadSettings];
            [[NSNotificationCenter defaultCenter] postNotificationName:LLSettingsChanged object:nil];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];		// make sure persistent domain is up to date
    }
}

- (NSString *)settingsFileName;
{
    NSString *fileName;

    fileName = [settingsDomain stringByReplacingOccurrencesOfString:@" " withString:@"!"];
    fileName = [fileName pathExtension];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"!" withString:@" "];
    return fileName;
}

- (void)synchronize;
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
{
    return [settingsFileNames objectAtIndex:row];
}

// tableView is called when the user tries to rename one of the settings

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)column
              row:(int)rowIndex;
{
    NSString *newName = object;
    NSString *oldName = [settingsFileNames objectAtIndex:rowIndex];
    NSDictionary *settingsDict;

    if ([oldName isEqual:newName]) {                                        // no change, do nothing
        return;
    }
    if ([newName length] == 0) {                                            // blank name, not allowed
        [LLSystemUtil runAlertPanelWithMessageText:[self className] informativeText:@"Blank name not allowed."];
        allowNextSelectionChange = NO;
        return;
    }
    if ([settingsFileNames containsObject:newName]) {						// Name already taken
        [LLSystemUtil runAlertPanelWithMessageText:[self className]
               informativeText:[NSString stringWithFormat:@"The name \"%@\" is already in use, please select another.",
               newName]];
        allowNextSelectionChange = NO;
        return;
    }
    [settingsFileNames replaceObjectAtIndex:rowIndex withObject:object];
    settingsDict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:[self pathToDomain:oldName]];
    NSLog(@"Creating new settings for %@ from %@", [self pathToDomain:newName], [self pathToDomain:oldName]);
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:settingsDict forName:[self pathToDomain:newName]];
    NSLog(@"Deleting %@", [self pathToDomain:oldName]);
    [[NSFileManager defaultManager] removeItemAtPath:[self pathToFile:oldName] error:nil];
}

- (NSString *)uniqueSettingsName;
{
    long count;
    NSString *newName;

    count = [settingsFileNames count];
    do {
        newName = [NSString stringWithFormat:@"Settings %ld", count++];
    } while ([settingsFileNames containsObject:newName]);
    return newName;
}

- (NSDictionary *)userDefaults;
{
    NSString *pluginValuesPath;
    NSDictionary *pluginValuesDict;

    if ((pluginValuesPath = [plugin pathForResource:@"UserDefaults" ofType:@"plist"]) == nil) {
        return nil;
    }
    if ((pluginValuesDict = [NSDictionary dictionaryWithContentsOfFile:pluginValuesPath]) == nil) {
        return nil;
    }
    return pluginValuesDict;
}







/*

- (void)createSettingsWithName:(NSString *)name dictionary:(NSDictionary *)dict;
{
    long index;

    // Install the new name and update the settings table

    [settingsFileNames addObject:name];
    index = [settingsFileNames indexOfObject:name];
    [settingsTable selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    [settingsTable scrollRowToVisible:index];

    // Create the new persistent domain, making sure it has the correct name entered

    [[NSUserDefaults standardUserDefaults] setPersistentDomain:dict
                                                       forName:[self domainNameWithName:name]];
}

// Present the dialog and let the user change settings.  Unused settings are kept in plist files named by
// appending a name to the default plist file.

- (NSUserDefaults *)defaultSettings;
{
	return [NSUserDefaults standardUserDefaults];
}

- (NSString *)domainNameWithName:(NSString *)name;
{
	return [NSString stringWithFormat:@"%@-%@", [[NSBundle mainBundle] bundleIdentifier], name];
}

// Load defaults from an NSDictionary in a file in ~/Library/Preferences using the bundle ID name
// and a suffix.

- (void)loadDefaultsFromFileWithSuffix:(NSString *)suffix;
{
	NSDictionary *dict;
	NSEnumerator *keyEnumerator;
	NSString *key;
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"LLSettingsController: Loading file from %@", [self pathToFile:suffix]);
	dict = [NSDictionary dictionaryWithContentsOfFile:[self pathToFile:suffix]];
	[defaults removePersistentDomainForName:bundleID];
	[defaults setPersistentDomain:dict forName:bundleID];
	[defaults synchronize];

// Setting the domain is not good enough when we are using key-value binding.  We need to set each value
// explicitly so they are registered

	keyEnumerator = [dict keyEnumerator];
	while ((key = [keyEnumerator nextObject])) {
		[defaults setObject:[dict objectForKey:key] forKey:key];
	}
}
	
// Save the current defaults as an NSDictionary in a file in ~/Library/Preferences using the bundle ID name
// and a suffix.

- (void)saveCurrentDefaultsToFileWithSuffix:(NSString *)suffix;
{
	NSDictionary *dict;
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults synchronize];
	dict = [NSDictionary dictionaryWithDictionary:[defaults persistentDomainForName:bundleID]];
	[dict writeToFile:[NSString stringWithFormat:@"%@/Library/Preferences/%@.%@.plist", NSHomeDirectory(), 
					bundleID, suffix] atomically:YES];
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

// Write the current settings into the appropriate domain so it is up to date

 */

@end
