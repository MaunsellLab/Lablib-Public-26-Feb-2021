//
// LLGabor.m
// Experiment
//
// Created by John Maunsell & Geoff Ghose on Sat Feb 15 2003.
// Copyright (c) 2003. All rights reserved.
//
// Comments below describe modifications and OpenGL implementation
// details.

// Important note: ATI driver bug can screw up Gabors.
// Updating OS X from 10.2 to 10.3.1 seems to fix the problem. The symptom is that the background color
// of the square containing the Gabor is black instead of mean-level gray.
//
// Gabor rendering (see draw):
// 1. One-dimension cycles (sine, triangle, & square), a 2-D Gaussian, and a 2-D circular aperture are
//		computed (make* methods) in [LLGabor init].
// 2. The 1-D cycle (sine, triangle or square) is mapped along RGB color space 
//		[LLGabor updateCycleTexture]
// 3. This cycle is applied to 2-D space using spatial phase, frequency and position 
//		[LLGabor drawTextures]
// 4. The Gaussian envelope is applied according to the desired sigma 
//		and position [LLGabor drawTextures].
// 5. The circular aperture is applied according to the desired radius 
//		and position ([LLGabor drawTextures] or [LLGabor drawCircle]).

// To maximize performance the components of the gabor can be encapsulated in an OpenGL
// display lists by the method makeDisplayLists. makeDisplayLists would typically be called
// at the beginning of a trial, before frame-by-frame updating so that the display
// lists are created well in advance of their invoking.

// If makeDisplayLists is not called, no display lists are created, and
// each draw will call OpenGL code in "immediate" mode.  If display lists are
// created, the list for each component of the l be used if the relevant gabor parameters 
// have not changed since it was created.  If relevant gabor parameters have changed, the draw 
// will be done in "immediate" mode.  There are separate display lists for color, texture and circle.  
// These are used independently, so, for example, if you wanted to modulate color frame by frame, the 
// color would be done in "immediate" mode, but the textures and circle could be done using their 
// display lists.

// Each instance of LLGabor has display lists associated with a particular
// display. Display specific information is used in mapping to color space and
// temporal updating. A single Gabor can not therefore span multiple displays.

// If many copies of a single Gabor need to be rendered, you can construct a display list for
// an entire LLGabor. You would do this by glNewList .... [gabor draw] glEndList. This should
// also work if you've already done a makeDisplayLists since nested display lists are
// supported.

// Temporal updating can be done by the setFrame method. Three types of updating
// are available: counterphase, drift, and random. Updating can be applied to any
// circular parameter: spatial phase, direction, and kdl angles. Note that the order
// of messages to Gabor can be critical. For example, if you want to suddenly change
// the contrast of a Gabor that has been setup for counter-phasing (which affects
// contrast) that the setContrast message must follow the setFrame message.
// Also note that setFrame need not be called at all: all temporal changes can be
// accomplished by manually setting parameters. Note that setFrame takes an object so
// as to ease the simultaneous updating of an array of Gabors.

// Multitexturing is used speed things up. Profiling reveals that the vertex operations
// (glBegin.. glEnd) are very expensive, and multitexturing allows a single set of 
// glBegin and glEnd to apply to all textures (sine, Gaussian and circle).
// Unfortunately,some OpenGL implementations have only 2 texture units (e.g, the
// 12" Powerbook NVidia).  On the other hand, the ATI 9800 has 8. If it exists, the third 
// texture unit is used for the circular aperature (circleTexture). When only 2 texture 
// units are available, this texture is not applied in the methods drawTextures, and a 
// subsequent call to drawCircle is done in the draw method if necessary.

// To optimize texture transfers several Apple specific optimizations are used:
// For VRAM texturing:
//    glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, 1);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
// before glTexImage.  This probably isn't a big deal because the textures are 
// only created at the first Gabor initialization, but it should help with startup time. 

// glTexImage calls are quite expensive in terms of time. The 2D textures (Gaussian and circle) 
// are only generated once and never need to be modified. However, the 1D texture might
// need to be modified every frame (e.g., contrast or color changes), which can be very costly. 
// To avoid redefining the 1D texture, glTexImage1D is called only once during initialization 
// and subsequent updating of the texture is done with glTexSubImage1D. The savings are enormous: 
// on a GeForce 4 the average glTeXImage1D was 152 us while the average glTexSubImage1D is 35 us.
// For some reason the Apple optimization glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, 1) screws things
// up (The pixel transfers are not applied correctly with SubImage but they are with TexImage).
// Thank you Apple!!!!!

