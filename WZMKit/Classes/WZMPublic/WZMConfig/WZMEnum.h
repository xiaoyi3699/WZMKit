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
typedef NS_ENUM(NSInteger, WZMStatusBarStyle) {
    WZMStatusBarStyleDefault         = 0, //黑色
    WZMStatusBarStyleLightContent         //白色
};

///打开AppStore的方式
typedef NS_ENUM(NSInteger, WZMAppStoreType) {
    WZMAppStoreTypeOpen  = 0,//AppStore
    WZMAppStoreTypeInApp     //应用内
};

///手势类型
typedef NS_ENUM(NSInteger, WZMGestureRecognizerType) {
    WZMGestureRecognizerTypeSingle  = 0,
    WZMGestureRecognizerTypeDouble,
    WZMGestureRecognizerTypeLong,
    WZMGestureRecognizerTypeClose
};

///手势方向
typedef NS_ENUM(NSInteger, WZMPanGestureRecognizerDirection) {
    WZMPanGestureRecognizerDirectionAll = 0,
    WZMPanGestureRecognizerDirectionVertical,
    WZMPanGestureRecognizerDirectionHorizontal,
    WZMPanGestureRecognizerDirectionNone
};

///垂直手势方向
typedef NS_ENUM(NSInteger, WZMPanGestureRecognizerVerticalDirection) {
    WZMPanGestureRecognizerVerticalDirectionAll = 0,
    WZMPanGestureRecognizerVerticalDirectionUp,
    WZMPanGestureRecognizerVerticalDirectionDown
};

///水平手势方向
typedef NS_ENUM(NSInteger, WZMPanGestureRecognizerHorizontalDirection) {
    WZMPanGestureRecognizerHorizontalDirectionAll = 0,
    WZMPanGestureRecognizerHorizontalDirectionLeft,
    WZMPanGestureRecognizerHorizontalDirectionRight
};

///滑动状态
typedef NS_ENUM(NSInteger, WZMScrollType) {
    WZMScrollTypeBeginScroll  = 0,
    WZMScrollTypeScrolling,
    WZMScrollTypeEndScroll
};

///转场动画
typedef NS_ENUM(NSInteger, AnimationType) {
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
    FlipFromRight              //右翻转
};

///导航转场动滑类型
typedef NS_ENUM(NSInteger, WZMNavAnimationType) {
    WZMNavAnimationTypeNormal = 0,
    WZMNavAnimationTypeScroll,
    WZMNavAnimationTypeAlbum
};

///模态转场动滑类型
typedef NS_ENUM(NSInteger, WZMModalAnimationType) {
    WZMModalAnimationTypeNormal = 0,
    WZMModalAnimationTypeScroll,
    WZMModalAnimationTypeZoom
};

///tableHeaderView动画
typedef NS_ENUM(NSInteger, WZMAutoHeaderAnimation) {
    WZMAutoHeaderAnimationNon   = -1, //无动画
    WZMAutoHeaderAnimationScale = 0,  //按比例缩放
    WZMAutoHeaderAnimationFill  = 1   //拉伸填充
};

///弹框样式
typedef NS_ENUM(NSInteger, WZMAlertViewType) {
    WZMAlertViewTypeNormal = 0,
    WZMAlertViewTypeUpdate
};

///弹出框动画
typedef NS_ENUM(NSInteger, WZMAnimationStyle) {
    WZMAnimationStyleOutFromCenterNone = 0,  //从中心，由小到大弹出，无弹性动画
    WZMAnimationStyleOutFromCenterAnimation, //从中心，由小到大弹出，有弹性动画
    WZMAnimationStyleFromDownAnimation       //从底部弹出
};

///屏幕方向
typedef NS_ENUM(NSInteger, WZMLaunchImageType) {
    WZMLaunchImageTypePortrait = 0, //竖屏
    WZMLaunchImageTypeLandscape     //横屏
};

