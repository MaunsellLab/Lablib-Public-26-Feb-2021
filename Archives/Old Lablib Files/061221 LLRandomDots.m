//
// LLRandomDots.m
//
// Created by John Maunsell Thu June 10 2004.
// Copyright (c) 2004-2006. All rights reserved.
//

#import "LLRandomDots.h"
#import "LLMultiplierTransformer.h"

// The DotDesc structure maintains information about a dot.  The actual position of the dot
// is kept in a parallel structure for convenience in creating movie frames.

typedef struct {
	long	directionDeg;							// used as an index to direction increments
	long	age;									// age in frames
	BOOL	coherent;								// member of cohernent group?
} DotDesc;

u_long  LLGetRandomSeed(void);
u_long  LLRandom(void);
void	LLSeedRandom(u_long seed);

NSString *LLRandomDotsAzimuthDegKey;
NSString *LLRandomDotsBackColorKey;
NSString *LLRandomDotsDirectionDegKey;
NSString *LLRandomDotsElevationDegKey;
NSString *LLRandomDotsForeColorKey;
NSString *LLRandomDotsKdlThetaDegKey;
NSString *LLRandomDotsKdlPhiDegKey;
NSString *LLRandomDotsRadiusDegKey;


NSString *LLRandomDotsAntialiasKey = @"antialias";
NSString *LLRandomDotsCoherenceKey = @"coherence";
NSString *LLRandomDotsDensityKey = @"density";
NSString *LLRandomDotsDotContrastKey = @"dotContrast";
NSString *LLRandomDotsDotDiameterDegKey = @"dotDiameterDeg";
NSString *LLRandomDotsLifeFramesKey = @"lifeFrames";
NSString *LLRandomDotsRandomSeedKey = @"randomSeed";
NSString *LLRandomDotsSpeedDPSKey = @"speedDPS";

@implementation LLRandomDots

- (void)dealloc;
 {
	[frameList release];
	[coherenceFunction release];
	[super dealloc];					// super will take care of unbinding keys, if needed
}

- (float)density;
{
	return density;
}

- (NSString *)description {

    return[NSString stringWithFormat:@"\tAzi = %f, Ele = %f, Diam = %f\n\
						Dir: %f, Speed: %f, Coherence: %f", azimuthDeg, elevationDeg, radiusDeg, 
						directionDeg, speedDPS, coherence];
}

- (float)dotContrast;
{
	return dotContrast;
}

- (RandomDots *)dotsData;
{
	[self loadDots:&dots];
	return &dots;
}

- (float)dotDiameterDeg;
{
	return dotDiameterDeg;
}

- (void)draw;
{	
	long index;
	GLenum errCode;
	GLfloat vertices[8];
	NSData *frameData;
	
	if (currentFrame >= [frameList count]) {
		return;
	}
	glPushMatrix();

// Draw the dots

	glColor3f([foreColor redComponent] * dotContrast, 
					[foreColor greenComponent] * dotContrast, 
					[foreColor blueComponent] * dotContrast);
	glPointSize(dotDiameterDeg * ([displays widthPix:displayIndex] / [displays widthMM:displayIndex]) * 
				([displays distanceMM:displayIndex] * kRadiansPerDeg));
	glEnable(GL_BLEND);
	if (antialias) {
		glEnable(GL_POINT_SMOOTH);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		glHint(GL_POINT_SMOOTH_HINT, GL_FASTEST);
	}
	glTranslatef(azimuthDeg, elevationDeg, 0.0);
	frameData = [frameList objectAtIndex:currentFrame];
	glVertexPointer(2, GL_FLOAT, 0, [frameData bytes]);		// set up the vertex array pointer
	glDrawArrays(GL_POINTS, 0, [frameData length] / sizeof(NSPoint));
	if (antialias) {
		glDisable(GL_POINT_SMOOTH);
	}
	glColor3f(1.0, 1.0, 1.0);							// restore color to white

// Draw the circle that limits the dots

    for (index = 0; index < 4; index++) {
 //       vertices[index * 2] = azimuthDeg + ((index / 2) * 2 - 1) * 
//				(fieldWidthDeg / 2.0 + dotDiameterDeg);
//        vertices[index * 2 + 1] = elevationDeg + ((((index + 1) / 2) % 2) * 2 - 1) *
//				(fieldWidthDeg / 2.0 + dotDiameterDeg);
        vertices[index * 2] = ((index / 2) * 2 - 1) * (fieldWidthDeg / 2.0 + dotDiameterDeg);
        vertices[index * 2 + 1] = ((((index + 1) / 2) % 2) * 2 - 1) * (fieldWidthDeg / 2.0 + dotDiameterDeg);
    }
    glActiveTexture(GL_TEXTURE1_ARB);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, circularTexture);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND);
    glBegin(GL_QUADS);
    glMultiTexCoord2f(GL_TEXTURE1_ARB, 0, 0); 
    glVertex2fv(&vertices[0]);
    glMultiTexCoord2f(GL_TEXTURE1_ARB, 0, 1); 
    glVertex2fv(&vertices[2]);
    glMultiTexCoord2f(GL_TEXTURE1_ARB, 1, 1); 
    glVertex2fv(&vertices[4]);
    glMultiTexCoord2f(GL_TEXTURE1_ARB, 1, 0); 
    glVertex2fv(&vertices[6]);
    glEnd();
	