// GMG 05/05
// Modified so that list of active gabor variables is stored within a Gabor data structure (gabor).
// Moved numTextureUnits out of Gabor object and made a class variable.
// Made statics globals so that subclasses (LLNoise) can use
// Cleaned up drawTexturesGL and drawCircleGL code (vertex loops)
// Contrast now goes from -1 to 1 to allow straight-forward counter-phasing
// makeDisplayLists now also sets baseGabor

#import "LLGabor.h"
#import "LLTextUtil.h"
#import "LLMultiplierTransformer.h"

#define glMultiTexCoord2f	glMultiTexCoord2fARB
#define glMultiTexCoord2fv	glMultiTexCoord2fvARB
#define glActiveTexture		glActiveTextureARB
#define kCyclePix			256						// must be a power of 2
#define kGaussianImagePix   256						// must be a power of 2

// The following are declared as class variables, because the same textures can be used to 
// draw all the instances of LLGabor.  lastGabor keeps track of the texture variables
// of the last Gabor that was drawn.  displayListGabor keeps track of the variables
// that were used to make the display lists.

GLuint			circularTexture = nil;
GLuint			cycleTexture = nil;
GLuint			gaussianTexture = nil;
static Gabor	lastGabor = {};
GLint			numTextureUnits = 0;
static GLubyte	sinImage[kCyclePix];
static GLubyte	triImage[kCyclePix];
static GLubyte	squareImage[kCyclePix];

NSString *LLGaborAzimuthDegKey;
NSString *LLGaborBackColorKey;
NSString *LLGaborDirectionDegKey;
NSString *LLGaborElevationDegKey;
NSString *LLGaborForeColorKey;
NSString *LLGaborKdlThetaDegKey;
NSString *LLGaborKdlPhiDegKey;
NSString *LLGaborRadiusDegKey;

NSString *LLGaborContrastKey = @"contrast";
NSString *LLGaborSpatialFreqCPDKey = @"spatialFreqCPD";
NSString *LLGaborSigmaDegKey = @"sigmaDeg";
NSString *LLGaborSpatialModulationKey = @"spatialModulation";
NSString *LLGaborSpatialPhaseDegKey = @"spatialPhaseDeg";
NSString *LLGaborTemporalFreqHzKey = @"temporalFreqHz";
NSString *LLGaborTemporalModulationKey = @"temporalModulation";
NSString *LLGaborTemporalModulationParamKey = @"temporalModulationParam";
NSString *LLGaborTemporalPhaseDegKey = @"temporalPhaseDeg";

@implementation LLGabor

- (float)contrast;
{
	return contrast;
}

- (void)dealloc;
{
    if (displayListNum > 0) {
        glDeleteLists(displayListNum, kDrawCircle + 1);
	}
	[super dealloc];					// super will take care of unbinding keys, if needed
}

// Do setFrame without being key-value compliant.  Changes will not be reflected by observers (defaults, dialog, etc).
// This runs faster than setFrame because no observers are notified of changes to the gabor values.

- (void)directSetFrame:(NSNumber *)frameNumber;
{
    long framesPerHalfCycle, cycles, frame;
	float frameRateHz;
    float *currentPhase = &spatialPhaseDeg;
		
	frame = [frameNumber longValue];
	frameRateHz = (displays == nil) ? 60.0 : [displays frameRateHz:displayIndex];
	if (temporalFreqHz > 0.0 && frameRateHz > 0.0) {
		framesPerHalfCycle = frameRateHz / temporalFreqHz / 2.0;
		switch (temporalModulationParam) {
			case kDirection:
				currentPhase = &directionDeg;
				break;
			case kKdlTheta:
				currentPhase = &kdlThetaDeg;
				break;
			case kKdlPhi:
				currentPhase = &kdlPhiDeg;
				break;
			case kSPhase:
			default:
				currentPhase = &spatialPhaseDeg;
				break;
		}
		switch (temporalModulation) {
			case kDrifting:
				*currentPhase = temporalPhaseDeg + (double)frame / framesPerHalfCycle * 180.0;
				break;
			case kRandom:
				if ((frame % framesPerHalfCycle) == 0) {
					*currentPhase = (rand() % 360);
				}
				break;
			case kCounterPhase:
			default:
				contrast = baseGabor.contrast *
						sin(frame / (double)framesPerHalfCycle * kPI + temporalPhaseDeg * kRadiansPerDeg);
				break;
		}
	}
	cycles = floor(*currentPhase / 360.0);
	*currentPhase -= cycles * 360.0;
}

