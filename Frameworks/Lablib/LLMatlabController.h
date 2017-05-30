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

- (void)activate:(LLTaskPlugIn *)plugin;
- (void)checkMatlabDataPath:(NSString *)dirName;
- (NSMutableString *)convertToMatlabString:(NSString *)eventString;
- (void)deactivate;
- (id)initWithMatFile:(NSString *)fileName subjectNumber:(long)number;
- (BOOL)loadMatlabWorkspace;
- (NSString *)matlabFileName;
- (BOOL)matlabFileExists;
- (void)processEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time prefix:(NSString *)prefix;
- (void)processFileEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)processTrialEventNamed:(NSString *)eventName eventData:(NSData *)data eventTime:(NSNumber *)time;
- (void)saveFigureAsPDF;
- (void)saveMatlabWorkspace;
- (void)writeBundledData;

@end