// Clean up

	glPopMatrix();
    glDisable(GL_TEXTURE_2D);
    glDisable(GL_BLEND);
	if ((errCode = glGetError()) != GL_NO_ERROR) {
        NSLog(@"OpenGL Error drawFrame: %s", gluErrorString(errCode));
    }
	glDisable(GL_BLEND);
}

- (void)drawFrame:(long)frame;
{
	currentFrame = frame;
	[self draw];
}

- (void)dumpFrame:(long)frame;
{
	NSData *frameData;
	long index;
	
	if (frame > [frameList count]) {
		return;
	}
	frameData = [frameList objectAtIndex:frame];
	NSLog(@"Frame %d, %d bytes, length %d", frame, [frameData length], [frameData length] / sizeof(NSPoint));
	for (index = 0; index < [frameData length] / sizeof(NSPoint); index++) {
		NSLog(@"%2d: %.2f %.2f", index, ((NSPoint *)[frameData bytes])[index].x, ((NSPoint *)[frameData bytes])[index].y);
	}
}

- (id)init;
{
	LLMultiplierTransformer *transformPC;

    if ((self = [super init]) != nil) {
		frameList = [[NSMutableArray alloc] init];
		version = 3;
		coherence = dotContrast = 1.0;
		dotDiameterDeg = 0.1;
		radiusDeg = 3.0;
		density = 5.0;
		speedDPS = 5.0;
		lifeFrames = 10;
		stimPrefix = @"Dots";									// keys different from other LLVisualStimuli
		[keys addObjectsFromArray:[NSArray arrayWithObjects:LLRandomDotsAntialiasKey,
				LLRandomDotsCoherenceKey, LLRandomDotsDensityKey, LLRandomDotsDotContrastKey, LLRandomDotsDotDiameterDegKey, LLRandomDotsLifeFramesKey, 
				LLRandomDotsRandomSeedKey, LLRandomDotsSpeedDPSKey, nil]];
	
// Provide convenient access to keys declared in LLVisualStimulus

		LLRandomDotsAzimuthDegKey = LLAzimuthDegKey;
		LLRandomDotsBackColorKey = LLBackColorKey;
		LLRandomDotsDirectionDegKey = LLDirectionDegKey;
		LLRandomDotsElevationDegKey = LLElevationDegKey;
		LLRandomDotsForeColorKey = LLForeColorKey;
		LLRandomDotsKdlThetaDegKey = LLKdlThetaDegKey;
		LLRandomDotsKdlPhiDegKey = LLKdlPhiDegKey;
		LLRandomDotsRadiusDegKey = LLRadiusDegKey;

		if (![NSValueTransformer valueTransformerForName:@"MultiplierTransformer"]) {
			transformPC = [[[LLMultiplierTransformer alloc] init] autorelease];;
			[transformPC setMultiplier:100.0];
			[NSValueTransformer setValueTransformer:transformPC forName:@"MultiplierTransformer"];
		}
	}
    return self; 
}