- (void)draw;
{
    [self updateCycleTexture];
	circleMask = (radiusDeg < kRadiusLimitSigma * sigmaDeg);
	[self drawTextures];

// We need to draw a limiting circle only if the gaussian did not get to radiusDeg.
// drawTexture will draw the circle if there are 3 texture Units, so we call drawCircile
// only if there are fewer. circleMask determines whether a circular mask is even
// necessary or not.

    if (circleMask && (numTextureUnits < 3)) {
        [self drawCircle];
	}
	[self loadGabor:&lastGabor];
}

- (NSString *)description;
{
    return[NSString stringWithFormat:@"\n\tLLGabor (0x%x): Az = %.1f, El = %.1f\n\tDir = %.1f Cont = %.2f\n\
\tRad = %.1f, Sig = %.1f, SF = %.1f\n\tKdl = %.1f, %.1f",
        self, azimuthDeg, elevationDeg, directionDeg, contrast, radiusDeg, 
		sigmaDeg, spatialFreqCPD, kdlThetaDeg, kdlPhiDeg];
}

- (void)drawCircle;
{
    if (displayListNum > 0 && azimuthDeg == displayListGabor.azimuthDeg &&
        elevationDeg == displayListGabor.elevationDeg && 
		radiusDeg == displayListGabor.radiusDeg) {
			glCallList(displayListNum + kDrawCircle);		// use display list if valid one exists
	}
    else {
        [self drawCircleGL];								// else draw in immediate mode
	}
}

// only called when there are a limited number of texture units so we
// have to reuse a texture unit
// If you try to reuse Texture Unit 0, it's a disaster (probably because it's a different size)
// However, we can get away with reusing Texture Unit 1. 

- (void)drawCircleGL;
{
	long index;
	
    glActiveTexture(GL_TEXTURE1_ARB);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, circularTexture);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND);
    glBegin(GL_QUADS);
    for (index = 0; index < 4; index++) {			// vertices of the complete gabor
		glMultiTexCoord2f(GL_TEXTURE1_ARB, (float)(index / 2), (float) (((index + 1) / 2) % 2));
		glVertex2fv(&vertices[index * 2]);
	}
    glEnd();
    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);
}

- (void) drawTextures;
{
    if (displayListNum > 0 && radiusDeg == displayListGabor.radiusDeg &&
							sigmaDeg == displayListGabor.sigmaDeg &&
							azimuthDeg == displayListGabor.azimuthDeg &&
							elevationDeg == displayListGabor.elevationDeg &&
							spatialFreqCPD == displayListGabor.spatialFreqCPD &&
							spatialPhaseDeg == displayListGabor.spatialPhaseDeg &&
							directionDeg == displayListGabor.directionDeg) {
		glCallList(displayListNum + kDrawTextures);			// use display list if valid one exists
	}
    else {
        [self drawTexturesGL];									// else draw in immediate mode
	}
}

