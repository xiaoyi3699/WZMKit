//
//  WZMImageresizerFrameView.h
//  DesignSpaceRestructure
//
//  Created by 周健平 on 2017/12/11.
//  Copyright © 2017年 周健平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMImageresizerTypedef.h"

@interface WZMImageresizerFrameView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                  contentSize:(CGSize)contentSize
                     maskType:(WZMImageresizerMaskType)maskType
                    frameType:(WZMImageresizerFrameType)frameType
               animationCurve:(WZMAnimationCurve)animationCurve
                  strokeColor:(UIColor *)strokeColor
                    fillColor:(UIColor *)fillColor
                    maskAlpha:(CGFloat)maskAlpha
                verBaseMargin:(CGFloat)verBaseMargin
                horBaseMargin:(CGFloat)horBaseMargin
                resizeWHScale:(CGFloat)resizeWHScale
                   scrollView:(UIScrollView *)scrollView
                    imageView:(UIImageView *)imageView
    imageresizerIsCanRecovery:(WZMImageresizerIsCanRecoveryBlock)imageresizerIsCanRecovery
 imageresizerIsPrepareToScale:(WZMImageresizerIsPrepareToScaleBlock)imageresizerIsPrepareToScale;

@property (nonatomic, assign, readonly) WZMImageresizerMaskType maskType;

@property (nonatomic, assign, readonly) WZMImageresizerFrameType frameType;

@property (nonatomic, weak, readonly) UIPanGestureRecognizer *panGR;

@property (nonatomic, assign) WZMAnimationCurve animationCurve;

@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) CGFloat maskAlpha;

@property (nonatomic, assign, readonly) CGRect imageresizerFrame;

@property (nonatomic, assign) CGFloat resizeWHScale;
- (void)setResizeWHScale:(CGFloat)resizeWHScale animated:(BOOL)isAnimated;

@property (nonatomic, assign) BOOL edgeLineIsEnabled;

@property (nonatomic, assign, readonly) BOOL isCanRecovery;
@property (nonatomic, copy) WZMImageresizerIsCanRecoveryBlock imageresizerIsCanRecovery;

@property (nonatomic, assign, readonly) BOOL isPrepareToScale;
@property (nonatomic, copy) WZMImageresizerIsPrepareToScaleBlock imageresizerIsPrepareToScale;

@property (nonatomic, assign, readonly) WZMImageresizerRotationDirection rotationDirection;

@property (nonatomic, readonly) BOOL isHorizontalDirection;

@property (nonatomic, assign, readonly) CGFloat sizeScale;

@property (nonatomic, assign, readonly) CGFloat scrollViewMinZoomScale;

@property (nonatomic, assign) BOOL isRotatedAutoScale;

@property (nonatomic, copy) BOOL (^isVerticalityMirror)(void);
@property (nonatomic, copy) BOOL (^isHorizontalMirror)(void);

- (void)updateFrameType:(WZMImageresizerFrameType)frameType;

- (void)updateImageresizerFrameWithVerBaseMargin:(CGFloat)verBaseMargin horBaseMargin:(CGFloat)horBaseMargin;

- (void)startImageresizer;
- (void)endedImageresizer;

- (void)rotationWithDirection:(WZMImageresizerRotationDirection)direction rotationDuration:(NSTimeInterval)rotationDuration;

- (void)willRecovery;
- (void)recoveryWithDuration:(NSTimeInterval)duration;
- (void)recoveryDone;

- (void)willMirror:(BOOL)animated;
- (void)verticalityMirrorWithDiffX:(CGFloat)diffX;
- (void)horizontalMirrorWithDiffY:(CGFloat)diffY;
- (void)mirrorDone;

- (void)imageresizerWithComplete:(void(^)(UIImage *resizeImage))complete isOriginImageSize:(BOOL)isOriginImageSize referenceWidth:(CGFloat)referenceWidth;

@end
