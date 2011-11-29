//
//  LLSynthDataDevice.m
//  Lablib
//
//  Created by John Maunsell on Monday, September 26, 2005.
//  Copyright (c) 2005. All rights reserved.
//
/*

Although in principle we could have independent sampling rates and many channels,
this device is restricted to only two channels (x and y eye position) and they 
are yoked to a single sampling rate

*/
#import "LLSynthDataDevice.h"
#import "LLSynthDataSettings.h"
#import "LLSystemUtil.h"
#import "LLSynthSaccade.h"

#define kLeverJitter 0.25
#define kUnitsPerDeg 500.0

NSString *LLSynthActiveSpikeChannelsKey = @"LLSynthActiveSpikeChannels";
NSString *LLSynthEyeBreakKey = @"LLSynthEyeBreak";
NSString *LLSynthEyeIgnoreKey = @"LLSynthEyeIgnore";
NSString *LLSynthEyeIntervalKey = @"LLSynthEyeInterval";
NSString *LLSynthEyeNoiseKey = @"LLSynthEyeNoise";
NSString *LLSynthEyeXKey = @"LLSynthEyeX";
NSString *LLSynthEyeYKey = @"LLSynthEyeY";
NSString *LLSynthLeverBitKey = @"LLSynthLeverBit";
NSString *LLSynthLeverLatencyKey = @"LLSynthLeverLatency";
NSString *LLSynthLeverIgnoreKey = @"LLSynthLeverIgnore";
NSString *LLSynthLeverDownKey = @"LLSynthLeverDown";
NSString *LLSynthLeverUpKey = @"LLSynthLeverUp";
NSString *LLSynthM11Key = @"LLSynthM11";
NSString *LLSynthM12Key = @"LLSynthM12";
NSString *LLSynthM21Key = @"LLSynthM21";
NSString *LLSynthM22Key = @"LLSynthM22";
NSString *LLSynthSpikesKey = @"LLSynthSpikes";
NSString *LLSynthSpikesRandomKey = @"LLSynthSpikesRandom";
NSString *LLSynthTXKey = @"LLSynthTX";
NSString *LLSynthTYKey = @"LLSynthTY";
NSString *LLSynthVBLKey = @"LLSynthVBL";
NSString *LLSynthVBLRateKey = @"LLSynthVBLRate";

@implementation LLSynthDataDevice

-  (BOOL)checkSpikeRateChange:(double)timeNowS {

    if (nextRateTimeS <= 0 || timeNowS < nextRateTimeS) {
        return NO;
    }
    spikeRateHz = nextSpikeRateHz;
    if (spikeRateHz <= 0) {
        nextSpikeTimeS = 1e100;
    }
    else {
        nextSpikeTimeS = nextRateTimeS + 1.0 / spikeRateHz;
    }
    nextRateTimeS = -1;
    return YES;
}

- (void)configure {

	if (synthSettings == nil) {
		synthSettings = [[LLSynthDataSettings alloc] init];
	}
	[synthSettings runPanel];
	[self loadAffineTransform];
}

- (void)dealloc;
{
	[synthSettings release];
	[eyeCalibrator release];
	[degToUnits release];
    [super dealloc];
}