- (long)lifeFrames;
{
	return lifeFrames;
}

// Load a random dot structure with the current settings

- (void)loadDots:(RandomDots *)pDots;
{
	if (pDots->version != version) {
		return;
	}
	pDots->antialias = antialias;
	pDots->lifeFrames = lifeFrames;
	pDots->randomSeed = randomSeed;
	pDots->azimuthDeg = azimuthDeg;
	pDots->coherence = coherence;
	pDots->density = density;
	pDots->directionDeg = directionDeg;
	pDots->dotContrast = dotContrast;
	pDots->dotDiameterDeg = dotDiameterDeg;
	pDots->elevationDeg = elevationDeg;
	pDots->kdlPhiDeg = kdlPhiDeg;
	pDots->kdlThetaDeg = kdlThetaDeg;
	pDots->radiusDeg = radiusDeg;
	pDots->speedDPS = speedDPS;
	pDots->backgroundColor.red = [backColor redComponent];
	pDots->backgroundColor.green = [backColor greenComponent];
	pDots->backgroundColor.blue = [backColor blueComponent];
	pDots->dotColor.red = [foreColor redComponent];
	pDots->dotColor.green = [foreColor greenComponent];
	pDots->dotColor.blue = [foreColor blueComponent];
}

/*
Make a circular texture that will be used to clip the field of displayed   The dots are drawn
into a square field.  The circular mask has a radius equal to radiusDeg to limit the visible
  The halfwidth of the square field is larger than radiusDeg, to make sure that there
is always a pool of dots to step into the circle (so that there will not be any density inhomogeneities.
The extra width on the square field is the largest step a dot can take: speedDPS / [displays frameRateHz:displayIndex]. 
The limits of the mask we make needs to be a little bit larger than this, because a dot drawn at
radiusDeg + (speedDPS / [displays frameRateHz:displayIndex]) has finite width: dotDiameterDeg.
Hence, the mask we make spans 2.0 * radiusDeg + (speedDPS / [displays frameRateHz:displayIndex]) +
dotDiameterDeg, and has a circle cut out of its center that has radius.radiusDeg.
*/

- (void)makeCircularTexture;
{
    long x, y, halfWidth, squared, circleHalfWidth, circleHalfWidthSqr;
    short xside, yside;
    float g;
	
    halfWidth = kRDImagePix / 2;
	circleHalfWidth = halfWidth * radiusDeg / (radiusDeg + 
				(speedDPS / [displays frameRateHz:displayIndex]) + dotDiameterDeg);
	circleHalfWidthSqr = circleHalfWidth * circleHalfWidth;
    for (x = 0; x < halfWidth; x++) {
        for (y = 0; y < halfWidth; y++) {
            squared = x * x + y * y;
            g = (squared < circleHalfWidthSqr) ? 0.0 : 1.0;
            for (xside = -1; xside < 2; xside += 2) {
				for (yside = -1; yside < 2; yside += 2) {
					circularImage[halfWidth + x * xside][halfWidth + y * yside] = g;
				}
			}
        }
    }

    glBindTexture(GL_TEXTURE_2D, circularTexture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_CACHED_APPLE);
    glPixelTransferf(GL_RED_BIAS, 1.0 - [backColor redComponent]);
    glPixelTransferf(GL_GREEN_BIAS, 1.0 - [backColor greenComponent]);
    glPixelTransferf(GL_BLUE_BIAS, 1.0 - [backColor blueComponent]);
    glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, 1);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, kRDImagePix, kRDImagePix, 
                0, GL_ALPHA, GL_FLOAT, circularImage);
}

// Starting with version 3, dot coordinates are centered at (0, 0), and the draw function is responsible
// for drawing them with an offset of (azimuthDeg, elevationDeg)

