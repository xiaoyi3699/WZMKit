//
//  WZMImageresizerConfigure.h
//  WZMImageresizerView
//
//  Created by 周健平 on 2018/4/22.
//
//  WZMImageresizerConfigure：用于配置初始化参数

#import <UIKit/UIKit.h>
#import "WZMImageresizerTypedef.h"

@interface WZMImageresizerConfigure : NSObject
/**
 * 默认参数值：
    - viewFrame = [UIScreen mainScreen].bounds;
    - maskAlpha = LVNormalMaskType;
    - frameType = LVConciseFrameType;
    - animationCurve = WZMAnimationCurveLinear;
    - strokeColor = [UIColor whiteColor];
    - bgColor = [UIColor blackColor];
    - maskAlpha = 0.75;
    - verBaseMargin = 10.0;
    - horBaseMargin = 10.0;
    - resizeWHScale = 0.0;
    - contentInsets = UIEdgeInsetsZero;
 */
+ (instancetype)defaultConfigureWithResizeImage:(UIImage *)resizeImage make:(void(^)(WZMImageresizerConfigure *configure))make;

+ (instancetype)blurMaskTypeConfigureWithResizeImage:(UIImage *)resizeImage isLight:(BOOL)isLight make:(void (^)(WZMImageresizerConfigure *configure))make;

/** 裁剪图片 */
@property (nonatomic, strong) UIImage *resizeImage;

/** 视图区域 */
@property (nonatomic, assign) CGRect viewFrame;

/** 遮罩样式 */
@property (nonatomic, assign) WZMImageresizerMaskType maskType;

/** 边框样式 */
@property (nonatomic, assign) WZMImageresizerFrameType frameType;

/** 动画曲线 */
@property (nonatomic, assign) WZMAnimationCurve animationCurve;

/** 裁剪线颜色 */
@property (nonatomic, strong) UIColor *strokeColor;

/** 背景颜色 */
@property (nonatomic, strong) UIColor *bgColor;

/** 遮罩颜色的透明度（背景颜色 * 透明度） */
@property (nonatomic, assign) CGFloat maskAlpha;

/** 裁剪宽高比（0则为任意比例，可控8个方向，固定比例为4个方向） */
@property (nonatomic, assign) CGFloat resizeWHScale;

/** 裁剪框边线能否进行对边拖拽（当裁剪宽高比为0，即任意比例时才有效，默认为yes） */
@property (nonatomic, assign) BOOL edgeLineIsEnabled;

/** 裁剪图片与裁剪区域的垂直边距 */
@property (nonatomic, assign) CGFloat verBaseMargin;

/** 裁剪图片与裁剪区域的水平边距 */
@property (nonatomic, assign) CGFloat horBaseMargin;

/** 裁剪区域与主视图的内边距 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;

/** 是否顺时针旋转 */
@property (nonatomic, assign) BOOL isClockwiseRotation;


@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_resizeImage)(UIImage *resizeImage);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_viewFrame)(CGRect viewFrame);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_maskType)(WZMImageresizerMaskType maskType);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_frameType)(WZMImageresizerFrameType frameType);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_animationCurve)(WZMAnimationCurve animationCurve);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_strokeColor)(UIColor *strokeColor);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_bgColor)(UIColor *bgColor);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_maskAlpha)(CGFloat maskAlpha);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_resizeWHScale)(CGFloat resizeWHScale);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_edgeLineIsEnabled)(BOOL edgeLineIsEnabled);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_verBaseMargin)(CGFloat verBaseMargin);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_horBaseMargin)(CGFloat horBaseMargin);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_contentInsets)(UIEdgeInsets contentInsets);
@property (nonatomic, copy, readonly) WZMImageresizerConfigure *(^jp_isClockwiseRotation)(BOOL isClockwiseRotation);

@end