///梯度方向
typedef NS_ENUM(NSInteger, WZMGradientType) {
    WZMGradientTypeLeftToRight = 0,       //从左到右
    WZMGradientTypeTopToBottom = 1,       //从上到下
    WZMGradientTypeUpleftToLowright = 2,  //左上到右下
    WZMGradientTypeUprightToLowleft = 3   //右上到左下
};

///摄像头方向
typedef NS_ENUM(NSInteger, WZMCaptureDevicePosition) {
    WZMCaptureDevicePositionUnspecified = 0,
    WZMCaptureDevicePositionBack        = 1,
    WZMCaptureDevicePositionFront       = 2
};

///键盘上方工具栏样式
typedef NS_ENUM(NSInteger, WZMInputAccessoryType) {
    WZMInputAccessoryTypeDone,
    WZMInputAccessoryTypeCancel,
    WZMInputAccessoryTypeAll
};

///输入框MenuItem样式
typedef NS_ENUM(NSInteger, WZMPerformActionType) {
    WZMPerformActionTypeNormal,
    WZMPerformActionTypeNone
};

///输入框事件
typedef NS_ENUM(NSInteger, WZMTextInputType) {
    WZMTextInputTypeBegin = 0,
    WZMTextInputTypeChange,
    WZMTextInputTypeEnd
};

///输入框事件
typedef NS_ENUM(NSInteger, WZMTextShouldType) {
    WZMTextShouldTypeBegin = 0,
    WZMTextShouldTypeEnd,
    WZMTextShouldTypeReturn,
    WZMTextShouldTypeClear  //textField
};

///取值方式
typedef NS_ENUM(NSInteger, WZMTakingValueStyle) {
    WZMTakingValueStyleMin, //最小值
    WZMTakingValueStyleMax, //最大值
    WZMTakingValueStyleAvg, //平均值
    WZMTakingValueStyleSum  //求和
};

///网络状态
typedef NS_ENUM(NSInteger, WZMNetWorkStatus) {
    WZMNetWorkStatusUnknown,
    WZMNetWorkStatus2G,
    WZMNetWorkStatus3G,
    WZMNetWorkStatus4G,
    WZMNetWorkStatusWifi
};

//数据返回格式
typedef NS_ENUM(NSInteger, WZMNetResultContentType) {
    WZMNetResultContentTypeJson = 0, //json
    WZMNetResultContentTypeData      //源数据
};

///文件管理
typedef NS_ENUM(NSInteger, WZMFileManagerError) {
    WZMNotFound          = 404, //路径未找到
    WZMIsNotDirectory           //不是文件夹
};

///应用类型
typedef NS_ENUM(NSInteger, WZMAPPType) {
    WZMAPPTypeOICQ = 0, //QQ
    WZMAPPTypeVaS,      //微信
    WZMAPPTypeVaB,      //新浪
    WZMAPPTypeCHP,      //支宝
    WZMAPPTypeToB       //掏宝
};

///图片格式
typedef NS_ENUM(NSInteger, WZMImageType) {
    WZMImageTypeUnknown  = -1,
    WZMImageTypePNG      = 0,
    WZMImageTypeJPEG,
    WZMImageTypeGIF,
    WZMImageTypeTIFF,
    WZMImageTypeWEBP
};

///图片拼接
typedef NS_ENUM(NSInteger, WZMAddImageType) {
    WZMAddImageTypeHorizontal= 0,
    WZMAddImageTypeVertical
};

///相册资源文件格式
typedef NS_ENUM(NSInteger, WZMAlbumPhotoType) {
    WZMAlbumPhotoTypePhoto = 0,
    WZMAlbumPhotoTypeLivePhoto,
    WZMAlbumPhotoTypePhotoGif,
    WZMAlbumPhotoTypeVideo,
    WZMAlbumPhotoTypeAudio
};

///通用状态
typedef NS_ENUM(NSInteger, WZMCommonState) {
    WZMCommonStateBegan = 0,
    WZMCommonStateChanged,
    WZMCommonStateEnded
};

#endif /* WZMEnum_h */
