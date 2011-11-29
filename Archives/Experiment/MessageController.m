//
//  MessageController.m
//  Experiment
//
//  Created by John Maunsell on Wed Apr 09 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "MessageController.h"

NSString *messageWindowVisibleKey = @"Message Window Visible";

@implementation MessageController

- (void) appendString:(NSString *)str {

    [textView appendString:str];
}

- (IBAction) clear:(id)sender {

    NSRect r;
//    [textView setString:@""];
    [self appendString:@"This is another test string"];
    r = [textView bounds];
    NSLog(@"MesssageWindow: textView bounds %f %f %f %f ", r.origin.x, r.origin.y, r.size.width, r.size.height);
    r = [textView frame];
    NSLog(@"MesssageWindow: textView frame %f %f %f %f ", r.origin.x, r.origin.y, r.size.width, r.size.height);
}

- (NSData *) dataRepresentationOfType:(NSString *)aType {

    return [[textView string] dataUsingEncoding:NSASCIIStringEncoding];
}

- (id) init {

    if ((self = [super initWithWindowNibName:@"MessageController"]) != Nil) {
        [self setWindowFrameAutosaveName:@"MessageWindow"];
        [self window];							// Force the window to load now
    }
    return self;
}

- (BOOL) loadDataRepresentation:(NSData *)data ofType:(NSString *)aType {

    [textView appendString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    return YES;
}

- (NSString *) string{

    return [textView string];
}

- (void) setString:(NSString *)value {

    [textView setString:value];
}

- (BOOL) shouldCascadeWindows {

    return NO;
}

- (void)windowDidBecomeKey:(NSNotification *)aNotification {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] 
                forKey:messageWindowVisibleKey];
}

- (void) windowDidLoad {

    [textView setAutoresizingMask:NSViewWidthSizable];
    [[textView textContainer] setWidthTracksTextView:YES];
    [textView setDelegate:self];
    [textView setEditable:NO];
    [textView setRichText:NO];
    [textView setFont:[NSFont fontWithName:@"Monaco" size:10]];
	[[self window] setTitle:@"Messages"];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:messageWindowVisibleKey]) {
        [[self window] makeKeyAndOrderFront:self];
    }
    else {
        [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    }
    [super windowDidLoad];
}

// Delegate method to stop the window from being released when the user closes it

- (BOOL) windowShouldClose:(NSNotification *)aNotification {

    [[self window] orderOut:self];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] 
                forKey:messageWindowVisibleKey];
    [NSApp addWindowsItem:[self window] title:[[self window] title] filename:NO];
    return NO;
}

@end

@implementation NSTextView(MessageWindow)

- (void) appendString:(NSString *)str {

    unsigned long length;
    
	length =  [[self textStorage] length];
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:str];
}
@end
