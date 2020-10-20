//
//  WZMImageresizerConfigure.m
//  WZMImageresizerView
//
//  Created by 周健平 on 2018/4/22.
//

#import "WZMImageresizerConfigure.h"

@implementation WZMImageresizerConfigure

+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void (^)(WZMImageresizerConfigure *))make {
    WZMImageresizerConfigure *configure = [[self alloc] init];
    configure.resizeImage = resizeImage;
    configure.viewFrame = [UIScreen mainScreen].bounds;
    configure.maskAlpha = LVNormalMaskType;
    configure.frameType = LVConciseFrameType;
    configure.animationCurve = WZMAnimationCurveEaseOut;
    configure.strokeColor = [UIColor whiteColor];
    configure.bgColor = [UIColor blackColor];
    configure.maskAlpha = 0.75;
    configure.verBaseMargin = 10.0;
    configure.horBaseMargin = 10.0;
    configure.resizeWHScale = 0.0;
    configure.edgeLineIsEnabled = YES;
    configure.contentInsets = UIEdgeInsetsZero;
    !make ? : make(configure);
    return configure;
}

- (void)setFrameType:(WZMImageresizerFrameType)frameType {
    _frameType = frameType;
}

- (void)setAnimationCurve:(WZMAnimationCurve)animationCurve {
    _animationCurve = animationCurve;
}

+ (instancetype)blurMaskTypeConfigureWithResizeImage:(UIImage *)resizeImage isLight:(BOOL)isLight make:(void (^)(WZMImageresizerConfigure *))make {
    WZMImageresizerMaskType maskType = isLight ? LVLightBlurMaskType : LVDarkBlurMaskType;
    WZMImageresizerConfigure *configure = [self defaultConfigureWithResizeImage:resizeImage make:^(WZMImageresizerConfigure *configure) {
        configure.jp_maskType(maskType).jp_maskAlpha(0.3);
    }];
    !make ? : make(configure);
    return configure;
}

- (void)setMaskType:(WZMImageresizerMaskType)maskType {
    _maskType = maskType;
    if (maskType == LVLightBlurMaskType) {
        self.bgColor = [UIColor whiteColor];
    } else if (maskType == LVDarkBlurMaskType) {
        self.bgColor = [UIColor blackColor];
    }
}

- (void)setBgColor:(UIColor *)bgColor {
    if (self.maskType == LVLightBlurMaskType) {
        _bgColor = [UIColor whiteColor];
    } else if (self.maskType == LVDarkBlurMaskType) {
        _bgColor = [UIColor blackColor];
    } else {
        _bgColor = bgColor;
    }
}

- (WZMImageresizerConfigure *(^)(UIImage *resizeImage))jp_resizeImage {
    return ^(UIImage *resizeImage) {
        self.resizeImage = resizeImage;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(CGRect viewFrame))jp_viewFrame {
    return ^(CGRect viewFrame) {
        self.viewFrame = viewFrame;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(WZMImageresizerMaskType maskType))jp_maskType {
    return ^(WZMImageresizerMaskType maskType) {
        self.maskType = maskType;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(WZMImageresizerFrameType frameType))jp_frameType {
    return ^(WZMImageresizerFrameType frameType) {
        self.frameType = frameType;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(WZMAnimationCurve animationCurve))jp_animationCurve {
    return ^(WZMAnimationCurve animationCurve) {
        self.animationCurve = animationCurve;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(UIColor *strokeColor))jp_strokeColor {
    return ^(UIColor *strokeColor) {
        self.strokeColor = strokeColor;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(UIColor *bgColor))jp_bgColor {
    return ^(UIColor *bgColor) {
        self.bgColor = bgColor;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(CGFloat maskAlpha))jp_maskAlpha {
    return ^(CGFloat maskAlpha) {
        self.maskAlpha = maskAlpha;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(CGFloat resizeWHScale))jp_resizeWHScale {
    return ^(CGFloat resizeWHScale) {
        self.resizeWHScale = resizeWHScale;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(BOOL edgeLineIsEnabled))jp_edgeLineIsEnabled {
    return ^(BOOL edgeLineIsEnabled) {
        self.edgeLineIsEnabled = edgeLineIsEnabled;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(CGFloat verBaseMargin))jp_verBaseMargin {
    return ^(CGFloat verBaseMargin) {
        self.verBaseMargin = verBaseMargin;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(CGFloat horBaseMargin))jp_horBaseMargin {
    return ^(CGFloat horBaseMargin) {
        self.horBaseMargin = horBaseMargin;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(UIEdgeInsets contentInsets))jp_contentInsets {
    return ^(UIEdgeInsets contentInsets) {
        self.contentInsets = contentInsets;
        return self;
    };
}

- (WZMImageresizerConfigure *(^)(BOOL isClockwiseRotation))jp_isClockwiseRotation {
    return ^(BOOL isClockwiseRotation) {
        self.isClockwiseRotation = isClockwiseRotation;
        return self;
    };
}

@end
