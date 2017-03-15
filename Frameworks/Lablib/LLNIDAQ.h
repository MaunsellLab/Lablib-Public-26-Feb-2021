//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

#import "LLNIDAQmx.h"
#import "LLSockets.h"
#import "LLNIDAQAnalogOutput.h"

@interface LLNIDAQ : NSObject <LLNIDAQmx> {

    LLSockets    *socket;
}

- (LLNIDAQAnalogOutput *)analogOutputTask;
- (NIDAQTask)createTaskWithName:(NSString*)taskName;
- (void)showWindow:(id)sender;

@end