- (unsigned long)digitalInputBits;
{
    double timeNow, noChangeProb, deltaS;
	long leverBit;
	double spontLeverUpPerS, spontLeverDownPerS;
    
	if ((leverBit = [defaults integerForKey:LLSynthLeverBitKey]) < 0) {
		return 0x0000;
	}
	leverBit = (0x1 << leverBit);
	timeNow = [LLSystemUtil getTimeS];

// Time to put the lever down

	if (leverDownTimeS > 0 && timeNow > leverDownTimeS && !(digitalInputBits & leverBit)) {
        digitalInputBits |= leverBit;
        lastLeverDownTimeS = leverDownTimeS;
        leverDownTimeS = lastSpontUpCheckTimeS = 0;
    }
    
// Time to put the lever up

	if (leverUpTimeS > 0 && timeNow > leverUpTimeS && (digitalInputBits & leverBit)) {
        digitalInputBits &= ~leverBit;
        lastLeverUpTimeS = leverUpTimeS;
        leverUpTimeS = lastSpontDownCheckTimeS = 0;
    }
    
// Spontaneous lever up?

    if (digitalInputBits & leverBit) {
		spontLeverUpPerS = [defaults floatForKey:LLSynthLeverUpKey];
        if (spontLeverUpPerS > 0 && lastSpontUpCheckTimeS > 0) {
            deltaS = timeNow - lastSpontUpCheckTimeS;
            noChangeProb = exp(deltaS * log(1.0 - spontLeverUpPerS)); 
            if (rand() % 1000 > noChangeProb * 1000.0) {
                digitalInputBits &= ~leverBit;
                lastLeverUpTimeS = lastSpontDownCheckTimeS = timeNow;
           }
       }
        lastSpontUpCheckTimeS = timeNow;
    }
    
// Spontaneous lever down?

    else {
		spontLeverDownPerS = [defaults floatForKey:LLSynthLeverDownKey];
        if (spontLeverDownPerS > 0 && lastSpontDownCheckTimeS > 0) {
            deltaS = timeNow - lastSpontDownCheckTimeS;
            noChangeProb = exp(deltaS * log(1.0 - spontLeverDownPerS)); 
            if (rand() % 1000 > noChangeProb * 1000.0) {
                digitalInputBits |= leverBit;
                lastLeverDownTimeS = lastSpontUpCheckTimeS = timeNow;
            }
        }
        lastSpontDownCheckTimeS = timeNow;
    }
	return digitalInputBits;
}

- (void)doLeverDown {

	float leverLatencyS, randomLatencyS;
	
    if ((rand() % 1000) > [defaults integerForKey:LLSynthLeverIgnoreKey] * 1000.0) {
		leverLatencyS = [defaults integerForKey:LLSynthLeverLatencyKey] / 1000.0;
		randomLatencyS = (leverLatencyS + 
					((rand() % 1000) * kLeverJitter * leverLatencyS) / 1000.0);
        leverDownTimeS = [LLSystemUtil getTimeS] + randomLatencyS;
        leverUpTimeS = 0;
    }
}

- (void)doLeverUp {

	float leverLatencyS, randomLatencyS;
	
    if ((rand() % 1000) > [defaults integerForKey:LLSynthLeverIgnoreKey] * 1000.0) {
 		leverLatencyS = [defaults integerForKey:LLSynthLeverLatencyKey] / 1000.0;
		randomLatencyS = (leverLatencyS + 
					((rand() % 1000) * kLeverJitter * leverLatencyS) / 1000.0);
       leverUpTimeS = [LLSystemUtil getTimeS] + randomLatencyS;
        leverDownTimeS = 0;
    }
}

- (id)init;
{
	long channel;
	NSString *defaultsPath;
    NSDictionary *defaultsDict;

    if ((self = [super init]) != nil) {
        spikeRateHz = 0.0;
        eyeCalibrator = [[LLEyeCalibrator alloc] init];
		degToUnits = [[NSAffineTransform alloc] init];
		defaultsPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"LLSynthDataDevice" ofType:@"plist"];
		defaultsDict = [NSDictionary dictionaryWithContentsOfFile:defaultsPath];
		defaults = [NSUserDefaults standardUserDefaults];
		[defaults registerDefaults:defaultsDict];
		[self loadAffineTransform];
		for (channel = 0; channel < kLLSynthADChannels; channel++)  {
			[samplePeriodMS addObject:[NSNumber numberWithFloat:kLLSynthSamplePeriodMS]];
		}
		for (channel = 0; channel < kLLSynthDigitalBits; channel++)  {
			[timestampPeriodMS addObject:[NSNumber numberWithFloat:kLLSynthTimestampPeriodMS]];
		}
		devicePresent = YES;
    }
    return self;
}

// Load the NSAffineTransform with its transform.  The values are stored as unitsToDeg, for compatibility with
// the transform used for calibration.  But here was are going to use it only for degToUnits, so we invert it
// after it is loaded. 

- (void) loadAffineTransform {

	transform.m11 = [defaults floatForKey:LLSynthM11Key];
	transform.m12 = [defaults floatForKey:LLSynthM12Key];
	transform.m21 = [defaults floatForKey:LLSynthM21Key];
	transform.m22 = [defaults floatForKey:LLSynthM22Key];
	transform.tX = [defaults floatForKey:LLSynthTXKey];
	transform.tY = [defaults floatForKey:LLSynthTYKey];
	[degToUnits setTransformStruct:transform];
	[degToUnits invert];
}

- (NSString *)name
{
	return @"Synthetic";
}