- (void)drawTexturesGL;
{
    short i;
    float corner, texCorners[5], phases[4], x, y;
    double radiusPeriods, sinRadius, cosRadius, phaseOffset, directionRad, limitedRadiusDeg;
     
	limitedRadiusDeg = MIN(radiusDeg, kRadiusLimitSigma * sigmaDeg);
    radiusPeriods = limitedRadiusDeg * spatialFreqCPD;
	directionRad = directionDeg * kRadiansPerDeg;
	sinRadius = radiusPeriods * sin(directionRad);
    cosRadius = radiusPeriods * cos(directionRad);
    phaseOffset = spatialPhaseDeg / 360.0;
    corner = limitedRadiusDeg / sigmaDeg / (kRadiusLimitSigma * 2.00);
	for (i = 0; i < 4; i++) {					// vertices of the complete gabor
		x = (float)((i / 2) * 2 - 1);
		y = (float)((((i + 1) / 2) % 2) * 2 - 1);
		vertices[i * 2] = azimuthDeg + x * limitedRadiusDeg;
		vertices[i * 2 + 1] = elevationDeg + y * limitedRadiusDeg;
		phases[i] = phaseOffset + x * cosRadius + y * sinRadius;    
        texCorners[i] = 0.5 + (((i % 4) / 2) * 2 - 1) * corner;
	}
	texCorners[4] = texCorners[0];

// Bind each texture to a texture unit

    glActiveTexture(GL_TEXTURE0_ARB);				// activate texture unit 0 and cycle texture 
    glEnable(GL_TEXTURE_1D);						
    glBindTexture(GL_TEXTURE_1D, cycleTexture);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE); // replace mode

    glActiveTexture(GL_TEXTURE1_ARB);				// activate texture unit 1 and gaussian texture
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, gaussianTexture);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);   // decal mode
	
    if (circleMask && (numTextureUnits > 2)) {
        glActiveTexture(GL_TEXTURE2_ARB);			// activate texture unit 2 and circle texture
        glEnable(GL_TEXTURE_2D);
        glBindTexture(GL_TEXTURE_2D, circularTexture);
        glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL); // decal mode
    }
	
// Assign the vertex coordinate to each of the textures
    
    glBegin(GL_QUADS);
	for(i = 0; i < 4; i++) {
		glMultiTexCoord1f(GL_TEXTURE0_ARB, phases[i]); 
		glMultiTexCoord2fv(GL_TEXTURE1_ARB, &texCorners[i]);
		
		if (circleMask && (numTextureUnits > 2)) {
			glMultiTexCoord2f(GL_TEXTURE2_ARB, (float)(i/2), (float)(((i+1)/2)%2));
		}
		glVertex2fv(&vertices[i*2]);
	}
    glEnd();
    
    if (circleMask && (numTextureUnits > 2)) {
        glActiveTexture(GL_TEXTURE2_ARB);
        glDisable(GL_TEXTURE_2D);
    }
    glActiveTexture(GL_TEXTURE1_ARB);
    glDisable(GL_TEXTURE_2D);
    glActiveTexture(GL_TEXTURE0_ARB);		// Do texture unit 0 last, so we leave it active (for other tasks)
    glDisable(GL_TEXTURE_1D);
}

- (Gabor *)gaborData;
{
	[self loadGabor:&gabor];
	return &gabor;
}

- (id)init;
{
	LLMultiplierTransformer *transformPC;
	GLuint	allTextures[3] = {};
	
    if ((self = [super init]) != nil) {

// Set the default values.  Do not use -set*, because that will overwrite the defaults settings.
// If we do this directly here, the value will be updated if there are default values.

		contrast = 1.0;											// default gabor parameters
		directionDeg = 45.0;
		radiusDeg = 4.0;
		spatialPhaseDeg = 0.0;
		spatialFreqCPD = 1.0;
		temporalFreqHz = 0.0;
		sigmaDeg = 0.5;
		radiusDeg = 1.5;
		spatialModulation = kSineModulation;
		temporalModulation = kDrifting;
		temporalModulationParam = kSPhase;
		kdlThetaDeg = 90.0;
		kdlPhiDeg = 0.0;
		
		displayListNum = 0;										// no display lists yet
		glClearColor(0.5, 0.5, 0.5, 1.0);						// set the background color
		glShadeModel(GL_FLAT);									// flat shading
		if (numTextureUnits == 0) {
			glGetIntegerv(GL_MAX_TEXTURE_UNITS, &numTextureUnits);
		}
		
// only need to generate textures once for all gabors

		if (!cycleTexture) {
			glGenTextures(3, allTextures);
			cycleTexture = allTextures[0];
			gaussianTexture = allTextures[1];
			circularTexture = allTextures[2];
			[self makeCycleTexture];
			[self makeGaussianTexture];
			[self makeCircularTexture];
		}
	
// Provide convenient access to keys declared in LLVisualStimulus

		LLGaborAzimuthDegKey = LLAzimuthDegKey;
		LLGaborBackColorKey = LLBackColorKey;
		LLGaborDirectionDegKey = LLDirectionDegKey;
		LLGaborElevationDegKey = LLElevationDegKey;
		LLGaborForeColorKey = LLForeColorKey;
		LLGaborKdlThetaDegKey = LLKdlThetaDegKey;
		LLGaborKdlPhiDegKey = LLKdlPhiDegKey;
		LLGaborRadiusDegKey = LLRadiusDegKey;

		stimPrefix = @"Gabor";					// make our keys different from other LLVisualStimuli
		[keys addObjectsFromArray:[NSArray arrayWithObjects:LLGaborContrastKey,
				LLGaborSpatialFreqCPDKey, LLGaborSigmaDegKey, LLGaborSpatialModulationKey, 
				LLGaborSpatialPhaseDegKey, LLGaborTemporalFreqHzKey, LLGaborTemporalModulationKey, 
				LLGaborTemporalModulationParamKey, LLGaborTemporalPhaseDegKey, nil]];
		if (![NSValueTransformer valueTransformerForName:@"MultiplierTransformer"]) {
			transformPC = [[[LLMultiplierTransformer alloc] init] autorelease];;
			[transformPC setMultiplier:100.0];
			[NSValueTransformer setValueTransformer:transformPC forName:@"MultiplierTransformer"];
		}
	}
    return self; 
}

