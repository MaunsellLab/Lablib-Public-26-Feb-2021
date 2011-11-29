//
//  LLDisplays.m
//  Experiment
//
//  Created by John Maunsell on Thu Feb 13 2003.
//  Copyright (c) 2003. All rights reserved.
//

#import "LLDisplays.h"
#import "LLDisplayPhysical.h" 
#import <IOKit/graphics/IOGraphicsLib.h>

NSString *LLPixelBitsKey = @"LL Pixel Bits";
NSString *LLWidthPixKey = @"LL Width Pix";
NSString *LLHeightPixKey = @"LL Height Pix";
NSString *LLFrameRateKey = @"LL Frame Rate Hz";

void readEDID(CGDirectDisplayID displayID);

@implementation LLDisplays

+ (NSString *)displayNameUsingID:(CGDirectDisplayID)displayID;
{
	NSDictionary *displayDictionary, *productNamesDictionary;
	io_service_t service;
	NSString *displayName;

	service = CGDisplayIOServicePort(displayID);
	displayDictionary = (NSDictionary *)IODisplayCreateInfoDictionary(service, kIODisplayOnlyPreferredName);
	if (displayDictionary != nil) {
		productNamesDictionary = [displayDictionary valueForKey:@kDisplayProductName];
		if (productNamesDictionary != nil) {
			displayName = [[productNamesDictionary allValues] objectAtIndex:0];
		}
	}
	return (displayName != NULL) ? displayName : @"Unknown Display";
}

+ (NSString *)displayNameUsingIndex:(long)displayIndex;
{
	CGDirectDisplayID IDs[kMaxDisplay];
	CGDisplayCount displayCount;
	
	CGGetActiveDisplayList(kMaxDisplay, IDs, &displayCount);
	return [LLDisplays displayNameUsingID:IDs[displayIndex]];
}

- (BOOL)captureDisplay:(long)displayIndex {

    if (displayIndex >= numDisplays) {
		return NO;
	}
	if (CGDisplayIsCaptured(displayIDs[displayIndex])) {
        return YES;
    }
	return (CGDisplayCapture(displayIDs[displayIndex]) == CGDisplayNoErr);
}

- (void)computeKdlConstants:(long)displayIndex {

	ColorPatches calibratedColor;
	
	calibratedColor = computeKdlColors(displayParam[displayIndex].CIEx, displayParam[displayIndex].CIEy);
	kdlConstants[displayIndex].rtc = (calibratedColor.equalEnergy.red - calibratedColor.cardinalYellow.red) /
										calibratedColor.equalEnergy.red;
	kdlConstants[displayIndex].gcb = (calibratedColor.equalEnergy.green - calibratedColor.cardinalGreen.green) /
										calibratedColor.equalEnergy.green;
	kdlConstants[displayIndex].gtc = (calibratedColor.equalEnergy.green - calibratedColor.cardinalYellow.green) /
										calibratedColor.equalEnergy.green;
	kdlConstants[displayIndex].bcb = (calibratedColor.equalEnergy.blue - calibratedColor.cardinalGreen.blue) /
										calibratedColor.equalEnergy.blue;
}

- (void)dealloc {

	[displayPhysical release];
	[super dealloc];
}

// Report the displayBounds as reported by Core Graphics.  The origin is taken as the upper left corner

