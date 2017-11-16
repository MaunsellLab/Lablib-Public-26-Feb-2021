//
//  LLViewScale.h
//  Lablib
//
//  Created by John Maunsell on Fri May 02 2003.
//  Copyright (c) 2003. All rights reserved.
//

@interface LLViewScale : NSObject {

@protected
    BOOL            autoAdjustYMax;
    BOOL            autoAdjustYMin;
    NSRect            scaleRect;
    NSRect             viewRect;
    NSMutableArray    *yMaxs;
    NSMutableArray    *yMaxMinViewArray;
    NSMutableArray    *yMins;
}

- (BOOL)autoAdjustYMin:(float)yMin yMax:(float)yMax object:(id)obj;
@property (NS_NONATOMIC_IOSONLY) float height;
- (long)pixYInc:(float)yScaledInc;
- (NSPoint) scaledPoint:(NSPoint)point;
- (long)scaledX:(float)x;
- (long)scaledXInc:(float)xScaledInc;
- (long)scaledY:(float)y;
- (long)scaledYInc:(float)yScaledInc;
@property (NS_NONATOMIC_IOSONLY) NSRect scaleRect;
- (NSRect)scaledRect:(NSRect)userRect;
- (void)setAutoAdjustYMax:(BOOL)state;
- (void)setAutoAdjustYMin:(BOOL)state;
- (void)setXOrigin:(float)xOrigin width:(float)width;
- (void)setYOrigin:(float)xOrigin height:(float)height;
- (void)setViewRectForScale:(NSRect)rectPix;
@property (NS_NONATOMIC_IOSONLY, readonly) NSRect viewRect;
@property (NS_NONATOMIC_IOSONLY) float width;
@property (NS_NONATOMIC_IOSONLY, readonly) float xMax;
@property (NS_NONATOMIC_IOSONLY, readonly) float xMin;
@property (NS_NONATOMIC_IOSONLY, readonly) float yMax;
@property (NS_NONATOMIC_IOSONLY, readonly) float yMin;
@property (NS_NONATOMIC_IOSONLY) float xOrigin;
@property (NS_NONATOMIC_IOSONLY) float yOrigin;

@end