// Load a gabor structure with the current settings

- (void)loadGabor:(Gabor *)pGabor;
{
	pGabor->azimuthDeg = azimuthDeg;							// Center of gabor 
	pGabor->contrast = contrast;								// Contrast [0:pGabor->1]
	pGabor->directionDeg = directionDeg;						// Direction
	pGabor->elevationDeg = elevationDeg;						// Center of gabor 
	pGabor->kdlThetaDeg = kdlThetaDeg;							// kdl space (deg)
	pGabor->kdlPhiDeg = kdlPhiDeg;								// kdl space (deg)
	pGabor->radiusDeg = radiusDeg;								// Radius of drawing
	pGabor->sigmaDeg = sigmaDeg;								// Gabor standard deviation
	pGabor->spatialFreqCPD = spatialFreqCPD;					// Spatial frequency
	pGabor->spatialModulation = spatialModulation;				// Spatial Modulation:pGabor-> SINE, SQUARE, TRIANGLE
	pGabor->spatialPhaseDeg = spatialPhaseDeg;					// Spatial Phase
	pGabor->temporalFreqHz = temporalFreqHz;					// Temporal frequency
	pGabor->temporalModulationParam = temporalModulationParam;	// Parameter modulated in time
	pGabor->temporalModulation = temporalModulation;			// Temporal Modulation:baseGabor. COUNTERPHASE, DRIFTING
	pGabor->temporalPhaseDeg = temporalPhaseDeg;				// Temporal Phase
}

// Make a circular texture that will be used to set the contrast of the Gabor

- (void) makeCircularTexture;
{
    GLfloat circularImage[kGaussianImagePix][kGaussianImagePix];
    long x, y, halfWidth, halfWidthSqr, squared;
    short xside, yside;
    double g;
    
    halfWidth = kGaussianImagePix / 2;
    halfWidthSqr = halfWidth * halfWidth;
    for (x = 0; x < halfWidth; x++) {
        for (y = 0; y < halfWidth; y++) {
            squared = x * x + y * y;
            g = (squared < halfWidthSqr) ? 0 : 1;
            for (xside = -1; xside < 2; xside += 2) {
				for (yside = -1; yside < 2; yside += 2) {
					circularImage[halfWidth + x * xside][halfWidth + y * yside] = g;
				}
			}
        }
        squared = x * x + halfWidth * halfWidth;
        g = (squared < halfWidthSqr) ? 0 : 1;
        for (xside = -1; xside < 2; xside += 2) {
            circularImage[0][halfWidth + x * xside] = g;
            circularImage[halfWidth + x * xside][0] = g;
        }
    }
    glBindTexture(GL_TEXTURE_2D, circularTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
    glPixelTransferf(GL_RED_BIAS, 0.5);
    glPixelTransferf(GL_GREEN_BIAS, 0.5);
    glPixelTransferf(GL_BLUE_BIAS, 0.5);
    glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, kGaussianImagePix, kGaussianImagePix, 
                0, GL_ALPHA, GL_FLOAT, circularImage);
}