- (NSRect)displayBounds:(long)displayIndex {

    CGRect rect;
    
    if (displayIndex >= numDisplays) {
        return NSMakeRect(0, 0, 0, 0);
    }
    rect = CGDisplayBounds(displayIDs[displayIndex]);
    return NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

// CGDisplayBounds returns a CGRect in which the origin is taken to be the upper left corner,
// relative to the upperleft corner of the main screen.  We convert this into the position
// of the lower left corner, relative to the lower left corner of the main screen.

- (NSRect)displayBoundsLLOrigin:(long)displayIndex;
{
    CGRect rect;
    
    if (displayIndex >= numDisplays) {
        return NSMakeRect(0, 0, 0, 0);
    }
    rect = CGDisplayBounds(displayIDs[displayIndex]);
	rect.origin.y = [[NSScreen mainScreen] frame].size.height - rect.origin.y - rect.size.height;
    return NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

// Update the display parameters

- (DisplayParam)displayParameters:(long)displayIndex;
{
	return displayParam[displayIndex];
}

- (NSSize)displaySizeDeg:(long)displayIndex {
	
	return NSMakeSize(atan2(displayParam[displayIndex].widthMM / 2.0, 
				displayParam[displayIndex].distanceMM) * kDegPerRadian * 2.0,
				atan2(displayParam[displayIndex].heightMM / 2.0, 
				displayParam[displayIndex].distanceMM) * kDegPerRadian * 2.0);
}

- (double)distanceMM:(long)displayIndex {

	return displayParam[displayIndex].distanceMM;
}

- (void)doSettingsPanel:(long)displayIndex {

	[displayPhysical doSettingsPanel:displayIndex];
	[self updatePhysicalParam:[displayPhysical displayParameters:displayIndex] displayIndex:displayIndex];
}

- (void)dumpCurrentDisplayMode:(CGDisplayCount)displayIndex {

    if (displayIndex < numDisplays) {
		[self dumpDisplayModeValues:CGDisplayCurrentMode(displayIDs[displayIndex])];
    }
}

- (void)dumpDisplayModes:(CGDisplayCount)displayIndex   {

    long index;
    CFArrayRef display_modes;
    CFIndex modes;
    
    if (displayIndex < numDisplays) {
		display_modes = CGDisplayAvailableModes(displayIDs[displayIndex]);
		modes = CFArrayGetCount(display_modes);
		for (index = 0; index < modes; index++) {
			[self dumpDisplayModeValues:CFArrayGetValueAtIndex(display_modes, index)];
		}
    }
}

- (void) dumpDisplayModeValues:(CFDictionaryRef)values {

    NSLog(@" ----- Display Mode Info for %ld -----\n", 
            [self getValue:values forKey:kCGDisplayMode]);
    NSLog(@" Bounds = %ld x %ld\n", [self getValue:values forKey:kCGDisplayWidth], 
            [self getValue:values forKey:kCGDisplayHeight]);
    NSLog(@" bpp = %ld, hz = %ld\n", [self getValue:values forKey:kCGDisplayBitsPerPixel], 
                [self getValue:values forKey:kCGDisplayRefreshRate]);
}

- (float)frameRateHz:(long)displayIndex;
{
	return displayParam[displayIndex].frameRateHz;
}

- (long)getValue:(CFDictionaryRef)values forKey:(CFStringRef)key {

    long value;
    CFNumberRef number_value = (CFNumberRef)CFDictionaryGetValue(values, key);

    if (!number_value) {
        return -1;
    }
    if (!CFNumberGetValue(number_value, kCFNumberLongType, &value)) {
        return -1;
    }
    return value;
}

- (double)heightMM:(long)displayIndex {

	return displayParam[displayIndex].heightMM;
}
	
- (long)heightPix:(long)displayIndex {

	return displayParam[displayIndex].heightPix;
}

- (void)hideCursor:(long)displayIndex {
	
	CGDisplayHideCursor(displayIDs[displayIndex]);
}

- (id)init {

	long index;
	
    if ((self = [super init]) != nil) {
		displayPhysical = [[LLDisplayPhysical alloc] init];
		CGGetActiveDisplayList(kMaxDisplay, displayIDs, &numDisplays);
		for (index = 0; index < numDisplays; index++) {
			EDID[index] = [[LLDisplayEDID alloc] initWithDisplayID:displayIDs[index]];
			[self loadDisplayParameters:index];
		}
	}
    return self;
}

// Load the DisplayParam structure for a display, and precompute the values that will be needed
// for providing calibrated color values

- (void)loadDisplayParameters:(long)displayIndex {
	
	io_connect_t displayPort;
	CFDictionaryRef displayModeDict;
	CFDictionaryRef displayDict;
	CGDirectDisplayID displayID = displayIDs[displayIndex];
	DisplayParam *pDP = &displayParam[displayIndex];
	
// Some display parameters are values that the controller determines, such
// as frame rate and pixel width.  These are read from the hardware.

	displayModeDict = CGDisplayCurrentMode(displayID);
	pDP->pixelBits = [self getValue:displayModeDict forKey:kCGDisplayBitsPerPixel];
	pDP->frameRateHz = [self getValue:displayModeDict forKey:kCGDisplayRefreshRate];
	
	if (pDP->frameRateHz <= 0.0) {
		pDP->frameRateHz = 60.0;
		NSLog(@"Device for displayIndex %d not reporting frame rate. Assuming 60 Hz", displayIndex);
	}
	
	
	NSLog(@"Device %d frameRate %f", displayIndex, pDP->frameRateHz);
	
	
	displayPort = CGDisplayIOServicePort(displayID);
	if (displayPort != MACH_PORT_NULL) {
		displayDict = IODisplayCreateInfoDictionary(displayPort, 0);
		if (displayDict != NULL) {
			pDP->widthPix = [self getValue:displayModeDict forKey:kCGDisplayWidth];
			pDP->heightPix = [self getValue:displayModeDict forKey:kCGDisplayHeight];
			CFRelease(displayDict);
		}
	}
	[self updatePhysicalParam:[displayPhysical displayParameters:displayIndex] displayIndex:displayIndex];
}

- (short)numDisplays {

    return numDisplays;
}

- (long)pixelBits:(long)displayIndex {

	return displayParam[displayIndex].pixelBits;
}

- (u_int32_t)openGLDisplayID:(CGDisplayCount)displayIndex {

    if (displayIndex >= numDisplays) {
        return 0;
    }
    return CGDisplayIDToOpenGLDisplayMask(displayIDs[displayIndex]);
}

- (BOOL)releaseDisplay:(CGDisplayCount)displayIndex {

    if (displayIndex >= numDisplays || !CGDisplayIsCaptured(displayIDs[displayIndex])) {
        return NO;
    }	
	CGDisplayShowCursor(displayIDs[displayIndex]);
    return (CGDisplayRelease(displayIDs[displayIndex]) == CGDisplayNoErr);
}

// Return RGB for a kdlTheta and kdlPhi

- (RGBDouble)RGB:(long)displayIndex kdlTheta:(double)kdlTheta kdlPhi:(double)kdlPhi;
{
    double lum, cb, tc;
    RGBDouble rgb;

    lum = sin(kRadiansPerDeg * kdlTheta);
    cb = tc = cos(kRadiansPerDeg * kdlTheta);
    cb *= cos(kRadiansPerDeg * kdlPhi);
    tc *= sin(kRadiansPerDeg * kdlPhi);
    rgb.red = (lum + cb + kdlConstants[displayIndex].rtc * tc) / sqrt(2.0);
    rgb.green = (lum + cb * kdlConstants[displayIndex].gcb + tc * 
						kdlConstants[displayIndex].gtc) / sqrt(2.0);
    rgb.blue = (lum + cb * kdlConstants[displayIndex].bcb + tc) / sqrt(2.0);
    return rgb;
}

-(RGBDouble)luminanceToRGB:(long)displayIndex {

    return [self RGB:displayIndex kdlTheta:90.0 kdlPhi:0.0];
}

- (BOOL)setDisplayMode:(long)displayIndex size:(CGSize)size bitDepth:(size_t)pixelBits 
                frameRate:(CGRefreshRate)hz;
{				
    CGDisplayErr status;
    CFDictionaryRef displayModeValues;

    if (displayIndex >= numDisplays) {
        return NO;
    }
    displayModeValues = 
                CGDisplayBestModeForParametersAndRefreshRate(displayIDs[displayIndex], 
                pixelBits, (size_t)size.width, (size_t)size.height, hz, nil);
    status = CGDisplaySwitchToMode(displayIDs[displayIndex], displayModeValues);
	[self loadDisplayParameters:displayIndex];
    return (status == CGDisplayNoErr);
}

- (void)showCursor:(long)displayIndex {
	
	CGDisplayShowCursor(displayIDs[displayIndex]);
}

// Show the dialog for changing display settings. 

- (void)showDisplayParametersPanel:(long)displayIndex {

	[self doSettingsPanel:displayIndex];
}

- (double)widthMM:(long)displayIndex {

	return displayParam[displayIndex].widthMM;
}

- (long)widthPix:(long)displayIndex {

	return displayParam[displayIndex].widthPix;
}

- (void)updatePhysicalParam:(DisplayPhysicalParam *)pDP displayIndex:(long)displayIndex {

	displayParam[displayIndex].CIEx = pDP->CIEx;
	displayParam[displayIndex].CIEy = pDP->CIEy;
	displayParam[displayIndex].distanceMM = pDP->distanceMM;
	displayParam[displayIndex].widthMM = pDP->widthMM;
	displayParam[displayIndex].heightMM = pDP->heightMM;	

	[self computeKdlConstants:displayIndex];		// update the kdl constants for the new entries
}

@end