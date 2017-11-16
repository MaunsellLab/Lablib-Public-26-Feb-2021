//
//  LLDataFileReader.h
//  Lablib
//
//  Created by John Maunsell on Sun Jul 04 2004.
//  Copyright (c) 2017. All rights reserved.
//

#import "LLDataDoc.h"
#import "LLDataEventDef.h"

#define kADChannels            8

@interface LLDataFileReader : NSObject <LLDataReader> {

    BOOL                allocated;
    NSMutableDictionary *bundledEvents;
    unsigned long        *cumulativeEnabledEvents;        // cumulative count of enabled events by trial
    unsigned long        currentEventIndex;
    BOOL                dataDefinitions;
    long                dataIndex;
    float                dataFormat;
    BOOL                *enabledEvents;
    unsigned long        *eventCounts;                    // total count of each type of event
    NSMutableArray        *cumulativeEvents;                // count of each type of event for each trial
    NSMutableArray        *eventDesc;
    NSMutableArray        *eventsByCode;
    NSMutableDictionary    *eventsDict;
    NSString            *fileCreateDate;
    NSString            *fileCreateTime;
    NSData                *fileData;
    NSDate              *fileDate;
//    NSCalendarDate        *fileDate;
    NSString            *fileName;
    long                fileStartTime;
    long                firstDataEventIndex;
    long                lastIndex;
    long                lastLineRead;
    long                lastSampleTime[kADChannels];
    unsigned long        lineCounter;
    unsigned long        maxEventCount;
    unsigned long        maxEventDataBytes;
    unsigned long        maxEventNameLength;
    unsigned long        maxTrials;
    long                nextIndex;
    long                numEvents;
    long                sampleIntervalMS;
    long                spikeStartTime;
    DataEvent            theEvent;
    BOOL                *timedEvents;
    unsigned long        trialCount;
    NSMutableArray        *trialStartIndices;
    long                trialStartTime;
}

- (void)appendMatlabString:(NSString *)eventString toData:(NSMutableData *)data;
- (NSString *)arrayAsMatlabString:(NSArray *)array lValueString:(NSString *)lValueString;
- (long)bytesInDataEvent:(DataEvent *)pEvent;
- (void)countEvents;
- (BOOL)dataBytes:(Ptr)buffer length:(long)numBytes;
- (BOOL)dataBytes:(Ptr)buffer range:(NSRange)range;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL dataDefinitions;
- (void)dataDeviceMixError;
- (LLDataEventDef *)dataEventDefWithIndex:(long)index;
@property (NS_NONATOMIC_IOSONLY, readonly) float dataFormat;
@property (NS_NONATOMIC_IOSONLY) unsigned long dataIndex;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *dataString;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long enabledEventsInFile;
- (unsigned long)eventCodeForEventName:(NSString *)name;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long *eventCounts;
- (NSArray *)eventDataAsStrings:(DataEvent *)pEvent prefix:(NSString *)prefix
                    suffix:(NSString *)suffix;
- (NSString *)eventTimeAsString:(DataEvent *)pEvent prefix:(NSString *)prefix
            suffix:(NSString *)suffix;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *eventsAsMatlabStrings; 
@property (NS_NONATOMIC_IOSONLY, readonly) long fileBytes;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *fileCreateDate;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *fileCreateTime;
- (NSData *)fileData;
//- (NSCalendarDate *)fileDate;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDate *fileDate;
- (DataEvent *)findEventByIndex:(unsigned long)index line:(long *)pLine NS_RETURNS_INNER_POINTER;
- (DataEvent *)findEventByLine:(unsigned long)line index:(long *)pIndex NS_RETURNS_INNER_POINTER;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long firstDataEventIndex;
- (instancetype)initWithData:(NSData *)data;
@property (NS_NONATOMIC_IOSONLY, readonly) long length;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long maxEventCount;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long maxEventDataBytes;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long maxEventNameLength;
@property (NS_NONATOMIC_IOSONLY, readonly) long numEvents;                                // return the number of event definitions
@property (NS_NONATOMIC_IOSONLY, readonly) DataEvent *readEvent;
@property (NS_NONATOMIC_IOSONLY, readonly) unsigned long readEventCode;                
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError;
- (void)rewind;
- (void)setEnabledEvents:(BOOL *)enabledArray;
- (BOOL)setFileData:(NSData *)data;
- (void)writeBuffersToMatlab:(NSMutableData *)data prefix:(NSString *)prefix;

@end