- (void) makeCycleTexture;
{
    short x, c;
    
    for (x = 0; x < kCyclePix; x++) {
        c = (GLubyte)(sin(k2PI / kCyclePix * x) * 127.0 + 127.0);
		sinImage[x] = (GLubyte)c;
	}
    for (x = 0; x < kCyclePix; x++) {
        if (x < kCyclePix / 2) {
            squareImage[x] = 0;
        }
        else {
            squareImage[x] = 255;
		}
    }
    for (x = 0; x <= kCyclePix / 4; x++) {
        triImage[x] = triImage[kCyclePix / 2 - x] = (float)x / (kCyclePix / 4) * 127.0 + 127.0;
        triImage[kCyclePix / 2 + x] = 255 - triImage[x];
        if (x > 0) {
			triImage[kCyclePix - x] = triImage[kCyclePix / 2 + x];
		}
    }         
    glEnable(GL_TEXTURE_1D);							// had this enable/disable commented out 050617
    glBindTexture(GL_TEXTURE_1D, cycleTexture);
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_1D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexImage1D(GL_TEXTURE_1D, 0, GL_RGB, kCyclePix, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, sinImage);
    glDisable(GL_TEXTURE_1D);     
}

- (void)makeDisplayLists;
{
	[self loadGabor:&displayListGabor];
	[self store];
    
// if no display lists then generate, otherwise overwrite

    if (displayListNum == 0) {
		displayListNum = glGenLists(kDrawTypes);
	}
	circleMask = (radiusDeg < kRadiusLimitSigma * sigmaDeg);
    glNewList(displayListNum + kDrawColor, GL_COMPILE);				// compile drawlist for color
    [self updateCycleTextureGL];
    glEndList();
    glNewList(displayListNum + kDrawTextures, GL_COMPILE);			// compile drawlist for textures
    [self drawTexturesGL];
    glEndList();
    glNewList(displayListNum + kDrawCircle, GL_COMPILE);			// compile drawlist for circle
    [self drawCircleGL];
    glEndList();
}

// Make a Gaussian texture that will give the Gaussian contrast profile to the Gabor

- (void)makeGaussianTexture;
{
    GLfloat gaussianImage[kGaussianImagePix][kGaussianImagePix];
    long x, xc, y, halfWidth, squared, sigma, term1;
    short xside, yside;
    double g;
	
    halfWidth = kGaussianImagePix / 2;
	sigma = halfWidth / kRadiusLimitSigma;
	term1 = -2 * sigma * sigma;
	for (x = 0; x < halfWidth; x++) {
        for (xside = -1; xside < 2; xside += 2) {
            xc = halfWidth + x * xside;
            for (y = 0; y < halfWidth; y++) {
                squared = x * x + y * y;
                g = exp((double)squared / (double)term1);    
                for (yside = -1; yside < 2; yside += 2) {
                    gaussianImage[xc][halfWidth + y * yside] = 1 - g;
				}
            }
        }
        squared = halfWidth * halfWidth + x * x;		// clean up the edges
        g = exp((double)squared/(double)term1);
        for (xside = -1; xside < 2; xside += 2) {
            gaussianImage[0][halfWidth + x * xside] = 1 - g;
            gaussianImage[halfWidth + x * xside][0] = 1 - g;   
        }
    }
	glBindTexture(GL_TEXTURE_2D, gaussianTexture);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
	glPixelTransferf(GL_RED_BIAS, 0.5);
	glPixelTransferf(GL_GREEN_BIAS, 0.5);
	glPixelTransferf(GL_BLUE_BIAS, 0.5);
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, 1);
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, kGaussianImagePix, kGaussianImagePix, 
	                 0, GL_ALPHA, GL_FLOAT, gaussianImage);
}

- (void)restore;
{
	[self setGaborData:baseGabor];
}

- (void)runSettingsDialog;
{
	if (dialogWindow == nil) {
		[NSBundle loadNibNamed:@"LLGabor" owner:self];
		if (taskPrefix != nil) {
			[dialogWindow setTitle:[NSString stringWithFormat:@"%@ Gabor", taskPrefix]];
		}
	}
	[dialogWindow makeKeyAndOrderFront:self];
}

