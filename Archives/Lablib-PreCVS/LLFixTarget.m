//
//  LLFixTarget.m
//  Lablib
//
//  Created by John Maunsell on Thu Feb 12 2004.
//  Copyright (c) 2006. All rights reserved.
//

#import "LLFixTarget.h"

#define kSlices		16
#define kRings		16

NSString *LLFixAzimuthDegKey;
NSString *LLFixBackColorKey;
NSString *LLFixDirectionDegKey;
NSString *LLFixElevationDegKey;
NSString *LLFixForeColorKey;
NSString *LLFixKdlThetaDegKey;
NSString *LLFixKdlPhiDegKey;
NSString *LLFixRadiusDegKey;

NSString *LLFixInnerRadiusDegKey = @"innerRadiusDeg"; 
NSString *LLFixShapeKey = @"shape"; 

@implementation LLFixTarget

// The draw function assumes than an OpenGL context has already been properly set up.

- (void)draw;
{	
	GLUquadricObj *quadric;
	BOOL transparent;
	
	if (!state) {
		return;
	}
	glPushMatrix();
	transparent = ([foreColor alphaComponent] != 1.0);
	if (transparent) {
		glPushAttrib(GL_COLOR_BUFFER_BIT);						// save current blend mode
		glEnable(GL_BLEND);
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	}
	glColor4f([foreColor redComponent], [foreColor greenComponent], 
						[foreColor blueComponent], [foreColor alphaComponent]);
	switch (shape) {
	case kSquare:
		glRectf(azimuthDeg - radiusDeg, elevationDeg + radiusDeg, 
					azimuthDeg + radiusDeg, elevationDeg - radiusDeg);
		break;
	case kCircle:
		glTranslatef(azimuthDeg, elevationDeg, 0);
		quadric = gluNewQuadric();
		gluQuadricDrawStyle(quadric, GLU_FILL);
		gluDisk(quadric, innerRadiusDeg, radiusDeg, kSlices, kRings);
		gluDeleteQuadric(quadric);
		break;
	}
	if (transparent) {
		glPopAttrib();										// restore blend mode
	}
	glPopMatrix();
}

- (NSColor *)fixTargetColor;
{
	return [super foreColor];
}

- (id)init;
{	
	if ((self = [super init]) != nil) {
		shape = kCircle;
		radiusDeg = 0.25;
		innerRadiusDeg = 0.0;
		stimPrefix = @"Fix";								// make our keys different from other LLVisualStimuli
		[keys addObjectsFromArray:[NSArray arrayWithObjects:LLFixInnerRadiusDegKey	, LLFixShapeKey	, nil]];	
	
// Provide convenient access to keys declared in LLVisualStimulus

		LLFixAzimuthDegKey = LLAzimuthDegKey;
		LLFixBackColorKey = LLBackColorKey;
		LLFixDirectionDegKey = LLDirectionDegKey;
		LLFixElevationDegKey = LLElevationDegKey;
		LLFixForeColorKey = LLForeColorKey;
		LLFixKdlThetaDegKey = LLKdlThetaDegKey;
		LLFixKdlPhiDegKey = LLKdlPhiDegKey;
		LLFixRadiusDegKey = LLRadiusDegKey;
	}
	return self;
}

- (float)innerRadiusDeg;
{
	return innerRadiusDeg;
}

- (float)outerRadiusDeg;
{
	return [self radiusDeg];
}

- (void)runSettingsDialog;
{
	if (dialogWindow == nil) {
		[NSBundle loadNibNamed:@"LLFixTarget" owner:self];
		if (taskPrefix != nil) {
			[dialogWindow setTitle:[NSString stringWithFormat:@"%@ Fix Target", taskPrefix]];
		}
	}
	[dialogWindow makeKeyAndOrderFront:self];
}

- (void)setFixTargetColor:(NSColor *)newColor;
{
	[self setForeColor:newColor];
}

- (void)setInnerRadiusDeg:(float)newRadius;
{
	innerRadiusDeg = newRadius;
	[self updateFloatDefault:innerRadiusDeg key:LLFixInnerRadiusDegKey	];
}

- (void)setOnRed:(float)red green:(float)green blue:(float)blue;
{
	[self setForeOnRed:red green:green blue:blue];
}

- (void)setOuterRadiusDeg:(float)newRadius;
{
	[self setRadiusDeg:newRadius];
}

- (void)setShape:(long)newShape;
{
	shape = newShape;
	[self updateIntegerDefault:shape key:LLFixShapeKey	];
}

- (long)shape;
{
	return shape;
}

@end