- (void)setDataEnabled:(NSNumber *)state;
{
	if ([state boolValue] && !dataEnabled) {
		nextSampleTimeS = nextSpikeTimeS = nextVBLTimeS = 
					lastSpikeTimeS = timestampRefS = [LLSystemUtil getTimeS];
	}
	dataEnabled = [state boolValue];
}

// We only return data for two channels: x and y eye position.  They can be 
// linked to any of the synthetic AD channels.  The returned array contains
// one entry for each of the active channels

- (NSData **)sampleData;
{
	short sample, index;
	long xChannel, yChannel;
	double fixNoiseDeg, timeNowS;
	NSSize fixNoiseEye;
	DeviceADData theSample;							// struct for holding a sample
    NSMutableData *xData, *yData, *otherData;
	
    if (!dataEnabled) {								// no data being collected
        return nil;
    }
	timeNowS = [LLSystemUtil getTimeS];
	xChannel = [defaults integerForKey:LLSynthEyeXKey];
	yChannel = [defaults integerForKey:LLSynthEyeYKey];
	if (xChannel < 0 && yChannel < 0) {
		[self updateEyePosition:timeNowS];
		return nil;									// not doing x or y data
	}

// Pick up all the data available from both channels and store them in NSData objects

	xData = [NSMutableData dataWithLength:0];
	yData = [NSMutableData dataWithLength:0];
	otherData = [NSMutableData dataWithLength:0];
	theSample.device = deviceIndex;
	while (timeNowS >= nextSampleTimeS) {
		[self updateEyePosition:nextSampleTimeS];
		fixNoiseDeg = [defaults floatForKey:LLSynthEyeNoiseKey];
		fixNoiseEye = [degToUnits transformSize:NSMakeSize(fixNoiseDeg, fixNoiseDeg)];
		if (fixNoiseEye.width != 0) {
			fixNoiseEye.width = (rand() % (long)fixNoiseEye.width) - fixNoiseEye.width / 2;
		}
		if (fixNoiseEye.height != 0) {
			fixNoiseEye.height = (rand() % (long)fixNoiseEye.height) - fixNoiseEye.height / 2;
		}
		if (xChannel >= 0) {
			sample = MIN(SHRT_MAX, MAX(SHRT_MIN, eyePosition.x + fixNoiseEye.width));
			[xData appendBytes:&sample length:sizeof(sample)];
		}
		if (yChannel >= 0) {
			sample = MIN(SHRT_MAX, MAX(SHRT_MIN, eyePosition.y + fixNoiseEye.height));
			[yData appendBytes:&sample length:sizeof(sample)];
		}
		nextSampleTimeS += [[samplePeriodMS objectAtIndex:
								[defaults integerForKey:LLSynthEyeXKey]] floatValue] / 1000.0;
	}

// Bundle the data into an array.  If the channel is disabled, nil is returned.  If the 
// data length is zero, nil is returned.

	otherData = [NSMutableData dataWithLength:[xData length]];		// an array of zeros
	for (index = 0; index < kLLSynthADChannels; index++) {
		if (!(sampleChannels & (0x1 << index)) || [xData length] == 0) {
			sampleData[index] = nil;
			continue;
		}
		if (index == xChannel) {
			sampleData[index] = xData;
		}
		else if (index == yChannel) {
			sampleData[index] = yData;
		}
		else {
			sampleData[index] = otherData;
		}
	}
	return sampleData;
}

- (void)setEyeTargetOff;
{
    eyeTargetPresent = NO;
}

- (void)setEyeTargetOn:(NSPoint)target;
{
	if (rand() % 1000 > [defaults floatForKey:LLSynthEyeIgnoreKey] * 1000.0) {
        eyeTargetDeg = target;
        eyeTargetPresent = YES;
    }
}

- (void)setNextSaccadeTimeS:(double)nextTimeS;
{
	nextSaccadeTimeS = nextTimeS;
}

// The offsetDeg is applied after all transforms are made.  This is useful for keeping
// the synthetic eye positions aligned with different fixation offset.  

- (void)setOffsetDeg:(NSPoint)newOffset;
{
	offsetDeg = newOffset;
}

// We can change the sample period, but all sample channels must have the sample sample period

