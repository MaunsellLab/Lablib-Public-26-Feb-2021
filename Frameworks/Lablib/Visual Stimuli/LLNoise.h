//
//  LLNoise.h
//  Lablib
//
//  Created by Geoff Ghose on 5/16/05.
//  Copyright 2005. All rights reserved.
//    A subclass of the LLGabor object where a noise texture replaces a cycle texture.

#import <Lablib/LLGabor.h>

typedef struct {
    double orientationDegBand;
    double spatialFreqBandOct;
    double noiseAzimuthDeg;
    double noiseElevationDeg;
    double motionSpeed;
    double motionDir;
    long   seed;
} Noise;

typedef NS_ENUM(unsigned int, NoiseType) {kWhiteNoise, kOneOverFNoise, kGaussianNoise};

#define    kNoisePix (1 << 9)
#define kNoisePos (kKdlPhi + 1)

@interface LLNoise : LLGabor {
    Noise        baseNoise, displayListNoise, drawNoise;                
    float        *freq;
    GLubyte        noiseImage[kNoisePix][kNoisePix];
    GLuint        noiseTexture;
    long        noiseType;
    float        rfact[kNoisePix][kNoisePix];
}

- (void) draw;
- (void) drawTextures;
- (void) drawTexturesGL;
- (void)makeDisplayLists;
- (void)makeNoiseTexture;
- (Noise *)noiseData NS_RETURNS_INNER_POINTER;
- (void)restore;
- (void)setFrame:(NSNumber *)frameObject;
- (void)setMotionDir:(double)motionDir;
- (void)setMotionSpeed:(double)motionSpeed;
- (void)setNoiseAzimuth:(double)az elevation:(double)el;
- (void)setNoiseData:(Noise)newNoise;
- (void)setNoiseType:(long)newType;
- (void)setOrientationBandDeg:(double)orBand;
- (void)setSeed:(long)seed;
- (void)setSpatialFreqBandOct:(double)sfBand;
- (void)store;
- (void)updateNoiseTexture;
- (void)updateNoiseTextureGL;


@end

