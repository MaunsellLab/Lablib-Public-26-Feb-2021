//
//  LLNIDAQ.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//

//#import "LLNIDAQmx.h"
#import "LLSockets.h"
#import "LLNIDAQAnalogOutput.h"

@interface LLNIDAQ : NSObject {

    NSLock      *deviceLock;
    NSString    *deviceName;
    BOOL        doControlShutter;
    LLSockets   *socket;
}

- (id)initWithSocket:(LLSockets *)theSocket;
- (void)outputDigitalValue:(short)value channelName:(NSString *)channelName;
- (void)showWindow:(id)sender;

@end
