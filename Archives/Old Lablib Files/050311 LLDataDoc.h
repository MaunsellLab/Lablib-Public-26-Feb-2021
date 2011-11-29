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
    unsigned long	time;
} DataEvent;
    
typedef struct {	
	NSString *name;								// string with name of event
	long dataBytes;								// Number of data bytes
} EventDef;

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
@protected
	NSMutableData 		*data;					// pointer to NSData (actual event buffer)
	NSFileHandle 		*dataFileHandle;		// handle for writing data to a file
    NSMutableDictionary	*eventDict;				// Dictionary for event info indexed by name (putEvent)
    NSLock				*eventLock;
    NSMutableArray		*eventsByCode;			// Array for event info indexed by event code (getEvent)
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
- (void)dispatchEvents;
- (void)eventToBuffer:(unsigned long)code dataPtr:(void *)pData bytes:(unsigned long)lengthBytes
					writeLength:(BOOL)writeLength;
- (NSString *)fileName; 
- (NSString *)filePath;
- (NSArray *)findViews:(NSView *)view respondingToSelector:(SEL)selector;
- (void)getEventBytes:(void *)pData length:(unsigned long)numBytes;
- (BOOL)getEventDesc:(NSString *)eventKey pDescription:(EventDesc *)pDesc;
- (void)putEvent:(NSString *)eventKey;
- (void)putEvent:(NSString *)eventKey withData:(void *)pDdata;
- (void)putEvent:(NSString *)eventKey withData:(char *)pData lengthBytes:(long)length;
- (void)removeObserver:(id)anObserver;
- (void)setUseDefaultDataDirectory:(BOOL)state;

@end