- (void)makeDot:(NSPoint *)point descriptor:(DotDesc *)pDotDesc coherent:(BOOL)coherent age:(long)age;
{
	point->x = LLRandom() * fieldWidthDeg / (double)0x7fffffff - fieldWidthDeg / 2.0;
	point->y = LLRandom() * fieldWidthDeg / (double)0x7fffffff - fieldWidthDeg / 2.0;
	pDotDesc->directionDeg = (coherent) ? directionDeg : LLRandom() % 360;
	pDotDesc->coherent = coherent;
	pDotDesc->age = age;
}

// Make a movie based on the settings in the structure dots and the array coherenceFunction.
// After the movie is made, the randomSeed in dots is updated.  

- (void)makeMovie:(long)durationMS;
{
	long frame, frames, limitFrame, dir, numCoh, numCohNextFrame, age;
	long dotCount, numDots, *numCohByFrame;
	float maxDeg, minDeg, frameRateHz, frameCoherence, nextCoherence;
	float degreesPerFrame, xIncDeg[360], yIncDeg[360];
	NSMutableData *dotDesc, *dotPoints;
	NSPoint *pDotPoint;
	NSValue *value;
	DotDesc *pDotDesc;
	NSEnumerator *enumerator;

// Initialize

	glClearColor([backColor redComponent], [backColor greenComponent], [backColor blueComponent], 1.0);
	glShadeModel(GL_FLAT);									// flat shading
	glEnableClientState(GL_VERTEX_ARRAY);					// enable vertex arrays
	if (circularTexture == nil) {
		glGenTextures(1, &circularTexture);
	}
	
// Remake the clipping texture if it needs updating
	
	if (oldDotDiameterDeg != dotDiameterDeg ||
						oldPatchRadiusDeg != radiusDeg ||
						oldSpeedDPS != speedDPS ||
						oldBackgroundColor.red != [backColor redComponent] ||
						oldBackgroundColor.green != [backColor greenComponent] ||
						oldBackgroundColor.blue != [backColor blueComponent]) {
						
		[self makeCircularTexture];						// re-make the clipping texture
		
		oldDotDiameterDeg = dotDiameterDeg;
		oldPatchRadiusDeg = radiusDeg;
		oldSpeedDPS = speedDPS;
		oldBackgroundColor.red = [backColor redComponent];
		oldBackgroundColor.green = [backColor greenComponent];
		oldBackgroundColor.blue = [backColor blueComponent];
	}
	
// Precompute constants

	frameRateHz = (displays == nil) ? 60.0 : [displays frameRateHz:displayIndex];
	fieldWidthDeg = 2.0 * (radiusDeg + speedDPS / frameRateHz);
	frames = durationMS / 1000.0 * frameRateHz;
	
	LLSeedRandom(randomSeed);							// seed the random number generator
	
	numDots = fieldWidthDeg * fieldWidthDeg * density;
	degreesPerFrame = speedDPS / [displays frameRateHz:displayIndex];
	for (dir = 0; dir < 360; dir++) {
		xIncDeg[dir] = cos(dir * kRadiansPerDeg) * degreesPerFrame;
		yIncDeg[dir] = sin(dir * kRadiansPerDeg) * degreesPerFrame;
	}
//	xMinDeg = azimuthDeg - fieldWidthDeg / 2.0;
//	xMaxDeg = azimuthDeg + fieldWidthDeg / 2.0;
//	yMinDeg = elevationDeg - fieldWidthDeg / 2.0;
//	yMaxDeg = elevationDeg + fieldWidthDeg / 2.0;
	minDeg = -fieldWidthDeg / 2.0;
	maxDeg = fieldWidthDeg / 2.0;
	
// Calculate the number of coherent dots in each frame.  This can be done using either a single step
// from a base level to another level at a particular frame, or, more generally, can be done using
// a coherence function that specifies dot coherence as a function of time.  In the later case, a
// coherence function must be supplied using setCoherenceFunction.  If the coherence function is not
// set (or is reset to nil), a single step will be used.  If the coherence function is set, it must
// be an NSArray containing NSValues that each contain one NSPoint.  The x value of each point is a
// time in ms from the start of the movie.  The y value is a coherence in percent, which is clipped 
// between 0 and 100.

	numCohByFrame = malloc(frames * sizeof(long));
	if (coherenceFunction == nil) {
		for (frame = 0; frame < frames; frame++) {
			numCohByFrame[frame] = numDots * coherence;
		}
	}

// If there is a coherence function, use it to specify the coherence on each frame.

	else {
		frameCoherence = 0;
		enumerator = [coherenceFunction objectEnumerator];
		if ((value = [enumerator nextObject]) == nil) {			// empty function, all frame default coherence (0%)
			limitFrame = frames + 1;
		}
		else {
			NSLog(@"movieFunction %f %f", [value pointValue].x, [value pointValue].y);
			limitFrame = [value pointValue].x / (1000.0 / [displays frameRateHz:displayIndex]);	// point.x is time in ms
			nextCoherence = MAX(0, MIN(1.0, [value pointValue].y));
		}
		for (frame = 0; frame < frames; frame++) {
			if (frame >= limitFrame) {							// at next point in function, get new coherence
				frameCoherence = nextCoherence;
				if ((value = [enumerator nextObject]) == nil) {	// no more function, keep current coherence to end
					limitFrame = frames + 1;
				}
				else {
					limitFrame = [value pointValue].x / (1000.0 / [displays frameRateHz:displayIndex]);	// point.x is time in ms
					nextCoherence = MAX(0, MIN(1.0, [value pointValue].y));
				}
			}
			numCohByFrame[frame] = numDots * frameCoherence;
		}
	}
	
// Create and initialize an array containing information about each dot.  Dots are divided
// into two sequenctial groups: coherence and non-coherent.

	dotPoints = [[NSMutableData alloc] initWithLength:numDots * sizeof(NSPoint)];
	dotDesc = [[NSMutableData alloc] initWithLength:numDots * sizeof(DotDesc)];
	pDotPoint = (NSPoint *)[dotPoints bytes];
	pDotDesc = (DotDesc *)[dotDesc bytes];
	numCoh = numCohByFrame[0];

// Make the coherent   Initial dot ages increment by 1 for each dot.  This ensures
// an even balance of lifetimes in the coherence and non-coherent groups, even after a
// change in the number of coherent   This does not work properly if the number
// of dots is smaller than the number of lifetimes, but that condition should not occur

	age = 0;
	if (numCoh > 1) {
		for (dotCount = 0; dotCount < numCoh; dotCount++) {
			[self makeDot:pDotPoint descriptor:pDotDesc coherent:YES age:(long)age];
			pDotPoint++;
			pDotDesc++;
			age = ((age + 1) % lifeFrames);
		}
	}
	
// Make the non-coherent   They are uniformly distributed among possible dot ages

	if (numCoh < numDots) {
		for (dotCount = numCoh; dotCount < numDots; dotCount++) {
			[self makeDot:pDotPoint descriptor:pDotDesc coherent:NO age:(long)age];
			pDotPoint++;
			pDotDesc++;
			age = ((age + 1) % lifeFrames);
		}
	}
	
// Store the individual frames as arrays of points in frameList
// Each frame is the current dots added to the frameList by turning them into an NSData object

	[frameList removeAllObjects];							// purge any existing movie
	for (frame = 0; frame < frames; frame++) {

// Load the current dots as one frame in the movie.  
	
		[frameList addObject:[NSData dataWithData:dotPoints]];
		if (frame == frames - 1) {							// no updating need after last frame
			continue;
		}

// Before updating dot positions, change the number of coherent dots if needed

		numCohNextFrame = numCohByFrame[frame + 1];
		if (numCohNextFrame > numCoh) {
			pDotDesc = &((DotDesc *)[dotDesc bytes])[numCoh];
			for (dotCount = numCoh; dotCount < numCohNextFrame; dotCount++) {
				pDotDesc->coherent = YES;
				pDotDesc->directionDeg = directionDeg;
				pDotDesc++;
			}
			numCoh = numCohNextFrame;
		}
		else if (numCohNextFrame < numCoh) {
			pDotDesc = &((DotDesc *)[dotDesc bytes])[numCohNextFrame];
			for (dotCount = numCohNextFrame; dotCount < numCoh; dotCount++) {
				pDotDesc->coherent = NO;
				pDotDesc->directionDeg = LLRandom() % 360;
				pDotDesc++;
			}
			numCoh = numCohNextFrame;
		}
		
// Now update every dot to a new position
		
		pDotPoint = (NSPoint *)[dotPoints bytes];
		pDotDesc = (DotDesc *)[dotDesc bytes];
		for (dotCount = 0; dotCount < numDots; dotCount++) {
			if (++(pDotDesc->age) >= lifeFrames) {			// end of life
				[self makeDot:pDotPoint descriptor:pDotDesc coherent:pDotDesc->coherent age:0];
			}
			else {
				pDotPoint->x += xIncDeg[pDotDesc->directionDeg];
				if (pDotPoint->x > maxDeg) {
					pDotPoint->x -= fieldWidthDeg;
				}
				else if (pDotPoint->x < minDeg) {
					pDotPoint->x += fieldWidthDeg;
				}
				
				pDotPoint->y += yIncDeg[pDotDesc->directionDeg];
				if (pDotPoint->y > maxDeg) {
					pDotPoint->y -= fieldWidthDeg;
				}
				else if (pDotPoint->y < minDeg) {
					pDotPoint->y += fieldWidthDeg;
				}
			}
			pDotPoint++;
			pDotDesc++;
		}
	}
	[dotPoints release];
	[dotDesc release];
	free(numCohByFrame);
	randomSeed = LLGetRandomSeed();
}

