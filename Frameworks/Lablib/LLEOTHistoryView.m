//
//  EOTHistoryView.m
//
//  Created by Geoff Ghose on Wed Aug 11 2004.
//  Copyright (c) 2004. All rights reserved.
//

#import "LLStandardDataEvents.h"
#import "LLEOTHistoryView.h"

@implementation LLEOTHistoryView

- (void)addEOT:(short)eotCode {

	long index;

	if (counter < bins) {
		EOTHistory[counter++] = eotCode;
	}
	else {
		for(index = 0; index < (bins - 1); index++) {
			EOTHistory[index] = EOTHistory[index + 1];
		}
		EOTHistory[bins - 1] = eotCode;
	}
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay:YES];
    });
}

- (void)drawRect:(NSRect)rect {

    long index;
	float binWidth, binOffset;
    NSRect r;
    
    r = [self bounds];
    NSEraseRect(r);
	if (counter > 0) {
		binWidth = NSWidth(r) / bins;
		binOffset = NSMinX(r) + (bins - counter) * binWidth; 
		for (index = 0; index < counter; index++) {
			[[LLStandardDataEvents eotColor:EOTHistory[index]] set];
			[NSBezierPath fillRect:NSMakeRect(binOffset, NSMinY(r), 
				binOffset + binWidth, NSMaxY(r))];
			binOffset += binWidth;
		}
		[[NSColor blackColor] set];
		[NSBezierPath strokeRect:r];
	}
}

- (id)initWithFrame:(NSRect)frame {

    if ((self = [super initWithFrame:frame]) != nil) {
		[self setBins:50];
    }
    return self;
}

// Overwrite isOpaque to improve performance

- (BOOL)isOpaque;
{
	return YES;
}

- (void)reset {

	counter = 0;
}

- (void)setBins:(long)newBins {

	bins = MIN(newBins, kLLEOTHistMaxBins);
	counter = MIN(bins, counter);
}

@end

