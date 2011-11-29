//
//  LLSettingsController.m
//  Lablib
//
//  Created by John Maunsell on Sat Jun 14 2003.
//  Copyright (c) 2003. All rights reserved.
//

/* 

Different sets of settings are stored as NSDictionaries, which are bundled in an NSArray
that is stored in NSUserDefaults.  Old settings are stored by taking the NSUserDefaults
(which is an NSDictionary), stripping out the NSArray that contains all the settings
dictionaries, and then putting the dictionary into the array of settings.  New settings
are similarly extracted, have the array of settings inserted into them, then made a
replacement for NSUserDefaults.  Thus, the user is always using NSUserDefaults, and
we replace its contents. 

Support is provided for a dialog that allows the creation, deletion, selection and
renaming of different settings.  Because settings affect all operations, this dialog
is task-modal, and should only be accessed when the task is not running.  SImilarly,
any dialog containing entries from the NSUserDefaults should be closed before calling
this dialog, because their contents will be stale after any changes.  Because these
routines can change the contents of NSUserDefaults, anything that displays values from
NSUserDefaults (e.g., dialogs) should be loaded fresh each time they appear

*/

#import "LLSettingsController.h"

NSString *LLSettingsChanged = @"LLSettings Changed";

NSString *kDefaultSettingsName = @"Settings 0";
NSString *LLSettingsArrayKey = @"LL Settings Array";
NSString *LLSettingsIndexKey = @"LL Settings Index";
NSString *LLSettingsNameKey = @"LL Settings Name";

@implementation LLSettingsController

- (void)createSettingsWithName:(NSString *)name dictionary:(NSDictionary *)dict {

	long index;

// Install the new name and update the settings table

	[settingsNameArray addObject:name];
	index = [settingsNameArray indexOfObject:name];
	[settingsTable selectRow:index byExtendingSelection:NO];
	[settingsTable scrollRowToVisible:index];
	
// Create the new persistent domain, making sure it has the correct name entered

	[[NSUserDefaults standardUserDefaults] setPersistentDomain:dict 
				forName:[self domainNameWithName:name]];
}

- (void)dealloc {

	[settingsNameArray release];
	[super dealloc];
}

- (NSUserDefaults *)defaultSettings {

	return [NSUserDefaults standardUserDefaults];
}

- (IBAction)deleteSettings:(id)sender {

	long row = [settingsTable selectedRow];
	
	if ([settingsNameArray count] == 1) {
		NSBeginAlertSheet(@"LLSettingsController", 
			@"OK", nil, nil, [self window], self, nil,
			@selector(deleteSheetDidEnd:returnCode:contextInfo:), nil,
			@"There must always be least one configuration"); 
	}
	else {
		NSBeginAlertSheet(@"LLSettingsController", 
			@"Delete", @"Cancel", nil, [self window], self, nil,
			@selector(deleteSheetDidEnd:returnCode:contextInfo:), nil,
			[NSString stringWithFormat:@"Really delete configuration \"%@\"? This operation cannot be undone.",
			[settingsNameArray objectAtIndex:row]]);
	}
}

- (void)deleteSheetDidEnd:(id)sheet returnCode:(long)code contextInfo:(id)contextInfo {

	long row;
	NSUserDefaults *defaults;
	
	if ([settingsNameArray count] > 1) {				// never delete when there is only one
		switch (code) {
		case NSAlertDefaultReturn:						// OK to delete the settings
			defaults = [NSUserDefaults standardUserDefaults];
			row = [settingsTable selectedRow];			// row to delete
			[settingsArray removeObjectAtIndex:row];	// delete the corresponding settings
			[settingsNameArray removeObjectAtIndex:row];//  and their name
			[settingsTable reloadData];					// update table display
			dirty = YES; 
			break;
		case NSAlertAlternateReturn:
		default:
			break;
		}
	}
}

- (NSString *)domainNameWithName:(NSString *)name {

	return [NSString stringWithFormat:@"%@-%@", [[NSBundle mainBundle] bundleIdentifier], name];
}

