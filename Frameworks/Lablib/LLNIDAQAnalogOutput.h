//
//  LLNIDAQAnalogOutput.h
//  Lablib
//
//  Created by John Maunsell on 3/13/17.
//
//

#import "LLNIDAQmx.h"

@class LLNIDAQ;

@interface LLNIDAQAnalogOutput : NSObject {

    LLNIDAQ     *nidaq;
    NIDAQTask   task;
}

- (id)initWithNIDAQ:(LLNIDAQ *)theNIDAQ;

@end
