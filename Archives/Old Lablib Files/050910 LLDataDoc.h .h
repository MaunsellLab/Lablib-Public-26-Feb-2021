//
//  LLDataDoc.h
//  Lablib
//
//  Created by John Maunsell on Fri Apr 11 2003.
//  Copyright (c) 2003. All rights reserved.
//

typedef struct {
    NSString		*name;
    NSData			*data;
    unsigned long	time;						// time (of day) the event was posted
	unsigned long	trialTime;					// time of the event since trialStart
	unsigned long	code;						// code for this type of event in data file
	unsigned long	fileIndex;					// byte offset in file
} DataEvent;

typedef struct LLDataDef {
	NSString		*typeName;					// name of the type of data (long, short...)
	NSString		*dataName;					// name of the data entry
	unsigned long	elements;					// number of elements (for arrays)
	struct LLDataDef *contents;					// additional contents (for structs)
	unsigned long	offsetBytes;				// bytes from the start of data
	unsigned long	elementBytes;				// number of bytes in an element
	unsigned long	tags;						// number of tags (in a structure only)
} LLDataDef;
    
// Old event definition that includes only the name and dataBytes.

typedef struct {	
	NSString *name;								// string with name of event
	long dataBytes;								// Number of data bytes
} EventDef;

// New event definition, which includes the type(s) and name(s) of the data.
// An element is all the data for non-arrays, or the size of one entry in an
// array

typedef struct {	
	NSString *name;								// string with name of event
	long elementBytes;							// bytes in each element of data
	LLDataDef definition;
} EventDefinition;

// Event descriptor, used internally to describe events

typedef struct {	
	long code;									// string with name of event
    NSString *name;								// string with name of event
	long dataBytes;								// Number of data bytes
} EventDesc;

#define kLLAutoreleaseIntervalS		10
#define	kLLInitialBufferSize		1000000
#define	LLDataFileCreator			'LLdi'
#define	LLDataFileType				'DAT6'
#define LLDataFormatString			"\007\005006.0\000"

@interface LLDataDoc : NSDocument {
	NSMutableData 		*data;					// pointer to NSData (actual event buffer)
	BOOL				dataDefinitions;
	NSFileHandle 		*dataFileHandle;		// handle for writing data to a file
    NSMutableDictionary	*eventDict;				// Dictionary for event info indexed by name (putEvent)
    NSLock				*eventLock;
    NSMutableArray		*eventsByCode;			// Array for event info indexed by event code (getEvent)
	BOOL				eventsHaveDataDefs;		// indicated whether event definitions have data defintions
	NSString			*filePath;
	unsigned long 		lastRead;				// offset to next byte to write
    NSMutableArray		*observerArray;
    NSLock				*observerLock;
	AbsoluteTime		startTime;
	BOOL				useDefaultDir;
}

- (void)addObserver:(id)anObserver;
- (BOOL)clearEventDefinitions;
- (void)clearEvents;
- (void)closeDataFile;
- (BOOL)createDataFile;
- (NSData *)dataFileHeaderData;
- (BOOL)defineEvents:(EventDef *)eventDefs number:(unsigned long)count;
- (BOOL)defineEvents:(EventDefinition *)eventDefs count:(unsigned long)numEvents;
- (void)dispatchEvents;
- (void)eventToBuffer:(unsigned long)code dataPtr:(void *)pData bytes:(unsigned long)lengthBytes
					writeLength:(BOOL)writeLength;
- (NSString *)fileName; 
- (NSString *)filePath;
- (NSArray *)findViews:(NSView *)view respondingToSelector:(SEL)selector;
- (void)getEventBytes:(void *)pData length:(unsigned long)numBytes;
- (void)putEvent:(NSString *)eventKey;
- (void)putEvent:(NSString *)eventKey withData:(void *)pDdata;
- (void)putEvent:(NSString *)eventKey withData:(char *)pData lengthBytes:(long)length;
- (void)putEvent:(NSString *)eventKey withData:(char *)pData count:(long)count;
- (void)removeObserver:(id)anObserver;
- (void)setUseDefaultDataDirectory:(BOOL)state;

@end
