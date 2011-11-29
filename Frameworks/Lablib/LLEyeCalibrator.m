//
//  LLEyeCalibrator.m
//  Lablib
//
//  Created by John Maunsell on Sun May 18 2003.
//  Copyright (c) 2006. All rights reserved.
//

#import "LLEyeCalibrator.h"
#import "LLSettingsController.h"

#define kCircleRadiusDeg		0.15
#define kCrossArmDeg			0.25
#define kDefaultScaleFactor		0.001
#define kLineWidthDeg			0.02

#define kDefaultCorrectFactor	0.025
#define kDefaultOffsetDeg		1.0
#define kDefaultM11				0.001
#define kDefaultM12				0.0
#define kDefaultM21				0.0
#define kDefaultM22				0.001
#define kDefaultTX				0.0
#define kDefaultTY				0.0

NSString *LLFixCalAzimuthDegKey = @"LLFixCalAzimuthDeg";
NSString *LLFixCalElevationDegKey = @"LLFixCalElevationDeg";
NSString *LLFixCalOffsetDegKey = @"LLFixCalOffsetDeg";
NSString *LLFixCorrectFactorKey = @"LLFixCorrectFactor";
NSString *LLFixCalM11Key = @"LLFixCalM11";
NSString *LLFixCalM12Key = @"LLFixCalM12";
NSString *LLFixCalM21Key = @"LLFixCalM21";
NSString *LLFixCalM22Key = @"LLFixCalM22";
NSString *LLFixCalTXKey = @"LLFixCalTX";
NSString *LLFixCalTYKey = @"LLFixCalTY";

@implementation LLEyeCalibrator

// Draw bars to show the current calibration.  We construct a parallogram that reflect
// the X and Y scaling of where the actually fixation points are (when plotted in  
// isotropic degree space).

+ (NSBezierPath *)bezierPathForCalibration:(LLEyeCalibrationData)cal;
{
	long index;
	float factor, xSum, ySum;
	NSPoint xVector, yVector, actualDeg;
	NSSize xVectorSize, yVectorSize;
	NSPoint c, a;
 	NSAffineTransform *unitsToDeg, *degToUnits;
	NSBezierPath *calBezierPath;
	
	if (cal.offsetSizeDeg == 0) {
		return nil;
	}
	unitsToDeg = [[NSAffineTransform alloc] init];
	[unitsToDeg setTransformStruct:cal.calibration];
	degToUnits = [[NSAffineTransform alloc] init];
	[degToUnits setTransformStruct:cal.calibration];
	[degToUnits invert];
	calBezierPath = [NSBezierPath bezierPath];
	
// Mark the offsets that are being used for calibration with circles

	c = cal.currentOffsetDeg;
	[calBezierPath setLineWidth:kLineWidthDeg];							// line width in degrees
	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		[calBezierPath moveToPoint:NSMakePoint(cal.targetDeg[index].x - c.x + kCircleRadiusDeg, cal.targetDeg[index].y - c.y)];	
		[calBezierPath appendBezierPathWithArcWithCenter:NSMakePoint(cal.targetDeg[index].x - c.x, cal.targetDeg[index].y - c.y)
												  radius:kCircleRadiusDeg startAngle:0.0 endAngle:360.0];
	}

// Mark the sites that the eye actually hits with small crosses

	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		actualDeg = [unitsToDeg transformPoint:cal.actualUnits[index]];
		[calBezierPath moveToPoint:NSMakePoint(actualDeg.x - kCrossArmDeg, actualDeg.y)];	
		[calBezierPath lineToPoint:NSMakePoint(actualDeg.x + kCrossArmDeg, actualDeg.y)];	
		[calBezierPath moveToPoint:NSMakePoint(actualDeg.x, actualDeg.y - kCrossArmDeg)];	
		[calBezierPath lineToPoint:NSMakePoint(actualDeg.x, actualDeg.y + kCrossArmDeg)];
	}

