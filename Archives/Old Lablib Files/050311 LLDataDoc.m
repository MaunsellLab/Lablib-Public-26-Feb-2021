//
//  LLDataDoc.m
//  Lablib
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLDataDoc.h"
#import "LLStandardFileNames.h"

@implementation LLDataDoc

- (void) addObserver:(id)anObserver {

    if ([observerArray indexOfObject:anObserver] == NSNotFound) {
        [observerLock lock];
        [observerArray addObject:anObserver];
        [observerLock unlock];
    }
}

- (BOOL)createDataFile {

	NSDictionary *attr;
	NSString *dirPath, *fileName;
	NSFileManager *manager;
	NSSavePanel *savePanel;
	
	manager = [NSFileManager defaultManager];
	
// First find or create the default data dir

	if (useDefaultDir) {
		if ((dirPath = [LLStandardFileNames defaultDirPath]) == Nil) {
			useDefaultDir = NO;
		}
		fileName = [LLStandardFileNames defaultFileName];
	}
	else {
		dirPath = Nil;
		fileName = [[NSUserDefaults standardUserDefaults] stringForKey:LLLastFileNameKey];
	}
	
// Run the save panel to get the user's input

	savePanel = [NSSavePanel savePanel];
	[savePanel setTitle:@"Save Data"];
	[savePanel setRequiredFileType:[LLStandardFileNames defaultFileExtension]];
	if ([savePanel runModalForDirectory:dirPath file:fileName] != NSOKButton) {
		return NO;
	}
	
// Create the file

	filePath = [savePanel filename];
	[filePath retain]; 
	if ([manager fileExistsAtPath:filePath]) {
		[manager removeFileAtPath:filePath handler:Nil];
	}
	attr = [NSDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithUnsignedLong:LLDataFileCreator], NSFileHFSCreatorCode, 
				[NSNumber numberWithUnsignedLong:LLDataFileType], NSFileHFSTypeCode, nil];
	if (![[NSFileManager defaultManager] createFileAtPath:filePath
								contents:Nil attributes:attr]) {
		NSRunAlertPanel(@"LLDataDoc",  @"Unable to create file %@", @"OK", nil, nil, filePath);
		return NO;
	}
	[[NSUserDefaults standardUserDefaults] setObject:[[filePath pathComponents] lastObject] 
						forKey:LLLastFileNameKey];

	dataFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
	[dataFileHandle retain];
	[dataFileHandle writeData:[self dataFileHeaderData]];
	
	[self clearEvents];						// flush all the events in the buffer

	return YES;
}

// Clear all known event definitions

- (BOOL)clearEventDefinitions;
{
	if (dataFileHandle != nil) {
		return NO;
	}
    [eventLock lock];
	[eventDict removeAllObjects];
	[eventsByCode removeAllObjects];
	[data setLength:0];
	lastRead = [data length];
    [eventLock unlock];
	return YES;
}

// Discard all the events in the buffer

- (void)clearEvents {

	[eventLock lock];
	[data setLength:0];
	lastRead = [data length];
	[eventLock unlock];
}

- (void)closeDataFile {

	[dataFileHandle closeFile];
	[dataFileHandle release];
	[filePath release];
	filePath = nil;
	dataFileHandle = nil;
}

// Write the header that goes into every data file

- (NSData *)dataFileHeaderData {

	unsigned char stringLength;
	long index, events;
    EventDesc desc;
	NSString *dateString;
	NSMutableData *headerData;
	NSCalendarDate *today;
	
	headerData = [[[NSMutableData alloc] init] autorelease];
	[headerData appendBytes:LLDataFormatString length:strlen(LLDataFormatString)];	// format specifier 
	events = [eventsByCode count];
	[headerData appendBytes:&events length:sizeof(events)];						// number of events defined

// Write the event descriptions.  Each description consists of its name in pascal string format, and
// the number of data bytes as a long int.
 
	for (index = 0; index < events; index++)	{
		[[eventsByCode objectAtIndex:index] getValue:&desc];
		stringLength = [desc.name cStringLength];
		[headerData appendBytes:&stringLength length:sizeof(stringLength)];		// bytes in char name
		[headerData appendBytes:[desc.name cString] length:stringLength];		// name bytes
		[headerData appendBytes:&desc.dataBytes length:sizeof(desc.dataBytes)];	// data bytes
	}

// Write the date and time as strings
	
	today = [NSCalendarDate calendarDate];
	dateString = [today descriptionWithCalendarFormat:@"%B %d, %Y"];
	stringLength = [dateString cStringLength];
	[headerData appendBytes:&stringLength length:sizeof(stringLength)];			// number of bytes in char name
	[headerData appendBytes:[dateString cString] length:stringLength];			// name bytes

	dateString = [today descriptionWithCalendarFormat:@"%H:%M:%S"];
	stringLength = [dateString cStringLength];
	[headerData appendBytes:&stringLength length:sizeof(stringLength)];			// number of bytes in char name
	[headerData appendBytes:[dateString cString] length:stringLength];			// name bytes
	
	return headerData;
}

