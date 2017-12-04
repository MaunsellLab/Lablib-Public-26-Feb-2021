//
//  LLGitController.m
//  Lablib
//
//  Created by John Maunsell on 12/3/17.
//

#import "LLGitController.h"
#import "NSString+ShellExecution.h"

@implementation LLGitController

- (void)addAllFiles;
{
    NSString *output;

    output = [[NSString stringWithFormat:@"%@ add .", self.commandPreamble] runAsCommand];    // add without deleting
}

- (void)commit;
{
    NSString *output;
    NSString *dateTime = [NSDateFormatter localizedStringFromDate:[NSDate date]
                dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle];

    output = [[NSString stringWithFormat:@"%@ commit -m \"Lablib Commit %@\"", self.commandPreamble, dateTime]
              runAsCommand];
    NSLog(@"%@", output);
}

- (NSString *)gitStatus:(NSString *)taskName;
{
    NSString *gitCommand;
    NSString *workTree = [NSString stringWithFormat:@"/Users/Shared/Data/%@", taskName];

    self.commandPreamble = [NSString stringWithFormat:@"git --git-dir=%@/.git --work-tree=%@", workTree, workTree];
    gitCommand = [NSString stringWithFormat:@"%@ status", self.commandPreamble];
    NSString *output = [gitCommand runAsCommand];
    return output;
}

- (void)push;
{
    NSString *output;

    NSLog(@"Pushing repository");
    output = [[NSString stringWithFormat:@"%@ push", self.commandPreamble]
              runAsCommand];
    NSLog(@"%@", output);
}

- (void)updateRepository:(LLTaskPlugIn *)task;
{
    NSString *status;

    if (!task.usesGit) {
        return;
    }
    status = [self gitStatus:task.name];
    NSLog(@"%@", status);
    if ([status containsString:@"Untracked files:"]) {
        [self addAllFiles];
        [self commit];
    }
    else if (![status containsString:@"Your branch is up-to-date with 'origin/master'."]) {
        [self push];
    }
}

@end