- (IBAction)duplicateSettings:(id)sender {

	long index;
	NSMutableDictionary *dict;
	NSString *newName;

	index = [settingsTable selectedRow];				// get the settings to duplicate
	newName = [NSString stringWithFormat:@"%@ copy", [settingsNameArray objectAtIndex:index]];
	
	dict = [[NSMutableDictionary alloc] init];			// make a new settings dictionary
	[dict setDictionary:[settingsArray objectAtIndex:index]]; // load the settings to duplicate
	[dict setObject:newName forKey:LLSettingsNameKey];  // set the name for the new settings
	[settingsArray addObject:dict];						// add the new settings
	[dict release];

	[settingsNameArray addObject:newName];				// add the new name to the name array
	index = [settingsNameArray indexOfObject:newName];
	[settingsTable selectRow:index byExtendingSelection:NO];
	[settingsTable scrollRowToVisible:index];
	[settingsTable reloadData];							// Make sure number of rows is up to date
	dirty = YES;
}

- (id)init {

	NSMutableDictionary *dict;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
    if ((self =  [super initWithWindowNibName:@"LLSettingsController"]) != nil) {
        [self setWindowFrameAutosaveName:@"LLSettingsController"];
		[self window];

// We should be able to set the initialFirstResponder in IB, but that does not seem
// to work.  We need the table to come up as the first responder so that it will 
// respond to keys (e.g., arrows).

		[[self window] makeFirstResponder:settingsTable];

		settingsNameArray = [[NSMutableArray alloc] init];

// If a settings array does not exist, create one.
   
		if ([defaults arrayForKey:LLSettingsArrayKey] == nil) {
			dict = [[NSMutableDictionary alloc] initWithDictionary:
						[defaults persistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]];
			[dict setObject:kDefaultSettingsName forKey:LLSettingsNameKey];
			settingsArray = [[NSMutableArray alloc] initWithObjects:dict, nil];
			[defaults setObject:settingsArray forKey:LLSettingsArrayKey];
			[defaults setObject:[NSNumber numberWithInt:0] forKey:LLSettingsIndexKey];
			[dict release];
			[settingsArray release];
		}
	} 
	return self;
}
	
// Create new, empty settings (which will assume the registered default values).

- (IBAction)newSettings:(id)sender {

	long index;
	NSString *newName = [self uniqueSettingsName];
	
	[settingsArray addObject:[[NSDictionary alloc] initWithObjectsAndKeys:newName, LLSettingsNameKey, nil]];

	[settingsNameArray addObject:newName];				// add the new name to the list of settings names
	index = [settingsNameArray indexOfObject:newName];  // update the settings table in the dialog
	[settingsTable selectRow:index byExtendingSelection:NO];
	[settingsTable scrollRowToVisible:index];
	[settingsTable reloadData];							// make sure number of rows is up to date
	dirty = YES;
}

- (int)numberOfRowsInTableView:(NSTableView *)tableView {

    return [settingsNameArray count];
}

- (IBAction)ok:(id)sender {

	[NSApp stopModal];
}

- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView {

	if (disallowNextSelectionChange) {
		disallowNextSelectionChange = NO;
		return NO;
	}
	return YES;
}

// Present the dialog and let the user change settings

- (void)selectSettings;
{
	long index, settingsIndex;
	NSMutableDictionary *newDict, *currentDict;
	NSDictionary *testDict;
	NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

	[defaults synchronize];						// make sure persistent domain is up to date

// Load the settings array with a copy of the array from user defaults, and compile
// a parallel array of names of the settings.

	settingsIndex = [defaults integerForKey:LLSettingsIndexKey];
	settingsArray = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:LLSettingsArrayKey]];
	for (index = 0, [settingsNameArray removeAllObjects]; index < [settingsArray count]; index++) {
		[settingsNameArray addObject:[[settingsArray objectAtIndex:index] 
			objectForKey:LLSettingsNameKey]];
	}
	
