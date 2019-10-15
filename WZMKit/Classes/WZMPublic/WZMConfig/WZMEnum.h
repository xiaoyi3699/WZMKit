//
//  WZMEnum.h
//  WZMFoundation
//
//  Created by WangZhaomeng on 2017/7/5.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#ifndef WZMEnum_h
#define WZMEnum_h

///导航栏颜色
typedef enum : NSInteger {
    WZMStatusBarStyleDefault         = 0, //黑色
    WZMStatusBarStyleLightContent,        //白色
} WZMStatusBarStyle;

///打开AppStore的方式
typedef enum : NSInteger {
    WZMAppScoreTypeOpen  = 0,//AppStore
    WZMAppScoreTypeInApp,    //应用内
} WZMAppScoreType;

///手势类型
typedef enum : NSInteger {
    WZMGestureRecognizerTypeSingle  = 0,
    WZMGestureRecognizerTypeDouble,
    WZMGestureRecognizerTypeLong,
    WZMGestureRecognizerTypeClose,
} WZMGestureRecognizerType;

///滑动状态
typedef enum : NSInteger {
    WZMScrollTypeBeginScroll  = 0,
    WZMScrollTypeScrolling,
    WZMScrollTypeEndScroll,
} WZMScrollType;

///转场动画
typedef enum : NSInteger {
    Fade                = 1,   //淡入淡出
    Push,                      //推挤
    Reveal,                    //揭开
    MoveIn,                    //覆盖
    Cube,                      //立方体
    SuckEffect,                //吮吸
    OglFlip,                   //翻转
    RippleEffect,              //波纹
    PageCurl,                  //翻页
    PageUnCurl,                //反翻页
    CameraIrisHollowOpen,      //开镜头
    CameraIrisHollowClose,     //关镜头
    CurlDown,                  //下翻页
    CurlUp,                    //上翻页
    FlipFromLeft,              //左翻转
    FlipFromRight,             //右翻转
} AnimationType;

///导航转场动滑类型
typedef enum : NSInteger {
    WZMNavAnimationTypeNormal = 0,
    WZMNavAnimationTypeScroll,
    WZMNavAnimationTypeAlbum,
} WZMNavAnimationType;

///模态转场动滑类型
typedef enum : NSInteger {
    WZMModalAnimationTypeNormal = 0,
    WZMModalAnimationTypeScroll,
    WZMModalAnimationTypeZoom,
} WZMModalAnimationType;

///tableHeaderView动画
typedef enum : NSInteger {
    WZMAutoHeaderAnimationNon   = -1, //无动画
    WZMAutoHeaderAnimationScale = 0,  //按比例缩放
    WZMAutoHeaderAnimationFill  = 1,  //拉伸填充
}WZMAutoHeaderAnimation;

///弹框样式
typedef enum : NSInteger {
    WZMAlertViewTypeNormal = 0,
    WZMAlertViewTypeUpdate,
}WZMAlertViewType;

///弹出框动画
typedef enum : NSInteger {
    WZMAnimationStyleOutFromCenterNone = 0,  //从中心，由小到大弹出，无弹性动画
    WZMAnimationStyleOutFromCenterAnimation, //从中心，由小到大弹出，有弹性动画
    WZMAnimationStyleFromDownAnimation,      //从底部弹出
    
} WZMAnimationStyle;

///阴影样式
typedef enum : NSInteger {
    WZMShadowTypeAll,         //四个边阴影
    WZMShadowTypeTopLeft,     //两个变阴影(左上角)
    WZMShadowTypeTopRight,    //两个变阴影(右上角)
    WZMShadowTypeBottomLeft,  //两个变阴影(左下角)
    WZMShadowTypeBottomRight  //两个变阴影(右下角)
} WZMShadowType;

///屏幕方向
typedef enum : NSInteger {
    WZMLaunchImageTypePortrait = 0, //竖屏
    WZMLaunchImageTypeLandscape     //横屏
} WZMLaunchImageType;

