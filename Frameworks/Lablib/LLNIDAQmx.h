/*
 *  LLNIDAQmx.h
 *  Lablib
 *  
 *  Protocol specifying required methods for object that supports NIDAQmx libraries
 *
 *  Created by John Maunsell on Mar 14 2017.
 *  Copyright (c) 2017. All rights reserved.
 *
 */

typedef uint32_t NIDAQTask;

@protocol LLNIDAQmx <NSObject>

- (NIDAQTask)createTaskWithName:(NSString *)taskName;

@end
