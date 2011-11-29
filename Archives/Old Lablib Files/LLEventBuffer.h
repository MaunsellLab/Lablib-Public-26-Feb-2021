//
//  LLEventBuffer.h
//  Lablib
//
//  Created by John Maunsell on Thu Apr 03 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSString		*name;
    NSData			*data;
    unsigned long	time;
} DataEvent;
    
typedef struct {
	long sizeBytes;								// size of buffer in bytes
	long next;									// offset to next byte to write
	long pc;									// process counter
	char *data;									// pointer to data area
} EventBuffer;

typedef struct {	
	NSString *name;								// string with name of event
	long dataBytes;								// Number of data bytes
} EventDef;

typedef struct {	
	long code;									// string with name of event
	long dataBytes;								// Number of data bytes
} EventDesc;

@interface LLEventBuffer : NSObject {
@private
	EventBuffer 		buffer;
    NSMutableDictionary	*eventDict;
    NSLock				*eventLock;
    NSMutableArray		*eventNames;
    NSMutableArray		*observerArray;
    NSLock				*observerLock;
}

- (void) addObserver:(id)anObserver;
- (BOOL) defineEvents:(EventDef *)eventDefs number:(long)count;
- (void) defineStandardEvents;
- (void) dispatchEvents;
- (void) eventToBuffer:(unsigned long)code dataPtr:(char *)pData bytes:(long)lengthBytes;
- (BOOL) getEventBytes:(char *)pData length:(long)numBytes;
- (BOOL) getEventDesc:(NSString *)eventKey pDescription:(EventDesc *)pDesc;
- (id) initWithBufferSize:(long)bufferSizeBytes;
- (void) putEvent:(NSString *)eventKey;
- (void) putEvent:(NSString *)eventKey withData:(char *)pDdata;
- (void) removeObserver:(id)anObserver;
- (void) ringBufferWrite:(char *)pData bytes:(long)bytesToWrite;

@end