///梯度方向
typedef enum : NSInteger {
    WZMGradientTypeLeftToRight = 0,       //从左到右
    WZMGradientTypeTopToBottom = 1,       //从上到下
    WZMGradientTypeUpleftToLowright = 2,  //左上到右下
    WZMGradientTypeUprightToLowleft = 3,  //右上到左下
} WZMGradientType;

///摄像头方向
typedef enum : NSInteger {
    WZMCaptureDevicePositionUnspecified = 0,
    WZMCaptureDevicePositionBack        = 1,
    WZMCaptureDevicePositionFront       = 2,
} WZMCaptureDevicePosition;

///键盘上方工具栏样式
typedef enum : NSInteger {
    WZMInputAccessoryTypeDone,
    WZMInputAccessoryTypeCancel,
    WZMInputAccessoryTypeAll,
} WZMInputAccessoryType;

///输入框MenuItem样式
typedef enum : NSInteger {
    WZMPerformActionTypeNormal,
    WZMPerformActionTypeNone,
} WZMPerformActionType;

///输入框事件
typedef enum : NSUInteger {
    WZMTextInputTypeBegin = 0,
    WZMTextInputTypeChange,
    WZMTextInputTypeEnd,
} WZMTextInputType;

///输入框事件
typedef enum : NSUInteger {
    WZMTextShouldTypeBegin = 0,
    WZMTextShouldTypeEnd,
    WZMTextShouldTypeReturn,
    WZMTextShouldTypeClear, //textField
} WZMTextShouldType;

///取值方式
typedef enum : NSInteger {
    WZMTakingValueStyleMin, //最小值
    WZMTakingValueStyleMax, //最大值
    WZMTakingValueStyleAvg, //平均值
    WZMTakingValueStyleSum, //求和
} WZMTakingValueStyle;

///网络状态
typedef enum : NSInteger {
    WZMNetWorkStatusUnknown,
    WZMNetWorkStatus2G,
    WZMNetWorkStatus3G,
    WZMNetWorkStatus4G,
    WZMNetWorkStatusWifi,
} WZMNetWorkStatus;

//数据返回格式
typedef enum : NSInteger {
    WZMNetResultContentTypeJson = 0, //json
    WZMNetResultContentTypeData,     //源数据
} WZMNetResultContentType;

///文件管理
typedef enum : NSInteger {
    WZMNotFound          = 404, //路径未找到
    WZMIsNotDirectory           //不是文件夹
}WZMFileManagerError;

///应用类型
typedef enum : NSInteger {
    mqq           = 0, //QQ
    weixin,            //微信
    sinaweibo,         //新浪微博
    alipay,            //支付宝
    taobao,            //淘宝
} WZMAPPType;

///图片格式
typedef enum : NSInteger {
    WZMImageTypeUnknown  = -1,
    WZMImageTypePNG      = 0,
    WZMImageTypeJPEG,
    WZMImageTypeGIF,
    WZMImageTypeTIFF,
    WZMImageTypeWEBP,
} WZMImageType;

///图片拼接
typedef enum : NSInteger {
    WZMAddImageTypeHorizontal= 0,
    WZMAddImageTypeVertical,
} WZMAddImageType;

///相册资源文件格式
typedef enum : NSUInteger {
    WZMAlbumPhotoTypePhoto = 0,
    WZMAlbumPhotoTypeLivePhoto,
    WZMAlbumPhotoTypePhotoGif,
    WZMAlbumPhotoTypeVideo,
    WZMAlbumPhotoTypeAudio
} WZMAlbumPhotoType;

///通用状态
typedef enum : NSInteger {
    WZMCommonStateWillChanged = 0,
    WZMCommonStateDidChanged,
    WZMCommonStateEndChanged,
} WZMCommonState;

#endif /* WZMEnum_h */