- (long)movieFrames;
{
	return [frameList count];
}

- (long)randomSeed {

   return randomSeed;
}

- (void)restore;
{
	[self setDotData:baseDots];
}

- (void)runSettingsDialog;
{
	if (dialogWindow == nil) {
		[NSBundle loadNibNamed:@"LLRandomDots" owner:self];
		if (taskPrefix != nil) {
			[dialogWindow setTitle:[NSString stringWithFormat:@"%@ Random Dots", taskPrefix]];
		}
		[versionTextField setStringValue:[NSString stringWithFormat:@"Random Dots Version %d",
			version]];
	}
	[dialogWindow makeKeyAndOrderFront:self];
}

- (void)setAntialias:(BOOL)newState {

    antialias = newState;
	[self updateIntegerDefault:antialias key:LLRandomDotsAntialiasKey];
}

- (void)setBackgroundColorRed:(float)red green:(float)green blue:(float)blue; 
{
	[self setBackOnRed:red green:green blue:blue];
}

- (void)setCoherenceFunction:(NSArray *)function;
{
	[coherenceFunction release];
	coherenceFunction = [NSArray arrayWithArray:function];
	[coherenceFunction retain];
}

- (void)setCoherence:(float)newCoherence;
{
    coherence = MAX(0, MIN(newCoherence, 1.0));
	[self updateFloatDefault:coherence key:LLRandomDotsCoherenceKey];
}

