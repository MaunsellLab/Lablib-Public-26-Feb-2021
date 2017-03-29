//
//  LLMatlabController
//  Lablib
//
//  Created by John Maunsell on 1/7/17.
//
//

#import <Lablib/LLMatlabEngine.h>
#import <Lablib/LLTaskPlugIn.h>

@interface LLMatlabController : NSObject {

    NSMutableDictionary *bundledEvents;
    NSMutableString     *bundledString;
    LLMatlabEngine      *engine;
    NSFileManager       *fileManager;
    long                numEvents;
    long                subjectNumber;
    LLTaskPlugIn        *task;
    long                *trialEventCounts;
    long                trialNum;
    long                trialStartEventCode;
    long                trialStartTime;
}

- (void)activate:(LLTaskPlugIn *)plugin;
- (void)checkMatlabDataPath;
- (NSMutableString *)convertToMatlabString:(NSString *)eventString;
- (void)deactivate;
- (id)initWithSubjectNumber:(long)number;
- (void)loadMatlabWorkspace;
- (NSString *)matlabFileName;
- (BOOL)matlabFileExists;
- (void)processEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time prefix:(NSString *)prefix;
- (void)processFileEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)processTrialEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)saveMatlabWorkspace;
- (void)writeBundledData;

@end