- (BOOL)setSamplePeriodMS:(float)newPeriodMS channel:(long)channel;
{
	if (channel >= [samplePeriodMS count]) {
		NSRunAlertPanel(@"LLDataDevice",  
				@"Attempt to set sample period %d of %d for device %@",
				@"OK", nil, nil, channel, [samplePeriodMS count], [self name]);
		exit(0);
	}
	[samplePeriodMS removeAllObjects];
	for (channel = 0; channel < kLLSynthADChannels; channel++) {
		[samplePeriodMS addObject:[NSNumber numberWithFloat:newPeriodMS]];
	}
	return YES;
}

- (void)setSpikePeriodic;
{
	[defaults setBool:NO forKey:LLSynthSpikesRandomKey];
}

- (void)setSpikeRandom;
{
	[defaults setBool:YES forKey:LLSynthSpikesRandomKey];
}

- (void)setSpikeRateHz:(double)rate atTime:(double)changeTimeS {

    nextSpikeRateHz = rate;
    nextRateTimeS = changeTimeS;
    nextSpikeTimeS = MIN(nextSpikeTimeS, changeTimeS + 1.0 / spikeRateHz);
}

- (void)spikeData;
{
	short timestamp;
    long  channel, theChannel, inverseProb, VBLBit, ticksPerMS, activeChannels, c;
	long channels[kLLSynthDigitalBits];
    double timeNowS, channelRateHz, lastChannelTimeS, channelNextRateTimeS;
	NSArray *activeSpikes;
		
    timeNowS = [LLSystemUtil getTimeS];
    if (spikeRateHz == 0) {
        if (![self checkSpikeRateChange:timeNowS]) {
            return;
        }
    }
	activeSpikes = [defaults arrayForKey:LLSynthActiveSpikeChannelsKey];
	if ([activeSpikes count] == 0) {
		return;
	}
	VBLBit = [defaults integerForKey:LLSynthVBLKey];

// Load an array with a list of all the spike channels that are both active and
// enabled (and not the VBL channel

	for (channel = activeChannels = 0; channel < kLLSynthDigitalBits; channel++) {
		if (channel != VBLBit && (timestampChannels & (0x1 << channel)) != 0) {
			for (c = 0; c < [activeSpikes count]; c++) {
				if ([[activeSpikes objectAtIndex:c] intValue] == channel) {
					channels[activeChannels++] = channel;
					timestampData[channel] = [NSMutableData dataWithLength:0];
					break;
				}
			}
		}
	}
	if (activeChannels == 0) {
		return;
	}
	
// For periodic spiking, return a spike for each active channel for each rate period 

    if (![defaults boolForKey:LLSynthSpikesRandomKey]) {
        if (timeNowS < nextSpikeTimeS) {		// if no spikes, check for rate change
            if (![self checkSpikeRateChange:timeNowS]) {
                return;
            }
        }
        if (timeNowS < nextSpikeTimeS) {		// check again after rate change
            return;
        }
		while (timeNowS >= nextSpikeTimeS) {
			for (channel = 0; channel < activeChannels; channel++) {
				theChannel = channels[channel];
				timestamp = (nextSpikeTimeS - timestampRefS) * 
								(1000.0 / [[timestampPeriodMS objectAtIndex:theChannel] floatValue]);
				[timestampData[theChannel] appendBytes:&timestamp length:sizeof(short)];
			}
			nextSpikeTimeS += 1.0 / spikeRateHz;
			[self checkSpikeRateChange:nextSpikeTimeS];	// check whether spike time increment changes rate
		}
    }

// For random spikes, spikes at random times at the appropriate rate

	else {
		for (channel = 0; channel < activeChannels; channel++) {
			theChannel = channels[channel];
			ticksPerMS = (1.0 / [[timestampPeriodMS objectAtIndex:theChannel] floatValue]);
			channelRateHz = spikeRateHz;
			channelNextRateTimeS = nextRateTimeS;
			inverseProb = 1000.0 * ticksPerMS / channelRateHz;
			for (lastChannelTimeS = lastSpikeTimeS; lastChannelTimeS < timeNowS; 
									lastChannelTimeS += 0.001 / ticksPerMS) {
				if (channelNextRateTimeS > 0 && lastChannelTimeS > channelNextRateTimeS) {		// check for rate change
					channelRateHz = nextSpikeRateHz;
					inverseProb = 1000.0 * ticksPerMS / channelRateHz;
					channelNextRateTimeS = -1;
				}
				if ((rand() % inverseProb) == 0) {
					timestamp = (lastChannelTimeS - timestampRefS) * 1000.0 * ticksPerMS;
					[timestampData[theChannel] appendBytes:&timestamp length:sizeof(short)];
				}
			}
		}
		lastSpikeTimeS = timeNowS;												// update spike time
		if (nextRateTimeS > 0 && nextSpikeTimeS > nextRateTimeS) {				// update spike rate
			spikeRateHz = nextSpikeRateHz;	
			nextRateTimeS = -1;
		}
	}
}