// Make a parallogram to show the distortion in the affine transform.  We make the area equal
// to the area bounded by the offset target locations.

// Note, this is currently a rough approximation.  The correct parallelogram area is bh,
// where b is the base and h is the height normal to the base

	xVectorSize = [degToUnits transformSize:NSMakeSize(1.0, 0.0)];
	yVectorSize = [degToUnits transformSize:NSMakeSize(0.0, 1.0)];
	xVector.x = xVectorSize.width;
	xVector.y = xVectorSize.height;
	yVector.x = yVectorSize.width;
	yVector.y = yVectorSize.height;

	factor = (cal.offsetSizeDeg * cal.offsetSizeDeg) / 
				(sqrt(xVector.x * xVector.x + xVector.y * xVector.y) *
				sqrt(yVector.x * yVector.x + yVector.y * yVector.y));
	factor = sqrt(factor) / 2;					// convert areal to linear and get half side
	xVector.x *= factor;
	xVector.y *= factor;
	yVector.x *= factor;
	yVector.y *= factor;
	
	for (index = xSum = ySum = 0; index < kLLEyeCalibratorOffsets; index++) {
		xSum += cal.actualUnits[index].x;
		ySum += cal.actualUnits[index].y;
	}
	a = [unitsToDeg transformPoint:NSMakePoint(xSum / kLLEyeCalibratorOffsets, ySum / kLLEyeCalibratorOffsets)];
	[calBezierPath moveToPoint:
				NSMakePoint(a.x - xVector.x - yVector.x, a.y - xVector.y - yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x - xVector.x + yVector.x, a.y - xVector.y + yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x + xVector.x + yVector.x, a.y + xVector.y + yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x + xVector.x - yVector.x, a.y + xVector.y - yVector.y)];
	[calBezierPath lineToPoint:
				NSMakePoint(a.x - xVector.x - yVector.x, a.y - xVector.y - yVector.y)];

	[unitsToDeg release];
	[degToUnits release];
	return calBezierPath;
}

- (NSAffineTransformStruct)calibration {

	return currentCalibration;
}

- (LLEyeCalibrationData *)calibrationData;
{	
	long index;
	
	data.offsetSizeDeg = [taskDefaults floatForKey:LLFixCalOffsetDegKey];
	data.currentOffsetDeg = [self calibrationOffsetPointDeg];
	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		data.actualUnits[index] = offsetUnits[index];
		data.targetDeg[index] = offsetDeg[index];
	}
	data.calibration = currentCalibration;
	return &data;
}

// Return the current calibration offset, without the azimuth or elevation offset

- (float)calibrationOffsetDeg;
{
	return [taskDefaults floatForKey:LLFixCalOffsetDegKey];
}

- (NSPoint)calibrationOffsetPointDeg;
{
	return offsetDeg[offsetIndex];
}

- (IBAction)changeToDefaults:(id)sender;
{
	[taskDefaults setFloat:kDefaultM11 forKey:LLFixCalM11Key];
	[taskDefaults setFloat:kDefaultM12 forKey:LLFixCalM12Key];
	[taskDefaults setFloat:kDefaultM21 forKey:LLFixCalM21Key];
	[taskDefaults setFloat:kDefaultM22 forKey:LLFixCalM22Key];
	[taskDefaults setFloat:kDefaultTX forKey:LLFixCalTXKey];
	[taskDefaults setFloat:kDefaultTY forKey:LLFixCalTYKey];
	[self readDefaults];							// Load transforms and compute parameters 
}

/*
Find the best fitting affine transform.  
Calibration is done by offseting the fixation point to the corners of square on different trials.  These corners 
(in units of degrees of azimuth and elevation) define a 2x4 matrix of values (4 pairs of x,y), Y.  The running average 
of eye positions values (in A/D units) associated with each of these offsets defines another 2x4 matrix, X. We want an 
affine transform, A, (2x2 matrix (without translation)) that minimizes the squared error between transformed X and Y (Y = AX).  
The transform that minimizes this error is given by A = YX+ where X+ is the pseudoinverse of X, 
A = YX+= Y Xt (X Xt)^-1, where Xt is X transposed. 
*/

