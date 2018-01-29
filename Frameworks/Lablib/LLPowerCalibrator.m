//
//  LLPowerCalibrator.m
//  Lablib
//
//  Created by John Maunsell.
//  Copyright 2017.
//

#import "LLPowerCalibrator.h"
#import "LLSystemUtil.h"

#define kdefaultCalibrationFolderURL @"file:///Library/Application%20Support/Knot/Calibrations/"

@implementation LLPowerCalibrator

@synthesize calibrated;

- (void)dealloc;
{
    if (mWatts > 0) {
        free(mWatts);
        mWatts = nil;
    }
    if (volts > 0) {
        free(volts);
        volts = nil;
    }
    [super dealloc];
}

- (instancetype)initFromFile:(NSURL *)fileURL;
{
    NSString *fileContents;
    NSError *error;

    if ((self = [super initWithWindowNibName:@"LLPowerCalibrator"]) != nil) {
        self.windowFrameAutosaveName = @"LLPowerCalibrator";
        fileContents = [NSString stringWithContentsOfFile:fileURL.path encoding:NSUTF8StringEncoding error:&error];
        if (fileContents == nil) {
            [LLSystemUtil runAlertPanelWithMessageText:@"LLPowerCalibrator"
                informativeText:[NSString stringWithFormat:@"Failed to find calibration file %@.", fileURL.path]];
            calibrated = NO;
            return self;
        }
        [self loadCalibration:fileContents];
    }
    return self;
}

- (instancetype)initWithCalibrationFile:(NSString *)fileName;
{
    NSString *path, *fileContents;
    NSError *error;

    if ((self = [super initWithWindowNibName:@"LLPowerCalibrator"]) != nil) {
        self.windowFrameAutosaveName = @"LLPowerCalibrator";
        path = [NSString stringWithFormat:@"/Library/Application Support/%@/Calibrations/%@.txt",
                [NSBundle mainBundle].bundlePath.lastPathComponent.stringByDeletingPathExtension, fileName];
        fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        if (fileContents == nil) {
            NSLog(@"LLPowerCalibrator: Failed to find calibration file %@. Continuing uncalibrated.", path);
            calibrated = NO;
            return self;
        }
        [self loadCalibration:fileContents];
    }
    return self;
}

-(void)loadCalibration:(NSString *)fileContents;
{
    const char *c;
    char *strEnd1, *strEnd2;
    long index, j, arrayLength;
    float tempV, tempMW, f1, f2;
    NSArray *array;

    array = [fileContents componentsSeparatedByString:@"\n"];
    if (array != nil) {
        arrayLength = array.count;
        mWatts = malloc(sizeof(float) * arrayLength);
        volts = malloc(sizeof(float) * arrayLength);
        for (index = entries = 0; index < arrayLength; index++) {
            c = [array[index] cStringUsingEncoding:NSUTF8StringEncoding];
            f1 = strtof(c, &strEnd1);
            if (strEnd1 != c) {
                f2 = strtof(strEnd1, &strEnd2);
                if (strEnd1 != strEnd2) {                   // found two valid floating point numbers
                    volts[index] = f1;
                    mWatts[index] = f2;
                    entries++;
                }
            }
        }
        for (index = 0; index < entries; index++) {         // sort volts to rise monotonically
            for (j = index + 1; j < entries; j++) {
                if (volts[index] > volts[j]) {
                    tempV =  volts[index];
                    tempMW = mWatts[index];
                    volts[index] =  volts[j];
                    mWatts[index] = mWatts[j];
                    volts[j] =  tempV;
                    mWatts[j] = tempMW;
                }
            }
        }
        for (index = 1; index < entries; index++) {
            if (volts[index] < volts[index - 1]) {
                NSLog(@"LLPowerCalibrator: error: voltages didn't sort properly");
                break;
            }
            if (mWatts[index] < mWatts[index - 1]) {
                volts[index] = volts[index - 1];
                mWatts[index] = mWatts[index - 1];
            }
        }
        calibrated = YES;
    }
}

- (float)maximumMW;
{
    return (calibrated) ? mWatts[entries - 1] : 0;
}

- (float)minimumMW;
{
    return (calibrated) ? mWatts[0] : 0;
}

- (float)maximumV;
{
    return (calibrated) ? [self voltageForMW:mWatts[entries - 1]] : 0;
}

- (float)minimumV;
{
    return (calibrated) ? [self voltageForMW:mWatts[0]] : 0;
}

- (BOOL)twoNumbersInString:(const char *)string;
{
    float f1, f2;
    char *strEnd1, *strEnd2;

    f1 = strtof(string, &strEnd1);
    if (strEnd1 == string) {
        return NO;
    }
    f2 = strtof(strEnd1, &strEnd2);
    if (strEnd1 == strEnd2) {
        return NO;
    }
    return YES;
}

- (float)voltageForMW:(float)targetMW;
{
    long midIndex, lowIndex, highIndex;
    float midMW, lowMW, highMW;

    if (!calibrated) {
        return 0;
    }
    lowIndex = 0;
    highIndex = entries - 1;
    lowMW = mWatts[lowIndex];
    highMW = mWatts[highIndex];
    if (targetMW < mWatts[lowIndex]) {
        NSLog(@"LLPowerCalibrator: requested %f mW when %f is the minimum calibration", targetMW, lowMW);
        return(volts[0]);
    }
    if (targetMW > mWatts[highIndex] * 1.001) {
        NSLog(@"LLPowerCalibrator: requested %f mW when %f is the maximum calibration", targetMW,  highMW);
        return(volts[highIndex]);
    }
    if (lowMW == targetMW)
        return volts[lowIndex];
    if (highMW == targetMW)
        return volts[highIndex];
    while (highIndex - lowIndex > 1) {
        midIndex = lowIndex + MAX(1, ((float)(highIndex - lowIndex) * (float)(targetMW - lowMW)) / (1 + (float)(highMW - lowMW)));
        midMW = mWatts[midIndex];
        if (midMW < targetMW) {
            lowIndex = midIndex;
            lowMW = mWatts[lowIndex];
        }
        else if (midMW > targetMW) {
            highIndex = midIndex;
            highMW = mWatts[highIndex];
        }
        else {
            return volts[midIndex];
        }
    }
    return volts[lowIndex] + (volts[highIndex] - volts[lowIndex]) * (targetMW - lowMW) / (highMW - lowMW);
}

@end
