//
//  LLGitController.h
//  Lablib
//
//  Created by John Maunsell on 12/3/17.
//

#ifndef LLGitController_h
#define LLGitController_h

#import "LLTaskPlugIn.h"

@interface LLGitController : NSObject {

}

@property (NS_NONATOMIC_IOSONLY, retain) NSString *commandPreamble;

- (void)addAllFiles;
- (void)commit;
- (NSString *)status:(NSString *)taskName;
- (void)updateRepository:(LLTaskPlugIn *)task;

@end

#endif /* LLGitController_h */
