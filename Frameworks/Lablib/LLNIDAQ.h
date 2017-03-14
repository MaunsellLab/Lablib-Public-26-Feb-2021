//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLSockets.h"

typedef uint32_t NIDAQTask;

@interface LLNIDAQ : NSObject {

    LLSockets    *socket;
}

- (id)analogOutputTask;
- (NIDAQTask)createTaskWithName:(NSString*)taskName;

@end