- (void)computeTransformFromOffsets;
{
	NSAffineTransformStruct calibration;
//	NSAffineTransform *trans;

	calibration = [SVDSolver solveCalibration:kLLEyeCalibratorOffsets degPoints:offsetDeg unitPoints:offsetUnits];

// Save the new calibration

	[taskDefaults setFloat:calibration.m11 forKey:LLFixCalM11Key];
	[taskDefaults setFloat:calibration.m12 forKey:LLFixCalM12Key];
	[taskDefaults setFloat:calibration.m21 forKey:LLFixCalM21Key];
	[taskDefaults setFloat:calibration.m22 forKey:LLFixCalM22Key];
	[taskDefaults setFloat:calibration.tX forKey:LLFixCalTXKey];
	[taskDefaults setFloat:calibration.tY forKey:LLFixCalTYKey];
	
	currentCalibration = calibration;
	[self loadTransforms];
}

/*
Find the best fitting affine transform.  
Calibration is done by offseting the fixation point to the corners of square on different trials.  These corners 
(in units of degrees of azimuth and elevation) define a 2x4 matrix of values (4 pairs of x,y), Y.  The running average 
of eye positions values (in A/D units) associated with each of these offsets defines another 2x4 matrix, X. We want an 
affine transform, A, (2x2 matrix (without translation)) that minimizes the squared error between transformed X and Y (Y = AX).  
The transform that minimizes this error is given by A = YX+ where X+ is the pseudoinverse of X, 
A = YX+= Y Xt (X Xt)^-1, where Xt is X transposed. 
*/
/*
- (void)computeTransformFromOffsets {

	long index;
	double x, y, tX, tY, denom;
	double YXt11, YXt12, YXt21, YXt22;
	double XXt11, XXt12, XXt21, XXt22;
	double IXXt11, IXXt12, IXXt21, IXXt22;
	NSSize degT;
	NSAffineTransformStruct calibration;
	NSAffineTransform *trans;
	
// We need to center both sets of points. The optimal translation is given by the difference
// vector between the centriods of the two sets.  The degree values are always centered on 0,0, so
// we need only to take out the centriod of the eye unit set.  Here we get that vector,
// so we can remove it from the eye unit set

	tX = tY = 0;
	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		tX += offsetUnits[index].x;
		tY += offsetUnits[index].y;
	}
	tX = tX / kLLEyeCalibratorOffsets;
	tY = tY / kLLEyeCalibratorOffsets; 

// Get the values in the 2x2 matrix that is Y Xt (Y multiplied by X transposed: YXt**),
// and also for the product of X with Xt (X multiplied by X transposed: XXt**).
	
	YXt11 = YXt12 = YXt21 = YXt22 = 0;
	XXt11 = XXt12 = XXt21 = XXt22 = 0;
	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		x = offsetUnits[index].x - tX;
		y = offsetUnits[index].y - tY;
		
		YXt11 += x * offsetDeg[index].x;
		YXt12 += y * offsetDeg[index].x;
		YXt21 += x * offsetDeg[index].y;
		YXt22 += y * offsetDeg[index].y;
		
		XXt11 += x * x;
		XXt12 += x * y;
		XXt21 += y * x;
		XXt22 += y * y;
	}

// Compute the inverse of the product of X and Xt ((X Xt)^-1), which is the pseudoinverse of X

	denom = XXt11 * XXt22 - XXt12 * XXt21;
	IXXt11 = XXt22 / denom;
	IXXt12 = -XXt12 / denom;
	IXXt21 = -XXt21 / denom;
	IXXt22 = XXt11 / denom;
	
// Compute the product of ((X Xt)^-1) and Y Xt, which is A, the matrix we seek

	calibration.m11 = YXt11 * IXXt11 + YXt12 * IXXt21;
	calibration.m21 = YXt11 * IXXt12 + YXt12 * IXXt22;
	calibration.m12 = YXt21 * IXXt11 + YXt22 * IXXt21;
	calibration.m22 = YXt21 * IXXt12 + YXt22 * IXXt22;
	calibration.tX = calibration.tY = 0.0;

// Use the new transform to compute the new translation in X and Y degrees

	trans = [NSAffineTransform transform];
	[trans setTransformStruct:calibration];
	degT = [trans transformSize:NSMakeSize(tX, tY)];
	calibration.tX = -degT.width;
	calibration.tY = -degT.height;
	
// Save the new calibration

	[taskDefaults setFloat:calibration.m11 forKey:LLFixCalM11Key];
	[taskDefaults setFloat:calibration.m12 forKey:LLFixCalM12Key];
	[taskDefaults setFloat:calibration.m21 forKey:LLFixCalM21Key];
	[taskDefaults setFloat:calibration.m22 forKey:LLFixCalM22Key];
	[taskDefaults setFloat:calibration.tX forKey:LLFixCalTXKey];
	[taskDefaults setFloat:calibration.tY forKey:LLFixCalTYKey];
	
	currentCalibration = calibration;
	[self loadTransforms];
}
*/

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[degToUnits release];
	[unitsToDeg release];
	[taskDefaults release];
	[SVDSolver release];
	[super dealloc];
}

