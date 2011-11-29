//
//  LLEventBuffer.m
//  Lablib
//
//  Created by John Maunsell on Thu Apr 03 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLEventBuffer.h"

// Optional standard set of data events.

static EventDef standardEvents[] = {
	{@"fileEnd",		0},
	{@"trialStart", 	sizeof(short)},
	{@"trialEnd", 		sizeof(short)},
	{@"spikeZero", 		0},
	{@"sampleZero", 	0},
//???	{@"spike", 			sizeof(SPIKEDATA)},
	{@"spike0", 		sizeof(long)},
//???	{@"sample", 		sizeof(SAMPLEDATA)},
	{@"sample01", 		2 * sizeof(short)},
	{@"stimulusOn", 	sizeof(short)},
	{@"stimulusOff",	sizeof(short)},
//???	{@"fixWindow", 		sizeof(FIXWINDOWDATA)},
	{@"fixOn", 			0},
	{@"fixOff", 		0},
	{@"fixate", 		0},
	{@"leverDown", 		0},
	{@"blocked", 		0},
	{@"videoInterrupt", sizeof(long)},
	{@"text", 			-1}
};

@implementation LLEventBuffer

- (void) addObserver:(id)anObserver
{
    if ([observerArray indexOfObject:anObserver] == NSNotFound) {
        [observerLock lock];
        [observerArray addObject:anObserver];
        [observerLock unlock];
    }
}

/*
Add event definitions.  All definitions are stored in an NSDictionary.  The NSString that
is the name of the event serves as its key.  The only two values that need to be recorded
are its code (event codes are integers that increase from 0), and the number of data bytes
(a value of -1 specifies an event with varying numbers of data bytes from instance to instance.
For efficiency, we save the event code and data byte size in an NSRange object.
*/

- (BOOL) defineEvents:(EventDef *)eventDefs number:(long)numEvents
{
    short index;
    NSValue *theValue;
    EventDesc desc;
   
    [eventLock lock];
    for (index = 0; index < numEvents; index++) {
        desc.code = [eventDict count];
        desc.dataBytes = eventDefs[index].dataBytes;
        theValue = [NSValue valueWithBytes:&desc objCType:@encode(EventDesc)];
        [eventNames addObject:eventDefs[index].name];
        [eventDict setObject:theValue  forKey:eventDefs[index].name];
    }
    [eventLock unlock];
    return(TRUE);
}

- (void) defineStandardEvents
{
   [self defineEvents:standardEvents number:sizeof(standardEvents) / sizeof(EventDef)];
}

