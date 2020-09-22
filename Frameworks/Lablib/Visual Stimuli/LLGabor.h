//
//  LLGabor.h
//
//  Created by John Maunsell on Sat Feb 15 2003.
//  Copyright (c) 2006. All rights reserved.
//

#import <Lablib/LLVisualStimulus.h>

typedef struct {
    float    azimuthDeg;                // Center of gabor 
    float    contrast;                // Contrast [0:1]
    float    directionDeg;            // Direction
    float    elevationDeg;            // Center of gabor 
    float    kdlThetaDeg;            // kdl space (deg)
    float    kdlPhiDeg;                // kdl space (deg)
    float    radiusDeg;                // Radius of drawing
    float    sigmaDeg;                // Gabor standard deviation
    float    spatialFreqCPD;            // Spatial frequency
    long    spatialModulation;        // Spatial Modulation: SINE, SQUARE, TRIANGLE
    float    spatialPhaseDeg;        // Spatial Phase
    float    temporalFreqHz;            // Temporal frequency
    long    temporalModulation;        // Temporal Modulation: COUNTERPHASE, DRIFTING
    long    temporalModulationParam;// Parameter modulated in time
    float    temporalPhaseDeg;        // Temporal Phase
} Gabor;

#define kLLGaborEventDesc\
    {{@"float", @"azimuthDeg", 1, offsetof(Gabor, azimuthDeg)},\
    {@"float", @"contrast", 1, offsetof(Gabor, contrast)},\
    {@"float", @"directionDeg", 1, offsetof(Gabor, directionDeg)},\
    {@"float", @"elevationDeg", 1, offsetof(Gabor, elevationDeg)},\
    {@"float", @"kdlThetaDeg", 1, offsetof(Gabor, kdlThetaDeg)},\
    {@"float", @"kdlPhiDeg", 1, offsetof(Gabor, kdlPhiDeg)},\
    {@"float", @"radiusDeg", 1, offsetof(Gabor, radiusDeg)},\
    {@"float", @"sigmaDeg", 1, offsetof(Gabor, sigmaDeg)},\
    {@"float", @"spatialFreqCPD", 1, offsetof(Gabor, spatialFreqCPD)},\
    {@"long", @"spatialModulation", 1, offsetof(Gabor, spatialModulation)},\
    {@"float", @"spatialPhaseDeg", 1, offsetof(Gabor, spatialPhaseDeg)},\
    {@"float", @"temporalFreqHz", 1, offsetof(Gabor, temporalFreqHz)},\
    {@"long", @"temporalModulation", 1, offsetof(Gabor, temporalModulation)},\
    {@"long", @"temporalModulationParam", 1, offsetof(Gabor, temporalModulationParam)},\
    {@"float", @"temporalPhaseDeg", 1, offsetof(Gabor, temporalPhaseDeg)},\
    {nil}}

#define kRadiusLimitSigma   3.0                        // maximum radius relative to sigma

typedef NS_ENUM(unsigned int, SpatialModulation) {kSineModulation = 0, kSquareModulation, kTriangleModulation};   // spatial modulation
typedef NS_ENUM(unsigned int, TemporalModulation) {kCounterPhase = 0, kDrifting, kRandom};                        // temporal modulation
typedef NS_ENUM(unsigned int, TemporalModulationParam) {kSPhase = 0, kDirection, kKdlTheta, kKdlPhi};             // temporal mod param
typedef NS_ENUM(unsigned int, DisplayLists) {kDrawColor, kDrawTextures, kDrawCircle, kDrawTypes};                 // display lists

extern NSString *LLGaborAzimuthDegKey;
extern NSString *LLGaborBackColorKey;
extern NSString *LLGaborDirectionDegKey;
extern NSString *LLGaborElevationDegKey;
extern NSString *LLGaborForeColorKey;
extern NSString *LLGaborKdlThetaDegKey;
extern NSString *LLGaborKdlPhiDegKey;
extern NSString *LLGaborRadiusDegKey;

extern NSString *LLGaborContrastKey;
extern NSString *LLGaborSpatialFreqCPDKey;
extern NSString *LLGaborSigmaDegKey;
extern NSString *LLGaborSpatialModulationKey;
extern NSString *LLGaborSpatialPhaseDegKey;
extern NSString *LLGaborTemporalFreqHzKey;
extern NSString *LLGaborTemporalModulationKey;
extern NSString *LLGaborTemporalModulationParamKey;
extern NSString *LLGaborTemporalPhaseDegKey;
    
@interface LLGabor : LLVisualStimulus {
    
    BOOL        achromatic;                            // Achromatic grating
    Gabor        baseGabor;
    float        contrast;                            // Contrast [0:1]
    Gabor        displayListGabor;
    GLuint        displayListNum;
    Gabor        gabor;
    float        radiusLimitSigma;
    float        sigmaDeg;                            // Gabor standard deviation
    float        spatialFreqCPD;                        // Spatial frequency
    float        spatialPhaseDeg;                    // Spatial Phase
    long        spatialModulation;                    // Spatial Modulation: SINE, SQUARE, TRIANGLE */
    float        temporalFreqHz;
    long        temporalModulation;
    long        temporalModulationParam;
    float        temporalPhaseDeg;
    GLfloat        texVertices[8];
    GLfloat        vertices[8];
}

@property (NS_NONATOMIC_IOSONLY) float contrast;
- (void)directSetContrast:(float)newContrast;
- (void)directSetSigmaDeg:(float)newSigma;
- (void)directSetSpatialFreqCPD:(float)newSF;
- (void)directSetSpatialPhaseDeg:(float)newSPhase;
- (void)directSetTemporalFreqHz:(float)newTF;
- (void)directSetTemporalPhaseDeg:(float)newTPhase;
- (void)drawCircularStencil;
- (void)drawCircularStencilGL;
- (void)drawTextures;
- (void)drawTexturesGL;
- (Gabor *)gaborData NS_RETURNS_INNER_POINTER;
- (void)loadGabor:(Gabor *)pGabor;
- (void)makeCircle;
- (void)makeCycleTexture;
- (void)makeDisplayLists;
- (void)makeGaussianTexture;
- (void)restore;
- (void)setAchromatic:(BOOL)newState;
- (void)setFrame:(NSNumber *)frameObject;
- (void)setGaborData:(Gabor)newGabor;
- (void)setPhaseDeg:(float)newPhaseDeg;
- (void)setRadiusLimitSigma:(float)newLimit;
@property (NS_NONATOMIC_IOSONLY) float spatialFreqCPD;
@property (NS_NONATOMIC_IOSONLY) float sigmaDeg;
@property (NS_NONATOMIC_IOSONLY) float spatialPhaseDeg;
@property (NS_NONATOMIC_IOSONLY) long spatialModulation;
- (void)store;
@property (NS_NONATOMIC_IOSONLY) float temporalFreqHz;
@property (NS_NONATOMIC_IOSONLY) long temporalModulation;
@property (NS_NONATOMIC_IOSONLY) long temporalModulationParam;
@property (NS_NONATOMIC_IOSONLY) float temporalPhaseDeg;
- (void)updateCycleTexture;
- (void)updateCycleTextureGL;

@end