- (NSPoint)degPointFromUnitPoint:(NSPoint)unitPoint {
   
   return [unitsToDeg transformPoint:unitPoint];
}

- (NSString *)description;
{
	return [NSString stringWithFormat:@"%@: m11 %.6f  m12 %.6f  %m21 %.6f  %m22 %.6f  tX %.2f  tY %.2f", [self class],
		currentCalibration.m11, currentCalibration.m12, currentCalibration.m21, currentCalibration.m22,
		currentCalibration.tX, currentCalibration.tY];
}
	
- (id)init;
{
	NSString *defaultsPath;
	NSDictionary *defaultsDict;
	
    if ((self = [super initWithWindowNibName:@"LLEyeCalibrator"]) != nil) {
        [self setWindowFrameAutosaveName:@"LLEyeCalibrator"];
		unitsToDeg = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
		degToUnits = [[NSAffineTransform alloc] initWithTransform:[NSAffineTransform transform]];
		SVDSolver = [[LLSVDSolver alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsChanged:)
				name:LLSettingsChanged object:nil];

// Set default calibration values, then try to read stored values

		defaultsPath = [[NSBundle bundleForClass:[LLEyeCalibrator class]] pathForResource:@"LLEyeCalibrator" ofType:@"plist"];
		defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
		taskDefaults = [[NSUserDefaults standardUserDefaults] retain];
		[taskDefaults registerDefaults:defaultsDict];
		[self readDefaults];
    }
    return self;
}

// Load the offset arrays that hold the positions that should be used for calibration. The offsets contain the 
// fixation point coordinates in units and degrees.  This requires us to initialize two fixed coordinate systems.  
// For degrees, we place the origin at the center of the screen.  Later on individual trials, we translate our 
// degrees coordinate system to place the origin at the current fixation point.

- (void)loadOffsets;
{
	
	long index;
	float halfCalOffsetDeg;				// half of the offset used for calibration, in degrees
	float azimuthDeg, elevationDeg;
	
	// Load the offset values.  The fixation azimuth and elevation offsets are added in here 
	
	azimuthDeg = [taskDefaults floatForKey:LLFixCalAzimuthDegKey];
	elevationDeg = [taskDefaults floatForKey:LLFixCalElevationDegKey];
	halfCalOffsetDeg = [taskDefaults floatForKey:LLFixCalOffsetDegKey] / 2.0;

	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		offsetDeg[index].x = ((index % 2) ? azimuthDeg + halfCalOffsetDeg : azimuthDeg - halfCalOffsetDeg);
		offsetDeg[index].y = ((index / 2) ? elevationDeg - halfCalOffsetDeg : elevationDeg + halfCalOffsetDeg);
		offsetUnits[index] = [self unitPointFromDegPoint:offsetDeg[index]];
	}	
}

