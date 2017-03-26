//
//  LLPowerCalibrator.m
//  Lablib
//
//  Created by John Maunsell.
//  Copyright 2017.
//

#import "LLPowerCalibrator.h"
#import "LLSystemUtil.h"

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

- (id)initWithFile:(NSString *)fileName;
{
    long index, j;
    float tempV, tempMW;
    NSString *path, *fileContents;
    NSError *error;
    NSArray *array;

    if ((self = [super initWithWindowNibName:@"LLPowerCalibrator"]) != nil) {
        [self setWindowFrameAutosaveName:@"LLPowerCalibrator"];

        path = [NSString stringWithFormat:@"/Library/Application Support/%@/Calibrations/%@.txt",
                [[[[NSBundle mainBundle] bundlePath] lastPathComponent] stringByDeletingPathExtension], fileName];
        fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        array = [fileContents componentsSeparatedByString:@"\n"];
        if (array != nil) {
        entries = [array count];
            while ([(NSString *)[array objectAtIndex:entries - 1] length] == 0) {
                entries--;
            }
            mWatts = malloc(sizeof(float) * entries);
            volts = malloc(sizeof(float) * entries);
            for (index = 0; index < entries; index++) {
                sscanf([[array objectAtIndex:index] cStringUsingEncoding:NSUTF8StringEncoding], "%f%f", &mWatts[index],
                       &volts[index]);
            }
            for (index = 0; index < entries; index++) {
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
                    NSLog(@"LLPowerCalibrator: error: mWatts are not monotonic with voltage");
                    break;
                }
            }
            calibrated = YES;
        }
    }
    return self;
}

- (float)maximumMW;
{
    return (calibrated) ? mWatts[entries - 1] : -1;
}

- (float)minimumMW;
{
    return (calibrated) ? mWatts[0] : -1;
}

- (float)maximumV;
{
    return (calibrated) ? [self voltageForMW:mWatts[entries - 1]] : 10.0;
}

- (float)minimumV;
{
    return (calibrated) ? [self voltageForMW:mWatts[0]] : -10.0;
}

- (float)voltageForMW:(float)targetMW;
{
    long midIndex, lowIndex, highIndex;
    float midMW, lowMW, highMW;

    if (!calibrated) {
        return -1;
    }
    lowIndex = 0;
    highIndex = entries - 1;
    lowMW = mWatts[lowIndex];
    highMW = mWatts[highIndex];
    if (targetMW < mWatts[lowIndex]) {
        NSLog(@"LLPowerCalibrator: requested %f mW when %f is the minimum calibration", targetMW, lowMW);
        return(volts[0]);
    }
    if (targetMW > mWatts[highIndex]) {
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
