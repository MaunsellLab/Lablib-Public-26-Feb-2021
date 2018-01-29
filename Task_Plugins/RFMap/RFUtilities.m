//
//  RFUtilities.m
//  Fixate
//
//  Created by John Maunsell on 7/2/12.
//  Copyright (c) 2012 Harvard Medical School. All rights reserved.
//

#import "RFUtilities.h"
#include "RF.h"

NSString *RFEyeToUseKey = @"RFEyeToUse";

typedef NS_ENUM(unsigned int, RFEyeToUse) {kUseLeftEye = 0, kUseRightEye, kUseBinocular};

@implementation RFUtilities

+ (BOOL)inWindow:(LLEyeWindow *)window;
{
    BOOL inWindow = NO;
    
    switch ([[NSUserDefaults standardUserDefaults] integerForKey:RFEyeToUseKey]) {
        case kUseLeftEye:
        default:
            inWindow = [window inWindowDeg:(task.currentEyesDeg)[kLeftEye]];
            break;
        case kUseRightEye:
            inWindow = [window inWindowDeg:(task.currentEyesDeg)[kRightEye]];
            break;
        case kUseBinocular:
            inWindow = [window inWindowDeg:(task.currentEyesDeg)[kLeftEye]] &&
            [window inWindowDeg:(task.currentEyesDeg)[kRightEye]];
            break;
    }
    return inWindow;
}

@end