- (void)setContrast:(float)newContrast;
{
    contrast = MIN(newContrast, 1.0);
	[self updateFloatDefault:contrast key:LLGaborContrastKey];
}

// Advance the gabor one time interval (for counterphase, drifting, etc)

- (void)setFrame:(NSNumber *)frameNumber;
{
    long framesPerHalfCycle, frame;
	float frameRateHz;
		
	frame = [frameNumber longValue];
	frameRateHz = (displays == nil) ? 60.0 : [displays frameRateHz:displayIndex];
	if (temporalFreqHz > 0.0 && frameRateHz > 0.0) {
		framesPerHalfCycle = frameRateHz / temporalFreqHz / 2.0;
		switch (temporalModulation) {
			case kDrifting:
				[self setPhaseDeg:(temporalPhaseDeg + (double)frame / framesPerHalfCycle * 180.0)];
				break;
			case kRandom:
				if ((frame % framesPerHalfCycle) == 0) {
					[self setPhaseDeg:(rand() % 360)];
				}
				break;
			case kCounterPhase:
			default:
				[self setContrast:(baseGabor.contrast *
						sin(frame / (double)framesPerHalfCycle * kPI + temporalPhaseDeg * kRadiansPerDeg))];
				break;
		}
	}
}

- (void)setGaborData:(Gabor)g;
{
	[self setAzimuthDeg:g.azimuthDeg];								// Center of gabor 
	[self setContrast:g.contrast];									// Contrast [0:g.1]
	[self setDirectionDeg:g.directionDeg];							// Direction
	[self setElevationDeg:g.elevationDeg];							// Center of gabor 
	[self setKdlThetaDeg:g.kdlThetaDeg];							// kdl space (deg)
	[self setKdlPhiDeg:g.kdlPhiDeg];								// kdl space (deg)
	[self setRadiusDeg:g.radiusDeg];								// Radius of drawing
	[self setSigmaDeg:g.sigmaDeg];									// Gabor standard deviation
	[self setSpatialFreqCPD:g.spatialFreqCPD];						// Spatial frequency
	[self setSpatialModulation:g.spatialModulation];				// Spatial Modulation:g. SINE, SQUARE, TRIANGLE
	[self setSpatialPhaseDeg:g.spatialPhaseDeg];					// Spatial Phase
	[self setTemporalFreqHz:g.temporalFreqHz];						// Temporal frequency
	[self setTemporalModulationParam:g.temporalModulationParam];	// Parameter modulated in time
	[self setTemporalModulation:g.temporalModulation];				// Temporal Modulation:g. COUNTERPHASE, DRIFTING
	[self setTemporalPhaseDeg:g.temporalPhaseDeg];					// Temporal Phase
}

// Advance the phase of the currently active temporal modulation type (called by setFrame)

- (void)setPhaseDeg:(float)newPhaseDeg;
{
	newPhaseDeg -= floor(newPhaseDeg / 360.0) * 360.0;					// limit to first cycle
	switch (temporalModulationParam) {
		case kDirection:
			[self setDirectionDeg:newPhaseDeg];
			break;
		case kKdlTheta:
			[self setKdlThetaDeg:newPhaseDeg];
			break;
		case kKdlPhi:
			[self setKdlPhiDeg:newPhaseDeg];
			break;
		case kSPhase:
		default:
			[self setSpatialPhaseDeg:newPhaseDeg];
			break;
	}
}

- (void)setSpatialFreqCPD:(float)newSF;
{
    spatialFreqCPD = newSF;
	[self updateFloatDefault:spatialFreqCPD key:LLGaborSpatialFreqCPDKey];
}

- (void)setSigmaDeg:(float)newSigma;
{
    sigmaDeg = newSigma;
	[self updateFloatDefault:sigmaDeg key:LLGaborSigmaDegKey];
}

- (void)setSpatialPhaseDeg:(float)newSPhase;
{
    spatialPhaseDeg = newSPhase;
	[self updateFloatDefault:spatialPhaseDeg key:LLGaborSpatialPhaseDegKey];
}

- (void)setSpatialModulation:(long)newSMod;
{
    spatialModulation = newSMod;
	[self updateIntegerDefault:spatialModulation key:LLGaborSpatialModulationKey];
}