- (void)setDotContrast:(float)newDotContrast;
{
    dotContrast = MAX(0, MIN(newDotContrast, 1.0));
	[self updateFloatDefault:dotContrast key:LLRandomDotsDotContrastKey];
}

- (void)setDotColorRed:(float)red green:(float)green blue:(float)blue;
{
	[self setForeOnRed:red green:green blue:blue];
}

- (void)setDotData:(RandomDots)d;
{
	[self setAntialias:d.antialias];
	[self setLifeFrames:d.lifeFrames];	
	[self setRandomSeed:d.randomSeed];
	version = d.version;
	[self setAzimuthDeg:d.azimuthDeg];
	[self setCoherence:d.coherence];
	[self setDirectionDeg:d.directionDeg];
	[self setDotContrast:d.dotContrast];
	[self setDotDiameterDeg:d.dotDiameterDeg];
	[self setElevationDeg:d.elevationDeg];
	[self setKdlPhiDeg:d.kdlPhiDeg];
	[self setKdlThetaDeg:d.kdlThetaDeg];
	[self setRadiusDeg:d.radiusDeg];
	[self setSpeedDPS:d.speedDPS];
	[self setForeOnRed:d.dotColor.red green:d.dotColor.green blue:d.dotColor.blue];
	[self setBackOnRed:d.backgroundColor.red green:d.backgroundColor.green blue:d.backgroundColor.blue];
}