// Load the tranforms with the currentCalibration values

- (void)loadTransforms;
{
	[unitsToDeg setTransformStruct:currentCalibration];
	[degToUnits setTransformStruct:currentCalibration];
	[degToUnits invert];
}

- (long)nextCalibrationPosition {

	double halfOffsetDeg;
	long index;
	
// If we have completed a block of positions, we need to update the calibration before moving on

	if (positionsDone >= kLLEyeCalibratorOffsets) {
		halfOffsetDeg = [taskDefaults floatForKey:LLFixCalOffsetDegKey] / 2.0;
		if (halfOffsetDeg > 0) {								// avoid degenerate case
			[self computeTransformFromOffsets];
		}
		for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
			positionDone[index] = NO;
		}
		positionsDone = 0;
	}

// Choose a new offset to test
		
	offsetIndex = (rand() % kLLEyeCalibratorOffsets);
	while (positionDone[offsetIndex]) {
		offsetIndex = (offsetIndex + 1) % kLLEyeCalibratorOffsets;
	}
	currentCalibration = [self readCalibration];
	currentCalibration.tX -= offsetDeg[offsetIndex].x;
	currentCalibration.tY -= offsetDeg[offsetIndex].y;
	[self loadTransforms];
	return offsetIndex;
}

// Return the total offset, including both the calibration offset and the azimuth/elevation offset.  If the
// calibration offset is zero (or we haven't yet assigned a calibration offset), this is just the fix offset.
// If there is a fixation offset, then we return the value from offsetDeg[], which already includes the fix offset
// and the calibration offset.

- (NSPoint)offsetDeg;
{
	if ((offsetIndex < 0) || ([taskDefaults floatForKey:LLFixCalOffsetDegKey] <= 0)) {
		return NSMakePoint([taskDefaults floatForKey:LLFixCalAzimuthDegKey], 
					[taskDefaults floatForKey:LLFixCalElevationDegKey]);
	}
	else {
		return NSMakePoint(offsetDeg[offsetIndex].x, offsetDeg[offsetIndex].y);
	}
}

- (long)offsetIndex;
{
	return offsetIndex;
}

// The values in the dialog window have changed.  We reload the calibration transforms, and 
// reset the positions that we are testing.

- (IBAction)parametersChanged:(id)sender;
{
	long index;
	
	currentCalibration = [self readCalibration];
	[self loadTransforms];
	for (index = 0; index < kLLEyeCalibratorOffsets; index++) {
		positionDone[index] = NO;
	}
	positionsDone = 0;

// Load the offset values.  The fixation azimuth and elevation offsets are added in here 

	[self loadOffsets];
}

- (NSAffineTransformStruct)readCalibration;
{
	NSAffineTransformStruct calibration;
	
	calibration.m11 = [taskDefaults floatForKey:LLFixCalM11Key];
	calibration.m12 = [taskDefaults floatForKey:LLFixCalM12Key];
	calibration.m21 = [taskDefaults floatForKey:LLFixCalM21Key];
	calibration.m22 = [taskDefaults floatForKey:LLFixCalM22Key];
	calibration.tX = [taskDefaults floatForKey:LLFixCalTXKey];
	calibration.tY = [taskDefaults floatForKey:LLFixCalTYKey];
	return calibration;
}

- (void)readDefaults;
{
	offsetIndex = -1;
	currentCalibration = [self readCalibration];
	if (currentCalibration.m11 == 0) {
		currentCalibration.m11 = kDefaultScaleFactor;
	}
	if (currentCalibration.m22 == 0) {
		currentCalibration.m22 = kDefaultScaleFactor;
	}
	[self loadTransforms];

// Set the calibration structure for the transforms.  We have to first set it
// without the fixation window offset, so that we can use it to compute the
// fixation window offset.  Once the offset is calculated, we load the 
// full transform.

	[self loadOffsets];
}

