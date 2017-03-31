//
//  OPMatlabController.m
//  OptiPulse
//
//  Created by John Maunsell on 1/7/17.
//

#import "LLMatlabController.h"
#import "LLSystemUtil.h"

#define kMatlabInitScriptCommand    @"clear all; close all; dParams = []; dParams = OPMatlab(dParams);"
#define kMatlabDataPath             @"/Users/Shared/Data/Matlab/"
#define kMatlabScriptCommand        @"dParams = OPMatlab(dParams, file, trials);"
#define kOPMatlabTrialNumKey        @"OPMatlabTrialNum"
#define kTrialStartEventName        @"trialStart"

@implementation LLMatlabController : NSObject

// The task need to have defined all the task events with the dataDoc before the Matlab controller is activated

- (void)activate:(LLTaskPlugIn *)plugin;
{
    long index, event, stop;
    NSString *eventName;
    LLDataEventDef *eventDef;
    NSString *bundledEventPrefixes[] = {@"sample", @"eye", @"spike", @"timestamp", @"VBL", @"vbl", @"eStimData", nil};
    NSString *bundledEventStops[] = {@"calibration", @"zero", @"window", @"eyeCal", @"Break", nil};

    task = plugin;

    numEvents = [[task dataDoc] numEvents];
    trialStartTime = -1;
    eventDef = [[task dataDoc] eventNamed:kTrialStartEventName];
    trialStartEventCode = [eventDef code];
    trialEventCounts = calloc(numEvents, sizeof(long));             // count of each event in current trial

    // Make a dictionary, bundledEvents, for all the events that are to be bundled as samples or timestamps.
    // We use the event name as the key, and store an NSString as the object.  This NSString will be used to
    // compose the output string for the bundled data. Bundled events are written out as an array of values at the
    // end of each  trial.

    bundledString = [[NSMutableString alloc] init];
    bundledEvents = [[NSMutableDictionary alloc] init];
    for (event = 0; event < numEvents; event++) {
        eventDef = [[task dataDoc] eventDefForCode:event];
        eventName = [eventDef name];
        for (index = 0; bundledEventPrefixes[index] != nil; index++) {
            if ([eventName hasPrefix:bundledEventPrefixes[index]]) {
                for (stop = 0; bundledEventStops[stop] != nil; stop++) {
                    if ([eventName rangeOfString:bundledEventStops[stop]
                                         options:NSCaseInsensitiveSearch].length != 0) {
                        break;
                    }
                }
                if (bundledEventStops[stop] == nil) {
                    [bundledEvents setObject:[[[NSMutableString alloc] init] autorelease] forKey:eventName];
                }
                break;
            }
        }
    }

    engine = [task matlabEngine];
    [engine addMatlabPathForPlugin:@"OptiPulse"];
    [engine evalString:kMatlabInitScriptCommand];
    [self loadMatlabWorkspace];
    [[task dataDoc] addObserver:self];
}

