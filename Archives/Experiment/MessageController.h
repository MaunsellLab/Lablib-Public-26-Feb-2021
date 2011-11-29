//
//  MessageController.h
//  Experiment
//
//  Created by John Maunsell on Wed Apr 09 2003.
//  Copyright (c) 2003. All rights reserved.
//

extern NSString *messageWindowVisibleKey;

@interface MessageController:NSWindowController {

    NSString			*string;
    IBOutlet NSTextView *textView;
}

- (void) appendString:(NSString *)str;
- (IBAction) clear:(id)sender;
- (void)setString:(NSString *)value;

@end

@interface NSTextView(MessageWindow)
- (void) appendString:(NSString *)str;
@end