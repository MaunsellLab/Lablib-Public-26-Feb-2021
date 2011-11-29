//
//  LLOldGabor.h
//
//  Created by John Maunsell on Sat Feb 15 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLDisplays.h"
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>

typedef struct {
	double	azimuthDeg;		// Center of gabor 
	double	elevationDeg;	// Center of gabor 
	double	orientationDeg;	// Direction
	double	sigmaDeg;		// Gabor standard deviation
	double	radiusDeg;		// Radius of drawing
	double	sf;				// Spatial frequency
	double	tf;				// Temporal frequency
	double	sPhaseDeg;		// Spatial Phase
	double	tPhaseDeg;		// Temporal Phase
	short   tModulationParam;
	short	tModulation;	// Temporal Modulation: COUNTERPHASE, DRIFTING
	short	sModulation;	// Spatial Modulation: SINE, SQUARE, TRIANGLE
	double	contrast;		// Contrast [0:1]
	double	kdlThetaDeg;	// kdl space (deg)
	double	kdlPhiDeg;		// kdl space (deg)
} OldGabor;

#define kLLOldGaborEventDesc\
	{{@"double", @"azimuthDeg", 1, offsetof(Gabor, azimuthDeg)},\
	{@"double", @"elevationDeg", 1, offsetof(Gabor, elevationDeg)},\
	{@"double", @"orientationDeg", 1, offsetof(Gabor, orientationDeg)},\
	{@"double", @"sigmaDeg", 1, offsetof(Gabor, sigmaDeg)},\
	{@"double", @"radiusDeg", 1, offsetof(Gabor, radiusDeg)},\
	{@"double", @"sf", 1, offsetof(Gabor, sf)},\
	{@"double", @"tf", 1, offsetof(Gabor, tf)},\
	{@"double", @"sPhaseDeg", 1, offsetof(Gabor, sPhaseDeg)},\
	{@"double", @"tPhaseDeg", 1, offsetof(Gabor, tPhaseDeg)},\
	{@"short", @"tModulationParam", 1, offsetof(Gabor, tModulationParam)},\
	{@"short", @"tModulation", 1, offsetof(Gabor, tModulation)},\
	{@"short", @"sModulation", 1, offsetof(Gabor, sModulation)},\
	{@"double", @"contrast", 1, offsetof(Gabor, contrast)},\
	{@"double", @"kdlThetaDeg", 1, offsetof(Gabor, kdlThetaDeg)},\
	{@"double", @"kdlPhiDeg", 1, offsetof(Gabor, kdlPhiDeg)},\
	{nil}}

#ifndef kRadiusLimitSigma

enum {kSineModulation = 1, kSquareModulation, kTriangleModulation};		// spatial modulation
enum {kCounterPhase = 1, kDrifting, kRandom};							// temporal modulation
enum {kSPhase = 1, kOrient, kKdlTheta, kKdlPhi};						// temporal modulation param
enum {kDrawColor, kDrawTextures, kDrawCircle, kDrawTypes};				// display lists

#define kRadiusLimitSigma   3.0						// maximum radius relative to sigma

#endif

@interface LLOldGabor : NSObject {
	
	OldGabor	baseGabor;
	BOOL		circleMask; 
	OldGabor	displayListGabor;
	GLuint		displayListNum;
	LLDisplays	*displays;
	long		displayIndex;
	OldGabor	gabor;				
	NSArray		*keys;
	NSString	*prefix;
	GLfloat		texVertices[8];
	GLfloat		vertices[8];
}

- (double)azimuthDeg;
- (void)bindValuesToKeysWithPrefix:(NSString *)newPrefix;
- (double)contrast;
- (double)directionDeg;
- (void)draw;
- (void)drawCircle;
- (void)drawCircleGL;
- (double)elevationDeg;
- (void)drawTextures;
- (void)drawTexturesGL;
- (OldGabor *)gaborData;
- (double)kdlThetaDeg;
- (double)kdlPhiDeg;
- (void)makeCircularTexture;
- (void)makeCycleTexture;
- (void)makeDisplayLists;
- (void)makeGaussianTexture;
- (double)orientationDeg;
- (double)radiusDeg;
- (void)restore;
- (void)setAzimuthDeg:(double)aziDeg;
- (void)setAzimuthDeg:(double)aziDeg elevationDeg:(double)eleDeg;
- (void)setContrast:(double)newContrast;
- (void)setDirectionDeg:(double)newDir;
- (void)setDisplays:(LLDisplays *)newDisplays displayIndex:(long)index;
- (void)setElevationDeg:(double)eleDeg;
- (void)setFrame:(NSNumber *)frameObject;
- (void)setGaborData:(OldGabor)newGabor;
- (void)setKdltheta:(double)newKdltheta;
- (void)setKdlphi:(double)newKdlphi;
- (void)setKdlThetaDeg:(double)newKdltheta;
- (void)setKdlPhiDeg:(double)newKdlphi;
- (void)setRadiusDeg:(double)newRadius;
- (void)setSF:(double)newSF;
- (void)setSpatialFreqCPD:(double)newSF;
- (void)setSigmaDeg:(double)newSigma;
- (void)setSMod:(short)newSMod;
- (void)setSpatialModulationType:(short)newSMod;
- (void)setSPhaseDeg:(double)newSPhase;
- (void)setSpatialPhaseDeg:(double)newSPhase;
- (void)setTF:(double)newTF;
- (void)setTemporalFreqHz:(double)newTF;
- (void)setTemporalPhaseDeg:(double)newTF;
- (void)setTMod:(short)newTMod;
- (void)setTemporalModulationType:(short)newTMod;
- (void)setTParam:(short)newTParam;
- (void)setTemporalModulationParam:(short)newTParam;
- (void)setTPhaseDeg:(double)newTPhase;
- (void)setTemporalPhaseDeg:(double)newTPhase;
- (double)spatialFreqCPD;
- (double)sigmaDeg;
- (double)spatialPhaseDeg;
- (short)spatialModulationType;
- (void)store;
- (double)temporalFreqHz;
- (short)temporalModulationType;
- (short)temporalModulationParam;
- (double)temporalPhaseDeg;
- (void)unbindValues;
- (void)updateCycleTexture;
- (void)updateCycleTextureGL;


@end