- (void)setDotDiameterDeg:(float)newDotDiameter {

	dotDiameterDeg = newDotDiameter;
	[self updateFloatDefault:dotDiameterDeg key:LLRandomDotsDotDiameterDegKey];
}

- (void)setDensity:(float)newDensity {

    density = newDensity;
	[self updateFloatDefault:density key:LLRandomDotsDensityKey];
}

- (void)setFrame:(NSNumber *)frameNumber;
{
	currentFrame = [frameNumber unsignedLongValue];
}

- (void)setLifeFrames:(long)newLife;
{
	lifeFrames = newLife;
	[self updateIntegerDefault:lifeFrames key:LLRandomDotsLifeFramesKey];
}

- (void)setRandomSeed:(long)newSeed;
{
    randomSeed = newSeed;
	[self updateIntegerDefault:randomSeed key:LLRandomDotsRandomSeedKey];
}

- (void)setSpeedDPS:(float)newSpeed {

    speedDPS = newSpeed;
	[self updateFloatDefault:speedDPS key:LLRandomDotsSpeedDPSKey];
}

- (void)store;
{
	[self loadDots:&baseDots];
}

- (long)version;
{
	return version;
}
@end

/*
* Copyright (c) 1992, 1993
*      The Regents of the University of California.  All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions
* are met:
* 1. Redistributions of source code must retain the above copyright
*    notice, this list of conditions and the following disclaimer.
* 2. Redistributions in binary form must reproduce the above copyright
*    notice, this list of conditions and the following disclaimer in the
*    documentation and/or other materials provided with the distribution.
* 4. Neither the name of the University nor the names of its contributors
*    may be used to endorse or promote products derived from this software
*    without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
* ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
* ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
* OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
* HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
* LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
* OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
* SUCH DAMAGE.
*
*      @(#)random.c    8.1 (Berkeley) 6/10/93
*/
  
//__FBSDID("$FreeBSD: src/sys/libkern/random.c,v 1.13 2004/04/07 20:46:10 imp Exp $");
//#include <sys/libkern.h>
//#include <sys/cdefs.h>

#define NSHUFF 50						// to drop some "seed -> 1st value" linearity

static u_long randseed = 937186357;		// after srandom(1), NSHUFF counted

u_long LLGetRandomSeed(void) {

	return(randseed);
}

void LLSeedRandom(u_long seed) {

	int i;

	randseed = seed;
	for (i = 0; i < NSHUFF; i++) {
		(void)LLRandom();
	}
}

// Pseudo-random number generator for randomizing the profiling clock,
// and whatever else we might use it for.  The result is uniform on [0, 2^31 - 1].

u_long LLRandom() {

	register long x, hi, lo, t;

// Compute x[n + 1] = (7^5 * x[n]) mod (2^31 - 1).
// From "Random number generators: good ones are hard to find",
// Park and Miller, Communications of the ACM, vol. 31, no. 10,
// October 1988, p. 1195.

// Can't be initialized with 0, so use another value.

	if ((x = randseed) == 0) {
		x = 123459876;
	}
	hi = x / 127773;
	lo = x % 127773;
	t = 16807 * lo - 2836 * hi;
	if (t < 0) {
		t += 0x7fffffff;
	}
	randseed = t;
	return (t);
}