- (void) dealloc {

	[data release];
    [eventDict release];
    [eventsByCode release];
    [eventLock release];
    [observerLock release];
    [observerArray release];
    [super dealloc];
}

/*
Add event definitions.  Definitions are stored in an NSDictionary.  The NSString that
is the name of the event serves as its key.  The only two values that need to be recorded
are its code (event codes are integers that increase from 0), and the number of data bytes
(a value of -1 specifies an event with varying numbers of data bytes from instance to instance.
*/

- (BOOL) defineEvents:(EventDef *)eventDefs number:(unsigned long)numEvents {

    short index;
    NSValue *theValue;
    EventDesc desc;
   
    [eventLock lock];
    for (index = 0; index < numEvents; index++) {
		if ([eventDict objectForKey:eventDefs[index].name] != nil) {
			NSRunAlertPanel(@"LLDataDoc",  @"Attempt to define event \"%@\" more than once (ignored).", 
					@"OK", nil, nil, eventDefs[index].name);
		}
		else {
			desc.code = [eventsByCode count];
			desc.name = eventDefs[index].name;
			desc.dataBytes = eventDefs[index].dataBytes;
			theValue = [NSValue valueWithBytes:&desc objCType:@encode(EventDesc)];
			[eventsByCode addObject:theValue];
			[eventDict setObject:theValue forKey:eventDefs[index].name];
		}
    }
    [eventLock unlock];
    return YES;
}

// Write one data event into the event buffer

- (void) eventToBuffer:(unsigned long)code dataPtr:(void *)pData bytes:(unsigned long)lengthBytes
					writeLength:(BOOL)writeLength {

    unsigned long eventTimeMS;
    unsigned char charCode;
    unsigned short shortCode;
    unsigned long numEvents;
	NSMutableData *eventData;
	
	eventData = [[NSMutableData alloc] init];
	eventTimeMS = UnsignedWideToUInt64(AbsoluteDeltaToNanoseconds(UpTime(), startTime)) / 1000000.0; 

// Start the event with the code for the event.  The number of bytes used depends
// on the number of events defined.

	numEvents = [eventDict count];
    if (numEvents < 0x100) {					// Bytes for the event code
        charCode = code;
        [eventData appendBytes:(void *)&charCode length:sizeof(charCode)];
    }
    else if (numEvents < 0x10000) {
        shortCode = code;
        [eventData appendBytes:(void *)&shortCode length:sizeof(shortCode)];
    }
    else {
        [eventData appendBytes:(void *)&code length:sizeof(code)];
    }

// On variable length events, the length of the data must be inserted.
// NB: The length might be zero, so we must write the length in all cases

	if (writeLength) {
		[eventData appendBytes:&lengthBytes length:sizeof(unsigned long)];
	}
	
// If there are data, write the data.  

    if (lengthBytes > 0) {
        [eventData appendBytes:pData length:lengthBytes];
    }
	[eventData appendBytes:(void *)&eventTimeMS length:sizeof(unsigned long)];

// Insert the data into the buffer

	[eventLock lock];
	[data appendData:eventData];
	[eventLock unlock];

	if (dataFileHandle != nil) {
		[dataFileHandle writeData:eventData];
	}
	[eventData release];
}

- (void) dispatchEvents {

    unsigned char charCode;
    unsigned short shortCode;
    unsigned long eventCode, numBytes, numEvents, obs, eTime;
    NSData *eventData;
    NSNumber *eventTime;
    EventDesc desc;
    id anObserver;
	NSAutoreleasePool *threadPool;
	NSDate *nextRelease;
    SEL methodSelector;

// Initialize and get the start time for this schedule

    threadPool = [[NSAutoreleasePool alloc] init];
	nextRelease = [NSDate dateWithTimeIntervalSinceNow:kLLAutoreleaseIntervalS];
    
    for (; data != nil; ) {
          if (lastRead < [data length]) {				// Undispatched event?
            [eventLock lock];

// Get the event code from the buffer

            numEvents = [eventDict count];							// Get event code
            if (numEvents < 0x100) {
                [self getEventBytes:(void *)&charCode length:sizeof(charCode)];
                eventCode = charCode;
            }
            else  if (numEvents < 0x10000) {
                [self getEventBytes:(void *)&shortCode length:sizeof(shortCode)];
                eventCode = shortCode;
            }
            else {
                [self getEventBytes:(void *)&eventCode length:sizeof(eventCode)];
            }

// Use the code to get the description of the event (name, number of bytes)

            [[eventsByCode objectAtIndex:eventCode] getValue:&desc];

// Get the event data from the buffer, if this event has data

            if (desc.dataBytes == 0) {
               eventData = Nil;
            }
            else {
                if (desc.dataBytes > 0) {
                    numBytes = desc.dataBytes;						// Fixed length data, get length
                }
                else {												// Variable length data, get length
                    [self getEventBytes:(void *)&numBytes length:sizeof(unsigned long)];
                }
                eventData = [data subdataWithRange:NSMakeRange(lastRead, numBytes)];
                [eventData retain];
                lastRead += numBytes;
            }

// Get the event time

            [self getEventBytes:&eTime length:sizeof(unsigned long)];
            eventTime = [NSNumber numberWithUnsignedLong:eTime];
            [eventTime retain];
            [eventLock unlock];
            
// Dispatch the event to all observers that accept it

            methodSelector = NSSelectorFromString([NSString stringWithFormat:@"%@:eventTime:", desc.name]);
            for (obs = 0; obs < [observerArray count]; obs++) {
                anObserver = [observerArray objectAtIndex:obs];
                if ([anObserver respondsToSelector:methodSelector]) {
                    [anObserver performSelector:methodSelector withObject:eventData withObject:eventTime];
                }
            }

// Clean up this event, then go look for more

            [eventTime release];
            if (eventData != Nil) {
                [eventData release];
            }
        }        
        else {														// No events left, sleep
			[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.025]];
			if ([nextRelease timeIntervalSinceNow] < 0.0) {
				[threadPool release];
				threadPool = [[NSAutoreleasePool alloc] init];
				nextRelease = [NSDate dateWithTimeIntervalSinceNow:kLLAutoreleaseIntervalS];
			}
        }
     }
    [threadPool release];
}

