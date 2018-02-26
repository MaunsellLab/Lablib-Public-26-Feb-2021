//
//  LablibQuest.h
//  LablibQuest
//
//  Created by John Maunsell on 2/24/18.
//  Copyright © 2018 John Maunsell. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//! Project version number for LablibQuest.
FOUNDATION_EXPORT double LablibQuestVersionNumber;

//! Project version string for LablibQuest.
FOUNDATION_EXPORT const unsigned char LablibQuestVersionString[];

@interface LablibQuest : NSObject {

}

@property (NS_NONATOMIC_IOSONLY) BOOL updatePdf;
@property (NS_NONATOMIC_IOSONLY) BOOL warnPdf;
@property (NS_NONATOMIC_IOSONLY) BOOL normalizedPdf;
@property (NS_NONATOMIC_IOSONLY) double guess;
@property (NS_NONATOMIC_IOSONLY) double guessSD;
@property (NS_NONATOMIC_IOSONLY) double pThreshold;
@property (NS_NONATOMIC_IOSONLY) double beta;
@property (NS_NONATOMIC_IOSONLY) double delta;
@property (NS_NONATOMIC_IOSONLY) double gamma;
@property (NS_NONATOMIC_IOSONLY) double grain;
@property (NS_NONATOMIC_IOSONLY) double dim;

- (void)recompute;

@end
