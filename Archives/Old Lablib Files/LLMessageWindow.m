//
//  LLMessageWindow.m
//  Lablib
//
//  Created by John Maunsell on Wed Apr 09 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLMessageWindow.h"

static NSString *windowString = @"Message Window";

@implementation LLMessageWindow

- (void) appendString:(NSString *)str
{
    [textView appendString:str];
}

- (IBAction) clear:(id)sender;
{
    [textView setString:@""];
}

- (NSData *) dataRepresentationOfType:(NSString *)aType
{
    return [[textView string] dataUsingEncoding:NSASCIIStringEncoding];
}

- (id) initWithDocument:(NSDocument *)doc;
{
    [self initWithWindowNibName:@"LLMessageWindow"];
    [doc addWindowController:self];
    [[self window] makeKeyAndOrderFront:self];
    [NSApp addWindowsItem:[self window] title:windowString filename:FALSE];
    return self;
}

- (BOOL) loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{
    [textView appendString:[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]];
    return YES;
}

- (NSString *) string 
{
    return [textView string];
}

- (void) setString:(NSString *)value 
{
    [textView setString:value];
}

- (void) windowDidLoad
{
    [super windowDidLoad];
    [textView setAutoresizingMask: NSViewWidthSizable];
    [[textView textContainer] setWidthTracksTextView:YES];
    [textView setDelegate:self];
    [textView setEditable:NO];
    [textView setRichText:NO];
    [textView setFont:[NSFont fontWithName:@"Monaco" size:10]];

	[[self window] setTitle:@"Messages"];
}

// Delegate method to stop the window from being released when the user closes it

- (BOOL) windowShouldClose:(id)sender
{
    [[self window] orderBack:self];
//    [[[NSApp windowsMenu] itemWithTitle:windowString] setState:NSOffState];
    return FALSE;
}

@end

@implementation NSTextView(LLMessageWindow)

- (void) appendString:(NSString *)str
{
    unsigned long length;
    
     length =  [[self textStorage] length];
    [self replaceCharactersInRange:NSMakeRange(length, 0) withString:str];
}
@end