// set the size of the offset step that will be used for calibration
 
- (void)setCalibrationOffsetDeg:(float)newOffset;
{
	[taskDefaults setFloat:newOffset forKey:LLFixCalOffsetDegKey];
	[self parametersChanged:self];
}

- (void)setDefaults:(NSUserDefaults *)newDefaults;
{
	[taskDefaults release];
	taskDefaults = newDefaults;
	[taskDefaults retain];
}

- (void)setFixAzimuthDeg:(float)newAzimuthDeg elevationDeg:(float)newElevationDeg;
{
	[taskDefaults setFloat:newAzimuthDeg forKey:LLFixCalAzimuthDegKey];
	[taskDefaults setFloat:newElevationDeg forKey:LLFixCalElevationDegKey];
	[self parametersChanged:self];
}

// This function gets called at initialization and when the settings folder is changed.
// Neither of these should happen when the task is running.

- (void)settingsChanged:(NSNotification *)notification {

	[self readDefaults];
}

- (NSPoint)unitPointFromDegPoint:(NSPoint)degPoint {

	return [degToUnits transformPoint:degPoint];
}

- (NSRect)unitRectFromDegRect:(NSRect)degRect;
{
	NSRect unitRect;

	unitRect.origin = [degToUnits transformPoint:degRect.origin];
	unitRect.size = [degToUnits transformSize:degRect.size];
//	unitRect.size.width = fabsf(unitRect.size.width);
//	unitRect.size.height = fabsf(unitRect.size.height);
// EPC: if size is negative, flip the rect to make size > 0
	if (unitRect.size.width < 0) {
		unitRect.size.width = -unitRect.size.width;
		unitRect.origin.x -= unitRect.size.width;
	}
	if (unitRect.size.height < 0) {
		unitRect.size.height = -unitRect.size.height;
		unitRect.origin.y -= unitRect.size.height;
	}
	return unitRect;
}

- (NSRect)unitRectFromEyeWindow:(LLEyeWindow *)eyeWindow;
{
	NSRect unitRect, degRect;

	degRect = [eyeWindow rectDeg];
	unitRect.origin = [degToUnits transformPoint:degRect.origin];
	unitRect.size = [degToUnits transformSize:degRect.size];
//	unitRect.size.width = fabsf(unitRect.size.width);
//	unitRect.size.height = fabsf(unitRect.size.height);
	if (unitRect.size.width < 0) {
		unitRect.size.width = -unitRect.size.width;
		unitRect.origin.x -= unitRect.size.width;
	}
	if (unitRect.size.height < 0) {
		unitRect.size.height = -unitRect.size.height;
		unitRect.origin.y -= unitRect.size.height;
	}	
	return unitRect;
}

- (NSSize)unitSizeFromDegSize:(NSSize)sizeDeg;
{
	NSSize unitSize = [degToUnits transformSize:sizeDeg];
	
	unitSize.width = fabsf(unitSize.width);
	unitSize.height = fabsf(unitSize.height);
	return unitSize;
}

- (void)updateCalibration:(NSPoint)pointDeg;
{
	NSPoint unitPoint;
	
	unitPoint = [degToUnits transformPoint:pointDeg];
	offsetUnits[offsetIndex].x = offsetUnits[offsetIndex].x + (unitPoint.x - offsetUnits[offsetIndex].x) *
				[taskDefaults floatForKey:LLFixCorrectFactorKey];
	offsetUnits[offsetIndex].y = offsetUnits[offsetIndex].y + (unitPoint.y - offsetUnits[offsetIndex].y) *
				[taskDefaults floatForKey:LLFixCorrectFactorKey];
	positionDone[offsetIndex] = YES;
	positionsDone++;
}

@end