- (NSData **)timestampData;
{
	long channel;
	
    if (!dataEnabled) {							// do nothing if data is not enabled
        return nil;
    }
	if (timestampChannels == 0) {
		nextSpikeTimeS = lastSpikeTimeS = nextVBLTimeS = [LLSystemUtil getTimeS];
		return nil;
	}
	for (channel = 0; channel < kLLSynthDigitalBits; channel++) {
		timestampData[channel] = nil;
	}
	[self spikeData];
	[self VBLData];
	return timestampData;
}

- (void)updateEyePosition:(double)timeNowS {

    BOOL fixate;
	float eyeSamplePeriod;
    double deltaS, noChangeProb, spontBreaksPerS, calibration;
	    
// If we are in the miadde of the saccade, do the next step of for the saccade
    
    if (saccade != nil) {
        eyePosition = [saccade nextPosition];
        if ([saccade done]) {
            [saccade release];
            saccade = nil;
            nextSaccadeTimeS = timeNowS + [defaults floatForKey:LLSynthEyeIntervalKey] / 1000.0;
        }
    }

// Otherwise, if it is time for a saccade, initialize one

    else if (timeNowS > nextSaccadeTimeS) {
        if (eyeTargetPresent) {
            fixate = YES;
			spontBreaksPerS =[defaults floatForKey:LLSynthEyeBreakKey];
            if (spontBreaksPerS > 0 && lastSpontBreakCheckTimeS > 0) {
                deltaS = timeNowS - lastSpontBreakCheckTimeS;
                noChangeProb = exp(deltaS * log(1.0 - spontBreaksPerS)); 
                fixate = (rand() % 1000 <= noChangeProb * 1000.0);
            }
            lastSpontBreakCheckTimeS = timeNowS;
        }
        else {
            fixate = NO;
        }
		calibration = [degToUnits transformSize:NSMakeSize(1.0, 1.0)].height;
		eyeSamplePeriod = [[samplePeriodMS objectAtIndex:[defaults integerForKey:LLSynthEyeXKey]]
										floatValue];
        if (fixate) {
			saccade = [[LLSynthSaccade alloc] initFrom:(NSPoint)eyePosition
                        to:[degToUnits transformPoint:
						NSMakePoint(eyeTargetDeg.x + offsetDeg.x, eyeTargetDeg.y + offsetDeg.y)]
                        samplePerMS:eyeSamplePeriod	unitsPerDeg:calibration];
        }
        else {
            saccade = [[LLSynthSaccade alloc] initFrom:(NSPoint)eyePosition
                        samplePerMS:eyeSamplePeriod	unitsPerDeg:calibration];
            lastSpontBreakCheckTimeS = 0;
        }
        eyePosition = [saccade nextPosition];
    } 
}

- (void)VBLData;
{
	short timestamp, VBLChannel;
	long ticksPerS;
    float VBLRateHz;
	double timeNow;
		
	VBLRateHz = [defaults floatForKey:LLSynthVBLRateKey];
    if (VBLRateHz == 0) {
		return;
	}
	timeNow = [LLSystemUtil getTimeS];
	if (timeNow < nextVBLTimeS) {
		return;
	}
	VBLChannel = [defaults integerForKey:LLSynthVBLKey];
	if ((timestampChannels & (0x1 << VBLChannel)) == 0) {
		return;
	}
	ticksPerS = (1000.0 / [[timestampPeriodMS objectAtIndex:VBLChannel] longValue]);
	timestampData[VBLChannel] = [NSMutableData dataWithLength:0];
	while (timeNow >= nextVBLTimeS) {
		timestamp = (nextVBLTimeS - timestampRefS) * ticksPerS;
		[timestampData[VBLChannel] appendBytes:&timestamp length:sizeof(short)];
		nextVBLTimeS += 1.0 / VBLRateHz;
	}
}

@end
