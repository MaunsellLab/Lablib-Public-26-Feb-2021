/*
RFMapStimuli.h
*/

#define kAngleStep                3
#define kCircleSteps            (360 / kAngleStep)

@interface RFMapStimuli : NSObject {

    LLBar                    *bar;
    long                    displayIndex;
    long                    displayMode;
    LLDisplays                *displays;
    BOOL                    doMouseGate;
    LLRandomDots            *dots;
    LLRandomDots            *dots2;
    float                    fixSizePix;
    LLFixTarget                *fixSpot;
    BOOL                    fixSpotOn;
    LLGabor                 *gabor;
    NSArray                    *keys;
    LLIntervalMonitor        *monitor;
    BOOL                    mouseButtonDown;
    BOOL                    mouseIsDown;
    LLPlaid                    *plaid;
    float                    rotationCos[kCircleSteps];
    float                    rotationSin[kCircleSteps];
    long                    stimType;
    BOOL                    stimulusOn;
    BOOL                    stimVisible;
    BOOL                    stopStimulus;
}

- (void)changeSize:(float)factor;
- (void)changeWidth:(float)factor;
- (void)doStimSettings;
- (void)erase;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLFixTarget *fixSpot;
- (void)initializeStimuli;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLIntervalMonitor *monitor;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL mouseDown;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL mouseUp;
- (void)releaseStimuli;
- (void)rotate:(float)deltaDeg;
- (void)startStimulus;
@property (NS_NONATOMIC_IOSONLY, readonly) BOOL stimulusOn;
- (void)stopStimulus;

@end
