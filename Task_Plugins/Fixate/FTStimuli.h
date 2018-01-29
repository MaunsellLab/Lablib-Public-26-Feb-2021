/*
FTStimuli.h
*/

@interface FTStimuli : NSObject {

    float                    fixSizePix;
    LLFixTarget                *fixSpot;
    BOOL                    fixSpotOn;
}

- (void)drawFixSpot;
- (void)erase;
@property (NS_NONATOMIC_IOSONLY, readonly, strong) LLFixTarget *fixSpot;

@end