- (void) dispatchEvents
{
    unsigned long eventCode, numBytes, numEvents;
    unsigned short shortCode;
    unsigned char charCode;
    DataEvent theEvent;
    EventDesc desc;
    char *pData;
	NSAutoreleasePool *threadPool;

// Initialize and get the start time for this schedule

    threadPool = [[NSAutoreleasePool alloc] init];
    
    for (; buffer.sizeBytes > 0; ) {
  
        if (buffer.pc > 0) {										// Event in buffer?

// If there is an event in the buffer, read it out
 
            [eventLock lock];
            numEvents = [eventDict count];							// Get event code
            if (numEvents < 0x100) {
                [self getEventBytes:(char *)&charCode length:sizeof(charCode)];
                eventCode = charCode;
            }
            else  if (numEvents < 0x10000) {
                [self getEventBytes:(char *)&shortCode length:sizeof(shortCode)];
                eventCode = shortCode;
            }
            else {
                [self getEventBytes:(char *)&eventCode length:sizeof(eventCode)];
            }
            theEvent.name = [eventNames objectAtIndex:eventCode];	// Get event name
            [self getEventDesc:theEvent.name pDescription:&desc];	// Get event description (number of data bytes)
            if (desc.dataBytes == 0) {
               theEvent.data = Nil;
            }
            else {
                if (desc.dataBytes > 0) {
                    numBytes = desc.dataBytes;						// Fixed length data, get length
                }
                else {												// Variable length data, get length
                    [self getEventBytes:(char *)&numBytes length:sizeof(unsigned long)];
                }
                pData = malloc(numBytes);							// Allocate memory for data
                [self getEventBytes:pData length:numBytes];			// Read the data
                theEvent.data = [[NSData alloc] initWithBytesNoCopy:pData length:numBytes];
            }
            [self getEventBytes:(char *)&theEvent.time length:sizeof(unsigned long)];
            [eventLock unlock];
            
// Dispatch the event to every one that accepts it

        }
        else {														// No events left, sleep
			[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        }
     }
    
    [threadPool release];
}

// Write one data event into the event buffer

- (void) eventToBuffer:(unsigned long)code dataPtr:(char *)pData bytes:(long)lengthBytes
{
    unsigned long eventTimeMS;
    Nanoseconds nanosec;
    unsigned char charCode;
    unsigned short shortCode;
    unsigned long numEvents;
    
	nanosec = AbsoluteToNanoseconds(UpTime());
    eventTimeMS = (nanosec.hi * 4294967296.0  + nanosec.lo) / 1000000.0;
	numEvents = [eventDict count];
    
	[eventLock lock];
    if (numEvents < 0x100) {					// Bytes for the event code
        charCode = code;
        [self ringBufferWrite:(char *)&charCode bytes:sizeof(charCode)];
    }
    else if (numEvents < 0x10000) {
        shortCode = code;
        [self ringBufferWrite:(char *)&shortCode bytes:sizeof(shortCode)];
    }
    else {
        [self ringBufferWrite:(char *)&code bytes:sizeof(code)];
    }
    if (lengthBytes > 0) {
        [self ringBufferWrite:pData bytes:lengthBytes];				// Bytes of data
    }
	[self ringBufferWrite:(char *)&eventTimeMS bytes:sizeof(unsigned long)];	// Bytes for event time
	[eventLock unlock];
}

- (BOOL) getEventBytes:(char *)pData length:(long)numBytes
{
    unsigned long readIndex, index;
    char *ptr;
    
    // ???? Get a lock here.
    readIndex = buffer.next - buffer.pc;				// Get pointer to data
    if (readIndex < 0) {								// Correct for underflow
        readIndex += buffer.sizeBytes;
    }
    buffer.pc -= numBytes;								// Advance process counter
    ptr = &buffer.data[readIndex];						// Pointer for data
	if (readIndex + numBytes >= buffer.sizeBytes) {		// if we are going to overflow buffer end
        for (index = 0; index < (buffer.sizeBytes - readIndex); index++) {
			*pData++ = *ptr++;							// 	go up to the buffer end
		}
		numBytes -= buffer.sizeBytes - readIndex;	//  adjust count left to write
		ptr = buffer.data;
	}
	for (index = 0; index < numBytes; index++) {		// do (or finish) read
		*pData++ = *ptr++;
	}
    return(TRUE);
}

// Get the structure describing an event with a given event name (eventKey)

- (BOOL) getEventDesc:(NSString *)eventKey pDescription:(EventDesc *)pDesc
{
    NSValue *eventValue;
    
    eventValue = [eventDict objectForKey:eventKey];
    if (eventValue == Nil) {
        NSRunAlertPanel(@"LLEventBuffer", @"putEvent: Event \"%@\" has not been defined.",
            @"OK", nil, nil, eventKey);
        return(FALSE);
    }
    [eventValue getValue:pDesc];
    return(TRUE);
}

- (id) initWithBufferSize:(long)bufferSizeBytes
{
    if ((self = [super init])) {
        buffer.data = malloc(bufferSizeBytes);
        if (buffer.data == NULL) {
            NSRunAlertPanel(@"LLEventBuffer", @"initWithBufferSize: Failed to allocate memory.",
                @"OK", nil, nil);
            [super dealloc];
            return(Nil);
        }
        else {
            buffer.sizeBytes = bufferSizeBytes;
            eventDict = [[NSMutableDictionary alloc] init];
            eventNames = [[NSMutableArray alloc] init];
            eventLock = [[NSLock alloc] init];
            observerLock = [[NSLock alloc] init];
            observerArray = [[NSMutableArray alloc] init];
            [NSThread detachNewThreadSelector:@selector(dispatchEvents) toTarget:self withObject:Nil];
            return self;  
        }
    }
    return self;
}

- (void) putEvent:(NSString *)eventKey
{
    EventDesc desc;
    
// Extract the event from the event dictionary

    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes != 0) {
        NSRunAlertPanel(@"LLEventBuffer", @"putEvent: Event \"%@\" is defined to have data.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)NULL bytes:0];
}

- (void) putEvent:(NSString *)eventKey withData:(char *)pData
{
    EventDesc desc;
    
// Extract the event from the event dictionary

    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes <= 0) {
        NSRunAlertPanel(@"LLEventBuffer", @"putEvent: Event \"%@\" is not defined to have data of fixed length.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)pData bytes:desc.dataBytes];
}

- (void) putEvent:(NSString *)eventKey withData:(char *)pData lengthBytes:(long)length
{
    EventDesc desc;
    
    if (![self getEventDesc:eventKey pDescription:&desc]) {
        return;
    }
    if (desc.dataBytes > 0) {
        NSRunAlertPanel(@"LLEventBuffer", @"putEvent: Event \"%@\" is not defined to have data of variable length.",
            @"OK", nil, nil, eventKey);
        return;
    }
    [self eventToBuffer:desc.code dataPtr:(char *)pData bytes:length];
}

- (void) removeObserver:(id)anObserver
{
    [observerLock lock];
    [observerArray removeObject:anObserver];
    [observerLock unlock];
}

- (void) ringBufferWrite:(char *)pData bytes:(long)bytesToWrite
{
	long index, firstCount;
	char *pWrite;
    // ??? put in something to prevent ring-buffer over-writing.  Buffer increment?    
	
	pWrite = buffer.data + buffer.next;						// pointer to next spot to write
	if (buffer.next + bytesToWrite >= buffer.sizeBytes) {	// if we are going to overflow buffer end
		firstCount = buffer.sizeBytes - buffer.next;
		for (index = 0; index < firstCount; index++) {
			*pWrite++ = *pData++;							// 	go up to the buffer end
		}
		bytesToWrite -= firstCount;							//  adjust count left to write
		buffer.pc += firstCount;
		buffer.next = 0;									//  continue at start of buffer
		pWrite = buffer.data;
	}
	for (index = 0; index < bytesToWrite; index++) {
		*pWrite++ = *pData++;
	}
	buffer.next += bytesToWrite;
	buffer.pc += bytesToWrite;	
}

@end
