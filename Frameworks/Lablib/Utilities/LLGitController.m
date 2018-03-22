//
//  LLGitController.m
//  Lablib
//
//  Created by John Maunsell on 12/3/17.
//

/*
 Git is deleting from respository.  I probably need to stop using git commit -a.  Should do git add -a and then git commit?

 */

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

- (NSString *)status:(NSString *)taskName;
{
    NSString *gitCommand, *output;
    NSString *workTree = [NSString stringWithFormat:@"/Users/Shared/Data/%@", taskName];

    self.commandPreamble = [NSString stringWithFormat:@"git --git-dir=%@/.git --work-tree=%@", workTree, workTree];
    gitCommand = [NSString stringWithFormat:@"%@ remote update", self.commandPreamble];
    output = [gitCommand runAsCommand];
    NSLog(@"%@", output);
    gitCommand = [NSString stringWithFormat:@"%@ status", self.commandPreamble];
    return [gitCommand runAsCommand];;
}

- (void)pull;
{
    NSString *output;

    NSLog(@"Pulling repository");
    output = [[NSString stringWithFormat:@"%@ pull", self.commandPreamble] runAsCommand];
    NSLog(@"%@", output);
}

- (void)push;
{
    NSString *output;

    NSLog(@"Pushing repository");
    output = [[NSString stringWithFormat:@"%@ push", self.commandPreamble] runAsCommand];
    NSLog(@"%@", output);
}

// Pull any new files in the repository, then push any new files to the repository

- (void)updateRepository:(LLTaskPlugIn *)task;
{
    NSString *status;

    if (!task.usesGit) {
        return;
    }
    status = [self status:task.name];
    NSLog(@"%@", status);
    if ([status containsString:@"use \"git pull\" to merge the remote branch"]) {  // changes to pull
        NSLog(@"LLGitController: doing pull for %@", task.name);
        [self pull];
        status = [self status:task.name];
        NSLog(@"%@", status);
    }
    if ([status containsString:@"Untracked files:"] || [status containsString:@"Changes not staged for commit:"]) {
        NSLog(@"LLGitController: adding, committing, pulling and pushing %@", task.name);
        [self addAllFiles];
        [self commit];
        [self pull];
        [self push];
        status = [self status:task.name];
        NSLog(@"%@", status);
    }
    else if (![status containsString:@"Your branch is up-to-date with 'origin/master'."]) {
        NSLog(@"LLGitController: pull %@", task.name);
        [self pull];
        NSLog(@"%@", [self status:task.name]);
    }
    else {
        NSLog(@"LLGitController: %@ is clean and up to date", task.name);
    }
}

@end