// We have to copy the current settings to the appropriate entry in the settings array.
// We need to do this here, because entries in the settings array may get added or deleted,
// including the current one, and it would be difficult to find the appropriate entry after
// we return from the dialog session.  This way it is up to date, and we can use it, delete it, etc.

	currentDict = [[NSMutableDictionary alloc] init];
	[currentDict setDictionary:[defaults persistentDomainForName:bundleID]];
	[currentDict removeObjectForKey:LLSettingsArrayKey];
	[currentDict removeObjectForKey:LLSettingsIndexKey];
	[currentDict setObject:[settingsNameArray objectAtIndex:settingsIndex] forKey:LLSettingsNameKey];
	[settingsArray replaceObjectAtIndex:settingsIndex withObject:currentDict];

// Configure the table for display

	[settingsTable selectRow:settingsIndex byExtendingSelection:NO];
	[settingsTable scrollRowToVisible:settingsIndex];
	[settingsTable reloadData];							// make sure number of rows is up to date

// We are now ready to run the dialog.  All the duplication, creation or deletion will be done on
// settingsArray and settingsNameArray, which we will subsequently use to update the defaults

	[NSApp runModalForWindow:[self window]];

// The dirty flag is set whenever settings are added or deleted from the list.  If that happens,
// or the selection changes, we need to update the defaults

	NSLog(@"current index %d  old index %d", [settingsTable selectedRow], settingsIndex);
	if (dirty || ([settingsTable selectedRow] != settingsIndex)) {
		settingsIndex = [settingsTable selectedRow];			// current settings selected
		newDict = [[NSMutableDictionary alloc] init];
		[newDict setDictionary:[settingsArray objectAtIndex:settingsIndex]]; // get the settings
		[newDict setObject:[NSNumber numberWithInt:settingsIndex] forKey:LLSettingsIndexKey];
		[newDict removeObjectForKey:LLSettingsNameKey];
		[newDict setObject:settingsArray forKey:LLSettingsArrayKey];
		
		NSLog(@"Going to change the persistent domain for %@", bundleID);
		testDict = [NSDictionary dictionaryWithObject:[NSNumber numberWithLong:111] forKey:@"FTEyeXYHScroll"];		
		[defaults removePersistentDomainForName:bundleID];
		[defaults setPersistentDomain:testDict forName:bundleID];
//		[defaults setPersistentDomain:newDict forName:bundleID];
		[defaults synchronize];
		
		NSLog(@"Here's what the persistent domain dictionary looks like now: \n%@",
			[defaults persistentDomainForName:bundleID]);
			
		[newDict release];

		[[NSNotificationCenter defaultCenter] postNotificationName:LLSettingsChanged object:nil];
		dirty = NO;
	}
	
	[settingsArray release];
    [[self window] orderOut:self];
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

// Write the current settings into the appropriate domain so it is up to date

- (void)synchronize {

	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn
												row:(int)row {
	
	return [settingsNameArray objectAtIndex:row];
}

- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)column
						row:(int)rowIndex {

	NSString *string = object;
	NSMutableDictionary *dict;
	
	if ([[settingsNameArray objectAtIndex:rowIndex] isEqual:string]) {		// No change, do nothing
		return;
	}
	if ([string length] == 0) {												// Blank name, not allowed
		NSRunAlertPanel(@"LLSettingsController", @"Please use a name that is not blank.",
					@"OK", nil, nil, nil);
		disallowNextSelectionChange = YES;
		return;
	}
	if ([settingsNameArray containsObject:string]) {						// Name already taken
		NSRunAlertPanel(@"LLSettingsController", @"The name \"%@\" is already in use, please select another.",
					@"OK", nil, nil, string);
		disallowNextSelectionChange = YES;
		return;
	}

// Update the settings name array, and then change the name recorded within the corresponding 
// settings NSDictionary in standardUserDefaults
	
	[settingsNameArray replaceObjectAtIndex:rowIndex withObject:object];
	dict = [[NSMutableDictionary alloc] initWithDictionary:[settingsArray objectAtIndex:rowIndex]];
	[dict setObject:object forKey:LLSettingsNameKey];
	[settingsArray replaceObjectAtIndex:rowIndex withObject:dict];
	[dict release];
	dirty = YES;
}

- (NSString *)uniqueSettingsName {

	long count;
	NSString *newName;
	
	count = [settingsNameArray count];
	do {
		newName = [NSString stringWithFormat:@"Settings %d", count++];
	} while ([settingsNameArray containsObject:newName]);
	return newName;
}

@end
