//
//  LLMatlabController
//  Lablib
//
//  Created by John Maunsell on 1/7/17.
//

#import "LablibMatlab.h"
#import "LLMatlabEngine.h"
#import <Lablib/LLTaskPlugIn.h>

typedef NS_ENUM(long, SubjectChangeType) {kSubjectReset, kSubjectPostAndReset, kSubjectDefault};


@interface LLMatlabController : NSObject {

    NSMutableDictionary *bundledEvents;
    NSMutableString     *bundledString;
    NSDateFormatter     *dateFormatter;
    LLMatlabEngine      *engine;
    NSFileManager       *fileManager;
    NSString            *matFileName;
    NSString            *matlabInitScriptCommand;
    NSString            *matlabScriptCommand;
    long                numEvents;
    long                subjectNumber;
    LLTaskPlugIn        *task;
    long                *trialEventCounts;
    long                trialNum;
    long                trialNumKey;
    long                trialStartEventCode;
    long                trialStartTime;
}

@property (NS_NONATOMIC_IOSONLY) long initializedForSubject;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL loadMatlabWorkspace;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSString *matlabFileName;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL matlabFileExists;
@property (NS_NONATOMIC_IOSONLY, retain) NSData *subjectData;
@property (NS_NONATOMIC_IOSONLY, retain) NSNumber *subjectTime;

- (void)activate:(LLTaskPlugIn *)plugin;
- (void)checkMatlabDataPath:(NSString *)dirName;
- (NSMutableString *)convertToMatlabString:(NSString *)eventString;
- (void)deactivate;
- (void)deferredSubjectNumber:(NSData *)eventData eventTime:(NSNumber *)eventTime;
- (SubjectChangeType)doSubjectNumber:(NSData *)eventData eventTime:(NSNumber *)eventTime;
- (instancetype)initWithMatFile:(NSString *)fileName subjectNumber:(long)number;
- (void)launchFinished;
- (BOOL)loadMatlabWorkspace;
- (void)processEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time prefix:(NSString *)prefix;
- (void)processFileEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)processTrialEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)saveFigureAsPDF;
- (void)saveMatlabWorkspace;
- (void)subjectNumber:(NSData *)eventData eventTime:(NSNumber *)eventTime;
- (void)writeBundledData;

@end
