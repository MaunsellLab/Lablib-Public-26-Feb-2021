//
//  LLDataEventDef.h
//  Lablib
//
//  Created by John Maunsell on 3/11/05.
//  Copyright 2005. All rights reserved.
//

#import <Lablib/LLDataEvents.h>
#import <Lablib/LLDataReader.h>

@interface LLDataEventDef : NSObject {

    unsigned long    arrayOffsetBytes;    // Offset indeterminate array after its header
    long            code;                // Code unique to this instance of a data event
    long            dataBytes;            // Number of data bytes stored (== elementBytes for non-arrays)
    NSMutableArray    *dataDefs;            // Definitions for the data stored
    long            defIndex;            // Index for the next definition to read
    long            elementBytes;        // Number of bytes in each element (for arrays)
    BOOL            isStringData;        // Flag for a data definition that is a string
    NSString        *name;                // Name of this data event
    unsigned long    nestLevel;            // Nest level (used during parsing)
    unsigned long    offsetBytes;        // Offset bytes within structs
    unsigned long    tags;                // Number of tags within structs
}

@property (NS_NONATOMIC_IOSONLY, readonly) long code;
- (unsigned long)countStructTags:(LLDataDef *)pDef;
@property (NS_NONATOMIC_IOSONLY, readonly) long dataBytes;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSData *dataDefinition;
- (long)entryBytes:(LLDataDef *)pDef;
@property (NS_NONATOMIC_IOSONLY, readonly) long elementBytes;
- (NSArray *)eventDataAsStrings:(DataEvent *)pEvent prefix:(NSString *)prefix suffix:(NSString *)suffix;
- (NSString *)eventDataElementsAsString:(DataEvent *)pEvent;
- (NSArray *)eventEntryAsStrings:(Ptr)dataPtr length:(long)length prefix:(NSString *)prefix suffix:(NSString *)suffix;
- (instancetype)initWithCode:(long)initCode name:(NSString *)initName dataBytes:(long)initBytes;
- (instancetype)initWithCode:(long)initCode name:(NSString *)initName elementBytes:(long)eleBytes
                                    dataDefinition:(LLDataDef *)pDataDef;
@property (NS_NONATOMIC_IOSONLY, getter=isStringData, readonly) BOOL stringData;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *name;
- (unsigned long)padBytes:(unsigned long)sizeBytes offset:(unsigned long)offsetBytes;
- (BOOL)parseDefinition:(LLDataDef *)pDef;
- (void)readDefinitionsFromFile:(id<LLDataReader>)dataFileReader;
- (long)simpleTypeIndex:(LLDataDef *)pDef;
- (NSString *)stringForType:(long)dataType buffer:(Ptr)dataPtr index:(long)index;

@end