- (NSString *)fileName { 

	if (filePath == nil) {
		return nil;
	}
	else {
		return [[filePath pathComponents] lastObject];
	}
} 

- (NSString *)filePath {

	return filePath;
}

// Check all views in an NSView hiearchy for those that respond to a particular selector.
// This is used to find the NSViews in a window that are will accept data events (using
// @selector(acceptsDataEvents)).  This function calls itself recursively to go down
// all the branches of the view hierarchy.

- (NSArray *)findViews:(NSView *)view respondingToSelector:(SEL)selector {

    long v;
    NSArray *returnArray;
    NSMutableArray *responders = Nil;
    
    responders = [[NSMutableArray alloc] init];
    if ([view respondsToSelector:selector]) {
        [responders addObject:view];
    }
    if ([view subviews] != Nil) {
        for (v = 0; v < [[view subviews] count]; v++) {
        	returnArray = [self findViews:[[view subviews] objectAtIndex:v] respondingToSelector:selector];
            if (returnArray != Nil) {
                [responders addObjectsFromArray:returnArray];
            }
        }
    }
    returnArray = ([responders count] > 0) ? [NSArray arrayWithArray:responders] : Nil;
    [responders release];
    return returnArray;
}


// Read bytes from the event data buffer

- (void) getEventBytes:(void *)pData length:(unsigned long)numBytes {

    [data getBytes:pData range:NSMakeRange(lastRead, numBytes)];
    lastRead += numBytes;
}

// Get the structure describing an event with a given event name (eventKey)

- (BOOL) getEventDesc:(NSString *)eventKey pDescription:(EventDesc *)pDesc {

    NSValue *eventValue;
    
    eventValue = [eventDict objectForKey:eventKey];
    if (eventValue == nil) {
        NSLog(@"LLDataDoc getEventDesc: Event \"%@\" has not been defined.",
             eventKey);
        NSRunAlertPanel(@"LLDataDoc", @"getEventDesc: Event \"%@\" has not been defined.",
            @"OK", nil, nil, eventKey);
		return NO;
    }
    [eventValue getValue:pDesc];
    return YES;
}

- (id) init {

    if ((self = [super init])) {
        data = [[NSMutableData alloc] initWithCapacity:kLLInitialBufferSize];
        lastRead = [data length];
        eventDict = [[NSMutableDictionary alloc] init];
        eventsByCode = [[NSMutableArray alloc] init];
        eventLock = [[NSLock alloc] init];
        observerLock = [[NSLock alloc] init];
        observerArray = [[NSMutableArray alloc] init];
		useDefaultDir = YES;
		startTime = UpTime();
        [NSThread detachNewThreadSelector:@selector(dispatchEvents) toTarget:self withObject:Nil];
    }
    return self;
}

- (void) putEvent:(NSString *)eventKey {

    EventDesc desc;
    
// Extract the event from the event dictionary

    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes != 0) {
        NSRunAlertPanel(@"LLDataDoc", @"putEvent: Event \"%@\" is defined to have data.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)NULL bytes:0 writeLength:NO];
}

- (void) putEvent:(NSString *)eventKey withData:(void *)pData {

    EventDesc desc;
    
// Extract the event from the event dictionary

    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes <= 0) {
        NSRunAlertPanel(@"LLDataDoc", @"putEvent: Event \"%@\" is not defined to have data of fixed length.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)pData bytes:desc.dataBytes writeLength:NO];
}

- (void)putEvent:(NSString *)eventKey withData:(char *)pData lengthBytes:(long)length {

    EventDesc desc;
    
    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes > 0) {
        NSRunAlertPanel(@"LLDataDoc", 
			@"putEvent: Event \"%@\" is not defined to have data of variable length.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)pData bytes:length writeLength:YES];
}

- (void) removeObserver:(id)anObserver {

    [observerLock lock];
    [observerArray removeObject:anObserver];
    [observerLock unlock];
}

- (void)setUseDefaultDataDirectory:(BOOL)state {

	useDefaultDir = state;
}

@end