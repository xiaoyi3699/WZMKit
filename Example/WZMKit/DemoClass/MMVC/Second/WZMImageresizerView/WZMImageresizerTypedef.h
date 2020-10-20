//
//  WZMImageresizerTypedef.h
//  Pods
//
//  Created by 周健平 on 2018/4/22.
//
//  WZMImageresizerTypedef：公共类型定义

#pragma mark - 枚举

/**
 * 遮罩样式
 * LVNormalMaskType：    通常类型，bgColor能任意设置
 * LVLightBlurMaskType： 明亮高斯模糊，bgColor强制为白色，maskAlpha可自行修改，建议为0.3
 * LVDarkBlurMaskType：  暗黑高斯模糊，bgColor强制为黑色，maskAlpha可自行修改，建议为0.3
 */
typedef NS_ENUM(NSUInteger, WZMImageresizerMaskType) {
    LVNormalMaskType, // default
    LVLightBlurMaskType,
    LVDarkBlurMaskType
};

/**
 * 边框样式
 * WZMConciseFrameType：               简洁样式，可拖拽8个方向（固定比例则4个方向）
 * WZMConciseWithoutOtherDotFrameType：简洁样式，可拖拽4个方向（4角）
 * LVClassicFrameType：               经典样式，类似微信的裁剪边框样式，可拖拽4个方向
 */
typedef NS_ENUM(NSUInteger, WZMImageresizerFrameType) {
    WZMConciseFrameType, // default
    WZMConciseWithoutOtherDotFrameType,
    LVClassicFrameType
};

/**
 * 动画曲线
 * WZMAnimationCurveEaseInOut：慢进慢出，中间快
 * WZMAnimationCurveEaseIn：   由慢到快
 * WZMAnimationCurveEaseOut：  由快到慢
 * WZMAnimationCurveLinear：   匀速
 */
typedef NS_ENUM(NSUInteger, WZMAnimationCurve) {
    WZMAnimationCurveEaseInOut, // default
    WZMAnimationCurveEaseIn,
    WZMAnimationCurveEaseOut,
    WZMAnimationCurveLinear
};

/**
 * 当前方向
 * WZMImageresizerVerticalUpDirection：     垂直向上
 * WZMImageresizerHorizontalLeftDirection： 水平向左
 * WZMImageresizerVerticalDownDirection：   垂直向下
 * WZMImageresizerHorizontalRightDirection：水平向右
 */
typedef NS_ENUM(NSUInteger, WZMImageresizerRotationDirection) {
    WZMImageresizerVerticalUpDirection = 0,  // default
    WZMImageresizerHorizontalLeftDirection,
    WZMImageresizerVerticalDownDirection,
    WZMImageresizerHorizontalRightDirection
};

#pragma mark - Block

/**
 * 是否可以重置的回调
 * 当裁剪区域缩放至适应范围后就会触发该回调
    - YES：可重置
    - NO：不需要重置，裁剪区域跟图片区域一致，并且没有旋转、镜像过
 */
typedef void(^WZMImageresizerIsCanRecoveryBlock)(BOOL isCanRecovery);

/**
 * 是否预备缩放裁剪区域至适应范围
 * 当裁剪区域发生变化的开始和结束就会触发该回调
    - YES：预备缩放，此时裁剪、旋转、镜像功能不可用
    - NO：没有预备缩放
 */
typedef void(^WZMImageresizerIsPrepareToScaleBlock)(BOOL isPrepareToScale);
