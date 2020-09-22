//
//  LLVisualStimulus.h
//  Lablib
//  Protocol for visual stimuli
//
//  Created by John Maunsell on 6/18/05.
//  Copyright 2005. All rights reserved.
//

#define kKeyPadPeriodKeyCode    65
#define kKeyPadStarKeyCode        67
#define kKeyPadPlusKeyCode        69
#define kKeyPadClearKeyCode        71
#define kKeyPadSlashKeyCode        75
#define kKeyPadEnterKeyCode        76
#define kKeyPadMinusKeyCode        78
#define kKeyPadEqualsKeyCode    81
#define kKeyPad0KeyCode            82
#define kKeyPad1KeyCode            83
#define kKeyPad2KeyCode            84
#define kKeyPad3KeyCode            85
#define kKeyPad4KeyCode            86
#define kKeyPad5KeyCode            87
#define kKeyPad6KeyCode            88
#define kKeyPad7KeyCode            89
#define kKeyPad8KeyCode            91
#define kKeyPad9KeyCode            92

#define GL_SILENCE_DEPRECATION
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#import <Lablib/LLDisplays.h>

extern NSString *LLAzimuthDegKey;
extern NSString *LLBackColorKey;
extern NSString *LLDirectionDegKey;
extern NSString *LLElevationDegKey;
extern NSString *LLForeColorKey;
extern NSString *LLKdlThetaDegKey;
extern NSString *LLKdlPhiDegKey;
extern NSString *LLRadiusDegKey;

@interface LLVisualStimulus : NSObject {

    float            azimuthDeg;
    NSColor            *backColor;
    float            directionDeg;
    long            displayIndex;
    LLDisplays        *displays;
    float            elevationDeg;
    NSColor            *foreColor;
    float            kdlThetaDeg;                        // kdl space (deg)
    float            kdlPhiDeg;                            // kdl space (deg)
    NSMutableArray    *keys;
    NSString        *prefix;
    float            radiusDeg;
    NSString        *stimPrefix;
    NSString        *taskPrefix;
    BOOL            setUnderway;
    BOOL            state;
    NSArray         *topLevelObjects;
    
    IBOutlet NSWindow *dialogWindow;
}

@property (NS_NONATOMIC_IOSONLY) float azimuthDeg;
@property (NS_NONATOMIC_IOSONLY, copy) NSColor *backColor;
- (void)bindValuesToKeysWithPrefix:(NSString *)newPrefix;
@property (NS_NONATOMIC_IOSONLY) float directionDeg;
- (void)directSetAzimuthDeg:(float)aziDeg elevationDeg:(float)eleDeg;
- (void)directSetDirectionDeg:(float)newDirection;
- (void)directSetFrame:(NSNumber *)frameNumber;
- (void)directSetRadiusDeg:(float)newRadius;
- (void)draw;
@property (NS_NONATOMIC_IOSONLY) float elevationDeg;
@property (NS_NONATOMIC_IOSONLY, copy) NSColor *foreColor;
@property (NS_NONATOMIC_IOSONLY) float kdlThetaDeg;
@property (NS_NONATOMIC_IOSONLY) float kdlPhiDeg;
@property (NS_NONATOMIC_IOSONLY) float radiusDeg;
- (void)removeKeyFromBinding:(NSString *)key;
- (void)removeKeysFromBinding:(NSArray *)keys;
- (void)runSettingsDialog;
- (void)setAzimuthDeg:(float)aziDeg elevationDeg:(float)eleDeg;
- (void)setBackOnRed:(float)red green:(float)green blue:(float)blue;
- (void)setDisplays:(LLDisplays *)newDisplays displayIndex:(long)index;
- (void)setForeOnRed:(float)red green:(float)green blue:(float)blue;
- (void)setFrame:(NSNumber *)frameNumber;
@property (NS_NONATOMIC_IOSONLY) long state;
- (void)unbindValues;
- (void)updateFloatDefault:(float)value key:(NSString *)key;
- (void)updateIntegerDefault:(long)value key:(NSString *)key;

@end