- (void)setTemporalFreqHz:(float)newTF;
{
    temporalFreqHz = newTF;
	[self updateFloatDefault:temporalFreqHz key:LLGaborTemporalFreqHzKey];
}

- (void)setTemporalModulation:(long)newTMod;
{
    temporalModulation = newTMod;
	[self updateIntegerDefault:temporalModulation key:LLGaborTemporalModulationKey];
}

- (void)setTemporalModulationParam:(long)newTParam;
{
    temporalModulationParam = newTParam;
	[self updateIntegerDefault:temporalModulationParam key:LLGaborTemporalModulationParamKey];
}

- (void)setTemporalPhaseDeg:(float)newTPhase;
{
    temporalPhaseDeg = newTPhase;
	[self updateFloatDefault:temporalPhaseDeg key:LLGaborTemporalPhaseDegKey];
}

- (float)spatialFreqCPD;
{
	return spatialFreqCPD;
}

- (float)sigmaDeg;
{
	return sigmaDeg;
}

- (float)spatialPhaseDeg;
{
	return spatialPhaseDeg;
}

- (long)spatialModulation;
{
	return spatialModulation;
}

- (void)store;
{
	[self loadGabor:&baseGabor];
}

- (float)temporalFreqHz;
{
	return temporalFreqHz;
}

- (long)temporalModulation;
{
	return temporalModulation;
}

- (long)temporalModulationParam;
{
	return temporalModulationParam;
}

- (float)temporalPhaseDeg;
{
	return temporalPhaseDeg;
}

// Only change the 1D cycle texture if necessary. For example, drifting gratings won't require a change.
	
- (void)updateCycleTexture;
{
	if (contrast != lastGabor.contrast || kdlThetaDeg != lastGabor.kdlThetaDeg ||
					kdlPhiDeg != lastGabor.kdlPhiDeg || 
					spatialModulation != lastGabor.spatialModulation) {
		if (displayListNum > 0 && contrast == displayListGabor.contrast &&
								kdlThetaDeg == displayListGabor.kdlThetaDeg &&
								kdlPhiDeg == displayListGabor.kdlPhiDeg &&
								spatialModulation == displayListGabor.spatialModulation) {
			glCallList(displayListNum + kDrawColor);					// use display list if valid one exists
		}
		else {
			[self updateCycleTextureGL];								// else draw in immediate mode
		}
	}
}

- (void)updateCycleTextureGL;
{
    RGBDouble rgb;
	
	if (displays == nil) {
		return;
	}
	rgb = [displays RGB:displayIndex kdlTheta:kdlThetaDeg kdlPhi:kdlPhiDeg];
    rgb.red *= contrast;
    rgb.green *= contrast;
    rgb.blue *= contrast;

// convert RGBColor [-1 1] to OpenGL RGB [0 1]  

    glEnable(GL_TEXTURE_1D);
    glBindTexture(GL_TEXTURE_1D, cycleTexture);	
    glPixelTransferf(GL_RED_BIAS, 0.5 - rgb.red / 2.0);
    glPixelTransferf(GL_GREEN_BIAS, 0.5 - rgb.green / 2.0);
    glPixelTransferf(GL_BLUE_BIAS, 0.5 - rgb.blue / 2.0);
    glPixelTransferf(GL_RED_SCALE, rgb.red);
    glPixelTransferf(GL_GREEN_SCALE, rgb.green);
    glPixelTransferf(GL_BLUE_SCALE, rgb.blue);
	
    switch (spatialModulation) {
        case kSquareModulation:
			glTexSubImage1D(GL_TEXTURE_1D, 0, 0, kCyclePix, GL_LUMINANCE, GL_UNSIGNED_BYTE, squareImage);
            break;
        case kTriangleModulation:
			glTexSubImage1D(GL_TEXTURE_1D, 0, 0, kCyclePix, GL_LUMINANCE, GL_UNSIGNED_BYTE, triImage);
            break;
        case kSineModulation:
		default:
			glTexSubImage1D(GL_TEXTURE_1D, 0, 0, kCyclePix, GL_LUMINANCE, GL_UNSIGNED_BYTE, sinImage);
            break;
    }   
    glDisable(GL_TEXTURE_1D);     
}

@end