- (void)checkMatlabDataPath;
{
    BOOL exists, isDir;
    NSError *error;
    NSString *path;
    NSFileManager *fm;

    fm = [[NSFileManager alloc] init];                          // check whether the subject directory exists
    path = [NSString stringWithFormat:@"%@%ld", kMatlabDataPath, subjectNumber];
    exists = [fm fileExistsAtPath:path isDirectory:&isDir];
    if (!exists) {                                              // guarantee that the directory will be there
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
    else if (!isDir) {
        NSLog(@"OPMatlabController: openMatlabDataFile, %@ is not a directory", path);
        exit(1);
    }
    [fm release];
}

// Return a string after converting C-style subscripts ([0])
// to Matlab-style subscripts ((1)).  We determine that something is a C-style subscript
// if: 1) a '[' followed by a ']'; there is no ' ' immediately preceding the '['; and
// 3) there are only digits between the '[' and ']'.

- (NSMutableString *)convertToMatlabString:(NSString *)eventString;
{
    int subscript;
    NSRange leftBracketRange, rightBracketRange;
    NSScanner *scanner;
    NSMutableString *convertedString = nil;

    for (;;) {
        leftBracketRange = [eventString rangeOfString:@"["];
        if (leftBracketRange.location == NSNotFound) {
            break;
        }
        rightBracketRange = [eventString rangeOfString:@"]"];
        if (rightBracketRange.location == NSNotFound) {
            break;
        }
        if (rightBracketRange.location < leftBracketRange.location) {
            break;
        }
        if (leftBracketRange.location == 0) {
            break;
        }
        if ([eventString characterAtIndex:(leftBracketRange.location - 1)] == ' ') {
            break;
        }
        if ([[eventString substringWithRange:NSMakeRange(leftBracketRange.location,
                                                         rightBracketRange.location - leftBracketRange.location)]
             rangeOfString:@" "].location != NSNotFound) {
            break;
        }
        scanner = [NSScanner scannerWithString:[eventString
                                                substringWithRange:NSMakeRange(leftBracketRange.location + 1,
                                                rightBracketRange.location - leftBracketRange.location - 1)]];
        [scanner scanInt:&subscript];
        convertedString = [NSMutableString stringWithFormat:@"%@(%d)%@",
                       [eventString substringWithRange:NSMakeRange(0, leftBracketRange.location)],
                       subscript + 1,
                       [eventString substringWithRange:NSMakeRange(rightBracketRange.location + 1,
                       ([eventString length] - rightBracketRange.location - 1))]];
    }
    if (convertedString == nil) {
        convertedString = [NSMutableString stringWithString:eventString];
    }
    return convertedString;
}

- (void)deactivate;
{
    [self saveMatlabWorkspace];
    [engine evalString:@"clear all; close all;"];
    [[task dataDoc] removeObserver:self];
    free(trialEventCounts);
    [bundledEvents release];
    [bundledString release];
    engine = nil;
}

- (id)initWithSubjectNumber:(long)number;
{
    if ((self = [super init]) != nil) {
        subjectNumber = number;
        [self checkMatlabDataPath];
    }
    return self;
}

- (void)loadMatlabWorkspace;
{
    BOOL exists, isDir;
    NSString *path;
    NSDate *today;
    NSDateFormatter *dateFormatter;
    NSFileManager *fm;

    today = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    path = [NSString stringWithFormat:@"%@%ld/%@.mat", kMatlabDataPath, subjectNumber,
            [dateFormatter stringFromDate:today]];
    fm = [[NSFileManager alloc] init];                                  // first check whether the directory exists
    exists = [fm fileExistsAtPath:path isDirectory:&isDir];
    if (exists && !isDir) {
        [engine evalString:[NSString stringWithFormat:@"load '%@'", path]];
        trialNum = [[task defaults] integerForKey:kOPMatlabTrialNumKey];
        [engine evalString:kMatlabScriptCommand];
    }
    [today release];
    [dateFormatter release];
    [fm release];
}

- (BOOL)matlabFileExists;
{
    BOOL exists, isDir;
    NSDate *today;
    NSDateFormatter *dateFormatter;
    NSString *path;
    NSFileManager *fm;

    fm = [[NSFileManager alloc] init];                                  // first check whether the directory exists
    path = [NSString stringWithFormat:@"%@%ld", kMatlabDataPath, subjectNumber];
    exists = [fm fileExistsAtPath:path isDirectory:&isDir];
    today = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    path = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.mat", [dateFormatter stringFromDate:today]]];
    exists = [fm fileExistsAtPath:path isDirectory:&isDir];
    return exists && !isDir;
}

- (NSString *)matlabFileName;
{
    NSDate *today;
    NSDateFormatter *dateFormatter;
    NSString *fileName;

    if (subjectNumber == -1) {
        NSLog(@"OPMatlabController: openMatlabDataFile, no subject number specified");
        return nil;
    }
    today = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    fileName = [NSString stringWithFormat:@"%@%ld/%@.mat", kMatlabDataPath, subjectNumber,
                [dateFormatter stringFromDate:today]];
    return fileName;
}

// Convert a DataEvent into strings for Matlab to evaluate

- (void)processEventNamed:(NSString *)eventName eventData:(NSData *)eventData eventTime:(NSNumber *)eventTime
                                                            prefix:(NSString *)prefix;
{
    long e;
    unsigned long string;
    DataEvent theEvent;
    LLDataEventDef *eventDef;
    NSString *suffix, *dataString;
    NSMutableString *bufferString, *eventString;
    NSArray *eventStrings;
    NSRange stringRange;

    static BOOL multiStringWarned = NO;
    static BOOL warned = NO;

    // We allow names to have ":*" appended, so that we can use "_cmd" to get the event name in the event method.
    // Strip off any colon and subsequent text

    stringRange = [eventName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
    if (stringRange.length > 0) {
        eventName = [eventName substringToIndex:stringRange.location];
    }

    eventDef = [[task dataDoc] eventNamed:eventName];
    theEvent.data = eventData;
    theEvent.time = [eventTime unsignedLongValue];
    theEvent.trialTime = (trialStartTime == -1) ? -1 : theEvent.time - trialStartTime;

    // trialStart is always used as the boundary between trials. We write all the buffered values out, and then clear
    // buffers to start the next trial.

    if ([eventDef code] == trialStartEventCode) {
        [self writeBundledData];                                // write out buffered data
        for (e = 0; e < numEvents; e++) {
            trialEventCounts[e] = 0;
        }
        trialNum++;
        trialStartTime = [eventTime unsignedLongValue];
        eventString = [self convertToMatlabString:
                       [NSString stringWithFormat:@"trials(%ld).trialStartTime = %ld;", trialNum, trialStartTime]];
        [engine evalString:eventString];
    }
    
    // Some plugin components need "trial" events before the start of the first trial, when trialNum == 0.  That
    // annoys Matlab, which used 1-based indexing.  If trialNum == 0 and this is a trial event (other than the
    // trial start event), stop handling it.
    
    else if ([prefix hasPrefix:@"trials("] && trialNum == 0) {
        return;
    }

    //  If this is a bundled event, bundle it.  -eventDataElementsAsString returns a space-separated list of
    //  formatted data values.  We append these to the appropriate string.  Later, at the next trialStart
    //  event, we will use this string to create a Matlab command to make an array, using -writeBundledDataToMatlab.

    else if ((bufferString = [bundledEvents objectForKey:eventDef.name]) != nil) {  //
        if (trialNum > 0) {										// no bundled events before first trial
            if ((dataString = [eventDef eventDataElementsAsString:&theEvent]) != nil) {
                [bufferString appendString:dataString];
            }
            else if (!warned) {
                [LLSystemUtil runAlertPanelWithMessageText:[self className] informativeText:
                    [NSString stringWithFormat:
                     @"processEventNamed: Can't bundle data of type\"%@\", doing nothing.", eventDef.name]];
                warned = YES;
            }
        }
    }

    // If it is not a special case, handle it in the standard way, which will differ depending on whether
    // there is more than one instance of this event per trial. We have no way to handle multiple string events
    // in one trial, so those are rejected.

    else {
        if ((trialEventCounts[eventDef.code] == 0) || ![eventDef isStringData]) {
            suffix = (trialEventCounts[eventDef.code] == 0) ? nil : [NSString stringWithFormat:@"(%ld)",
                                                                     trialEventCounts[eventDef.code] + 1];
            eventStrings = [eventDef eventDataAsStrings:&theEvent prefix:nil suffix:suffix];
            eventString = [NSMutableString stringWithString:@""];
            for (string = 0; string < [eventStrings count]; string++) {
                [eventString appendString:[self convertToMatlabString:
                               [NSString stringWithFormat:@"%@%@;%@", prefix, [eventStrings objectAtIndex:string],
                               (string < [eventStrings count] - 1) ? @"\n" : @""]]];
            }
            [engine evalString:eventString];
        }
        else if (!multiStringWarned) {
            [LLSystemUtil runAlertPanelWithMessageText:[self className] informativeText: [NSString stringWithFormat:
                    @"processEventNamed: Can't handle multiple string events (\"%@\") within a trial", eventDef.name]];
            multiStringWarned = YES;
        }
    }
    trialEventCounts[eventDef.code]++;
}

- (void)processFileEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
{
    [self processEventNamed:eventName eventData:data eventTime:time prefix:@"file."];
}

- (void)processTrialEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
{
    [self processEventNamed:eventName eventData:data eventTime:time
                     prefix:[NSString stringWithFormat:@"trials(%ld).", trialNum]];
}

- (void)saveMatlabWorkspace;
{
    NSDate *today;
    NSDateFormatter *dateFormatter;
    NSString *path;

    today = [[NSDate alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    path = [NSString stringWithFormat:@"%@%ld/%@.mat", kMatlabDataPath, subjectNumber,
            [dateFormatter stringFromDate:today]];
    [engine evalString:[NSString stringWithFormat:@"save '%@'", path]];
    [[task defaults] setObject:[NSNumber numberWithLong:trialNum] forKey:kOPMatlabTrialNumKey];
    [today release];
    [dateFormatter release];
}

/*
 Some types of data (e.g. samples) are not written as individual Matlab commands, but are instead
 collected throughout a trial and then bundled into a single Matlab command that creates an array.
 The types that fall in this category are determined by the lists *bundledEventPrefixes[] and
 *bundledEventStops[] in -processEvent.  -writeBundledDataToMatlab does the bundling, using
 strings of comma-separate values (one for each event type) that was composed during the pass through the trial.
 */

- (void)writeBundledData;
{
    long v, values;
    LLDataEventDef *def;
    NSEnumerator *enumerator;
    NSString *key, *prefix;
    NSArray *valueStrings;
    NSMutableString *bundleString, *matlabString;


    prefix = [NSString stringWithFormat:@"trials(%ld).", trialNum];
    enumerator = [bundledEvents keyEnumerator];
    while ((key = [enumerator nextObject])) {
        bundleString = [bundledEvents objectForKey:key];
        if ([bundleString length] != 0) {
            valueStrings = [bundleString componentsSeparatedByString:@","];
            values = [valueStrings count] - 1;				// extra "," leaves blank string at end
            def = [[task dataDoc] eventNamed:key];			// get event definition
            matlabString = [NSMutableString stringWithFormat:@"%@%@ = [", prefix, [def name]];
            for (v = 0; v < values; v++) {
                [matlabString appendString:[NSString stringWithFormat:@"%@ ", [valueStrings objectAtIndex:v]]];
                if (((v % 2000) == 0) && (v > 0)) {			// command too long for poor old Matlab
                    [matlabString appendString:[NSString stringWithFormat:@"];\n%@%@ = [%@%@ ",
                                                prefix, [def name], prefix, [def name]]];
                }
                if (((v % 25) == 0) && (v > 0)) {			// line too long for poor old Matlab
                    [matlabString appendString:[NSString stringWithFormat:@" ...\n"]];
                }
            }
            [matlabString appendString:@"];\n"];				// terminate Matlab command
            [engine evalString:matlabString];
            [bundleString setString:@""];
            [bundledEvents setObject:bundleString forKey:key];           // clear for the next trial;
        }
    }
}

//===============================================================================================================
//
// The following are methods supporting LLDataEvents.  They are called by virtue of making the OPMatlabController
// an event observer when we activate (addObserver:self).
//
//===============================================================================================================
// File events.  These are typically declared once, at the start of running, or at a reset
//




//===============================================================================================================
// Trial events.  These are typically declared every trial, at the start of running, or at a reset
//

@end
