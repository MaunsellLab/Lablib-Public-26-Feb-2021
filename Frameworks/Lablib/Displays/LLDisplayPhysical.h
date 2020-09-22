//
//  LLDisplayPhysical.h
//  Lablib
//
//  Created by John Maunsell on Tue Jul 15 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import <Lablib/LLDisplayUtilities.h>

#define kLLScreenDomainName        @"lablib.knot.screen"
#define kMaxDisplay                16

typedef struct {
    double frameRateHz;                    // the following entries are read from the device
    long pixelBits;    
    long widthPix;
    long heightPix;
    RGBDouble CIEx;                        // the following entries are read from system-wide settings
    RGBDouble CIEy;
    double distanceMM;
    double widthMM;
    double heightMM;
} DisplayPhysicalParam;

@interface LLDisplayPhysical : NSWindowController {
    
    DisplayPhysicalParam        currentParam;
    DisplayPhysicalParam        displayParam[kMaxDisplay];
    BOOL                        initialized[kMaxDisplay];
    BOOL                        permissionChecked;
    
    IBOutlet NSTextField        *distanceField;
    IBOutlet NSTextField        *heightInchField;
    IBOutlet NSTextField        *widthInchField;
    IBOutlet NSTextField        *redXField;
    IBOutlet NSTextField        *redYField;
    IBOutlet NSTextField        *greenXField;
    IBOutlet NSTextField        *greenYField;
    IBOutlet NSTextField        *blueXField;
    IBOutlet NSTextField        *blueYField;
    IBOutlet NSColorWell        *cardinalGreenPatch;
    IBOutlet NSColorWell        *cardinalYellowPatch;
    IBOutlet NSColorWell        *equalEnergyPatch;
}

- (DisplayPhysicalParam *)displayParameters:(long)displayIndex NS_RETURNS_INNER_POINTER;
- (void)doSettingsPanel:(long)displayIndex;
- (RGBDouble)maxColor:(RGBDouble)inColor;
- (BOOL)readDomain:(NSString *)domainName key:(NSString *)keyName doublePtr:(double *)pValue;
- (BOOL)readParameters:(long)displayIndex;
- (void)showColors;
- (void)writeDomain:(NSString *)domainName key:(NSString *)keyName doublePtr:(double *)pValue;
- (void)writeParameters:(long)index;

- (IBAction)changeDistance:(id)sender;
- (IBAction)changeHeightInch:(id)sender;
- (IBAction)changeWidthInch:(id)sender;
- (IBAction)changeRedX:(id)sender;
- (IBAction)changeRedY:(id)sender;
- (IBAction)changeGreenX:(id)sender;
- (IBAction)changeGreenY:(id)sender;
- (IBAction)changeBlueX:(id)sender;
- (IBAction)changeBlueY:(id)sender;
- (IBAction)ok:(id)sender;


@end

