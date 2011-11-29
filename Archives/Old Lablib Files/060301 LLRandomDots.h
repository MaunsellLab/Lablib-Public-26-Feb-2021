//
//  LLRandomDots.h
//
//  Created by John Maunsell on Sat Feb 15 2003.
//  Copyright (c) 2004. All rights reserved.
//

#import "LLVisualStimulus.h"
#import "LLDisplays.h"
#include <OpenGL/gl.h>
#include <OpenGL/glu.h>
#include <OpenGL/glext.h>

#define kRDImagePix				256						// must be a power of 2

typedef struct {
	BOOL		antialias;			// antialias the dots
	long		lifeFrames;			// Life of each dot
	long		randomSeed;			// seed for generating movie
	long		version;			// version of this structure
	float		azimuthDeg;			// Center of gabor 
	float		coherencePC;		// Percent coherence
	float		density;			// Dot Density (per degree squared)
	float		directionDeg;		// Direction of motion
	float		dotContrast;		// Contrast [0:1]
	float		dotDiameterDeg;		// Dot diameter in degrees
	float		elevationDeg;		// Center of gabor 
	float		kdlPhiDeg;			// kdl space (deg)
	float		kdlThetaDeg;		// kdl space (deg)
	float		patchRadiusDeg;		// Radius of drawing
	float		speedDPS;			// Dot speed degrees/s
	float		stepCoherencePC;	// Coherence after step
	RGBDouble	backgroundColor;	// color of background
	RGBDouble	dotColor;			// color of dots
} RandomDots;

#define kLLRandomDotsEventDesc\
	{{@"boolean", @"antialias", 1, offsetof(RandomDots, antialias)},\
	{@"long", @"lifeFrames", 1, offsetof(RandomDots, lifeFrames)},\
	{@"long", @"randomSeed", 1, offsetof(RandomDots, randomSeed)},\
	{@"long", @"version", 1, offsetof(RandomDots, version)},\
	{@"float", @"azimuthDeg", 1, offsetof(RandomDots, azimuthDeg)},\
	{@"float", @"coherencePC", 1, offsetof(RandomDots, coherencePC)},\
	{@"float", @"density", 1, offsetof(RandomDots, density)},\
	{@"float", @"directionDeg", 1, offsetof(RandomDots, directionDeg)},\
	{@"float", @"dotContrast", 1, offsetof(RandomDots, dotContrast)},\
	{@"float", @"dotDiameterDeg", 1, offsetof(RandomDots, dotDiameterDeg)},\
	{@"float", @"elevationDeg", 1, offsetof(RandomDots, elevationDeg)},\
	{@"float", @"kdlPhiDeg", 1, offsetof(RandomDots, kdlPhiDeg)},\
	{@"float", @"kdlThetaDeg", 1, offsetof(RandomDots, kdlThetaDeg)},\
	{@"float", @"patchRadiusDeg", 1, offsetof(RandomDots, patchRadiusDeg)},\
	{@"float", @"speedDPS", 1, offsetof(RandomDots, speedDPS)},\
	{@"float", @"stepCoherencePC", 1, offsetof(RandomDots, stepCoherencePC)},\
	{@"double", @"backgroundColor.red", 1, offsetof(RandomDots, backgroundColor.red)},\
	{@"double", @"backgroundColor.green", 1, offsetof(RandomDots, backgroundColor.green)},\
	{@"double", @"backgroundColor.blue", 1, offsetof(RandomDots, backgroundColor.blue)},\
	{@"double", @"dotColor.red", 1, offsetof(RandomDots, dotColor.red)},\
	{@"double", @"dotColor.green", 1, offsetof(RandomDots, dotColor.green)},\
	{@"double", @"dotColor.blue", 1, offsetof(RandomDots, dotColor.blue)},\
	{nil}}

@interface LLRandomDots : LLVisualStimulus {

	RandomDots		baseDots;						// dot values saved
	GLfloat			circularImage[kRDImagePix][kRDImagePix];
	GLuint			circularTexture;
	NSArray			*coherenceFunction;				// array of NSPoints giving coherence (x = timeMS y = cohPC)
	long			currentFrame;
	float			dotWidthDeg;					// width movie dots
	DisplayParam	display;
	RandomDots		dots;							// dot values to draw
	float			fieldWidthDeg;					// width of square movie dot field (larger than patch)
	NSMutableArray  *frameList;
	RGBDouble		oldBackgroundColor;
	float			oldDotDiameterDeg;
	float			oldPatchRadiusDeg;
	float			oldSpeedDPS;
}

- (void)doInitialization;
- (RandomDots *)dotsData;
- (void)drawFrame:(long)frame;
- (void)dumpFrame:(long)frame;
- (id)initWithDisplay:(DisplayParam)newDisplay;
- (void)makeCircularTexture;
- (void)makeMovie:(long)durationMS;
- (long)movieFrames;
- (long)randomSeed;
- (void)restore;
- (void)setAntialias:(BOOL)antialias;
- (void)setAzimuthDeg:(float)aziDeg;
- (void)setAzimuthDeg:(float)aziDeg elevationDeg:(double)eleDeg;
- (void)setBackgroundColorRed:(double)red green:(double)green blue:(double)blue; 
- (void)setCoherencePC:(float)newCoherence;
- (void)setDensity:(float)newDensity;
- (void)setCoherenceFunction:(NSArray *)function;
- (void)setContrastPC:(float)newDotContrast;
- (void)setDirectionDeg:(float)newOri;
- (void)setDisplay:(DisplayParam)displayP;
- (void)setDotColorRed:(double)red green:(double)green blue:(double)blue; 
- (void)setDotDiameterDeg:(float)newDotDiameter;
- (void)setElevationDeg:(float)eleDeg;
- (void)setKdlTheta:(float)newKdltheta;
- (void)setKdlPhi:(float)newKdlphi;
- (void)setLifeFrames:(long)newLife;
- (void)setPatchRadiusDeg:(float)newRadius;
- (void)setSpeedDPS:(float)newSpeed;
- (void)store;

@end

