//
//  MessageWindow.h
//  Lablib
//
//  Created by John Maunsell on Wed Apr 09 2003.
//  Copyright (c) 2003. All rights reserved.
//

@interface LLMessageWindow : NSWindowController 
{
    NSString			*string;
    IBOutlet NSTextView *textView;
}

- (void) appendString:(NSString *)str;
- (IBAction) clear:(id)sender;
- (id) initWithDocument:(NSDocument *)doc;
- (void)setString:(NSString *)value;

@end

@interface NSTextView(LLMessageWindow)
- (void) appendString:(NSString *)str;
@end