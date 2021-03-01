//
//  WZMKit.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

/* 快速掌握WZMKit的基础使用类库和常用方法 */
//首先，项目设置 - other link 添加 $(inherited)
/*
 ------------------------------------------------------
 ====================↓ 常用类库举例 ↓====================
 ------------------------------------------------------
 
 📂 WZMImageCache: 网络图片缓存
 📂 WZMRefresh: 上拉加载、下拉刷新
 📂 WZMNetWorking: 网络请求(GET POST PUT DELETE等等)
 📂 WZMGifImageView: GIF展示, 优化了GIF图片的内存占用
 📂 WZMPhotoBrowser: 图片浏览器, 支持网络或本地, 支持GIF
 📂 WZMPlayer: 高度自定义音/视频播放, 支持播放状态回调
 📂 WZMVideoPlayerView: 一个功能齐全的视频播放器
 📂 WZMReaction: 仿rac, 响应式交互, 使用block方式回调
 
 ------------------------------------------------------
 ====================↓ 常用方法举例 ↓====================
 ------------------------------------------------------
 
 强弱引用:
 @wzm_weakify(self)
 @wzm_strongify(self)
 
 UIImage扩展:
 +[wzm_getImageByColor:]
 +[wzm_getImageByBase64:]
 +[wzm_getScreenImageByView:]
 -[wzm_savedToAlbum]
 -[wzm_getColorAtPixel:]
 
 UIColor扩展:
 +[wzm_getColorByHex:]
 +[wzm_getColorByImage:]
 
 
 
 UIView扩展:
 view.wzm_cornerRadius
 view.wzm_viewController
 view.wzm_width、.wzm_height、.wzm_minX、.wzm_minY
 -[wzm_colorWithPoint:]
 -[wzm_savePDFToDocumentsWithFileName:]
 
 NSObject扩展: [self className]、[NSObject className]
 
 NSString扩展:
 +[wzm_isBlankString:]
 -[wzm_getMD5]
 -[wzm_getUniEncode]
 -[wzm_getURLEncoded]、
 -[wzm_getPinyin]、
 -[wzm_base64EncodedString]
 
 宏定义:
 WZM_IS_iPad、WZM_IS_iPhone
 WZM_SCREEN_WIDTH、WZM_SCREEN_HEIGHT
 WZM_APP_NAME、WZM_APP_VERSION
 WZM_R_G_B(50,50,50)
 
 ...等等扩展类便捷方法、宏定义、自定义
 
 ------------------------------------------------------
 ======================== 结束 =========================
 ------------------------------------------------------
 */

#ifndef WZMKit_h
#define WZMKit_h

/*
 自定义日志输出
 在AppDelegate中允许打印日志
 wzm_openLogEnable(YES);
 */
#import "WZMLogPrinter.h"

/*
 常用枚举
 */
#import "WZMEnum.h"

/*
 常用block
 */
#import "WZMBlock.h"

/*
 常用宏定义
 */
#import "WZMMacro.h"

/*
 frame相关计算
 */
#import "WZMInline.h"

/*
 常用字符串
 */
#import "WZMTextInfo.h"

/********************************************************/
/********************** ↓ 常用类库 ↓ **********************/
/********************************************************/

/*
 网络请求
 */
#import "WZMNetWorking.h"
#import "WZMDownloader.h"

/*
 下拉刷新
 */
#import "WZMRefresh.h"

/*
 image缓存
 */
#import "WZMImageCache.h"

/*
 文件管理
 */
#import "WZMFileManager.h"

/*
 数据库管理
 */
#import "WZMSqliteManager.h"

/*
 简单缓存
 */
#import "WZMCatchStore.h"

/*
 常用的GCD快捷调用
 */
#import "WZMDispatch.h"

/*
 JSON解析, 内部实现了防崩溃处理
 */
#import "WZMJSONParse.h"

/*
 设备相关信息
 比如: 当前设备版本号、是否开启定位权限、是否联网、CPU使用量、IP地址、wifi名称等等
 */
#import "WZMDeviceUtil.h"

/*
 简单定位
 */
#import "WZMLocationManager.h"
#import "MKMapView+WZMLocation.h"

/*
 崩溃日志采集
 */
#import "WZMSignalException.h"
#import "WZMUncaughtException.h"

/*
 仿rac, 响应式交互, 使用block方式回调
 注意: block内须使用weakself防止循环引用
 UIView的单击、双击、长按事件
 UIButton的所有事件
 UITextField、UITextView的输入监听事件
 UIAlertView的点击事件
 所有类使用block传值
 如有疑问欢迎留言 或 查看demo
 */
#import "WZMReaction.h"

/********************************************************/
/********************** ↓ 常用视图 ↓ **********************/
/********************************************************/

/*
 简单的加载中转圈提示 或者 纯文本提示信息
 */
#import "WZMProgressHUD.h"

/*
 轮播图
 */
#import "WZMScrollImageView.h"

/*
 优化了缓存的gif展示
 */
#import "WZMGifImageView.h"

/*
 图片浏览器, 支持本地、网络、gif
 */
#import "WZMPhotoBrowser.h"

/*
 tableView表头, 设置图片后, 可根据tableView偏移量自动拉伸图片
 */
#import "WZMAutoHeader.h"

/*
 选项卡 - 不可滑动, 所有item平分视图宽度
 */
#import "WZMSelectedView.h"

/*
 选项卡 - 可滑动, 根据item个数自动设置contentSize
 */
#import "WZMSegmentedView.h"

/********************************************************/
/********************* ↓ 音视频播放 ↓ *********************/
/********************************************************/

/*
 高度自定义音/视频播放, 所有控件须自己实现
 支持状态回调: 加载成功、失败、开始播放、播放进度、播放结束等等
 */
#import "WZMPlayer.h"
#import "WZMPlayerView.h"

/*
 一个功能齐全的视频播放器
 实现了左边上下滑动调节亮度、右边上下滑动调节音量、横向滑动调节进度等等
 */
#import "WZMVideoPlayerView.h"
#import "WZMVideoPlayerViewController.h"

/*
 简单相机
 */
#import "WZMCamera.h"

/*
 简单音效
 包含震动等一些常用提示音
 */
#import "WZMAudioRecorder.h"

/********************************************************/
/********************** ↓ 其他类库 ↓ **********************/
/********************************************************/

/*
 包含一些简单的判断, 比如: url、email是否合法
 */
#import "WZMNSHandle.h"

/*
 快捷视图操作
 */
#import "WZMViewHandle.h"

/*
 手机版日志控制台, 测试神器
 */
#import "WZMLogView.h"

/*
 时间剪裁框
 */
#import "WZMClipTimeView.h"

/*
 查看所有的字体样式及其名称
 */
#import "WZMFontView.h"

/*
 手指移动绘图
 */
#import "WZMDrawView.h"
#import "WZMOpenDrawView.h"
#import "WZMImageDrawView.h"
#import "WZMMoreEditView.h"

/*
 马赛克
 */
#import "WZMMosaicView.h"

/*
 圆周运动
 */
#import "WZMCycleView.h"

/*
 自定义弹框, 使用block方式处理点击事件
 */
#import "WZMAlertView.h"

/*
 自定actionSheet
 */
#import "WZMActionSheet.h"

/*
 通用视图弹出动画
 */
#import "WZMPopupAnimator.h"

/*
 数字翻滚动画
 */
#import "WZMAnimationNumView.h"

/*
 一些常用的应用之间的跳转
 比如: 拨打电话、发送短信、跳转到QQ、微信、App Store等等
 */
#import "WZMAppJump.h"

/*
 发送邮件
 */
#import "WZMSendEmail.h"

/*
 显示App Store评分弹框
 */
#import "WZMAppScore.h"

/*
 base64
 */
#import "WZMBase64.h"

/*
字体管理
*/
#import "WZMFontManager.h"

/*
其他
*/
#import "WZMAlertQueue.h"

/*
视频剪裁
*/
#import "WZMVideoEditer.h"
#import "WZMAssetExportSession.h"

/*
 其他自定义控件
 */
#import "WZMButton.h"
#import "WZMMenuView.h"
#import "WZMCropView.h"
#import "WZMPasterView.h"
#import "WZMDottedView.h"
#import "WZMSliderView.h"
#import "WZMShadowLayer.h"
#import "WZMShadowLabel.h"
#import "WZMSliderView2.h"
#import "WZMVideoKeyView.h"
#import "WZMVideoKeyView2.h"
#import "WZMPanGestureRecognizer.h"
#import "WZMSingleRotationGestureRecognizer.h"
#import "WZMAlbumHelper.h"
#import "WZMAlbumController.h"
#import "WZMAlbumNavigationController.h"
#import "WZMScannerViewController.h"
#import "WZMPrivacyAlertController.h"
#import "WZMScreenViewController.h"
#import "WZMImageresizerView.h"
#import "WZMAlbumImageEditController.h"

/********************************************************/
/********************** ↓ 扩展类 ↓ **********************/
/********************************************************/

/*
 定义了一些常用的函数
 */
#import "CALayer+wzmcate.h"

#import "NSNull+wzmcate.h"
#import "NSObject+wzmcate.h"
#import "NSDateFormatter+wzmcate.h"
#import "NSString+wzmcate.h"
#import "NSAttributedString+wzmcate.h"
#import "NSDate+wzmcate.h"
#import "NSData+wzmcate.h"
#import "NSArray+wzmcate.h"
#import "NSDictionary+wzmcate.h"
#import "NSURLRequest+wzmcate.h"

#import "UIImage+wzmcate.h"
#import "UIView+wzmcate.h"
#import "UIColor+wzmcate.h"
#import "UITableView+wzmcate.h"
#import "UIImageView+wzmcate.h"
#import "UIFont+wzmcate.h"
#import "UILabel+wzmcate.h"
#import "UITextView+wzmcate.h"
#import "UITextField+wzmcate.h"
#import "UIViewController+wzmcate.h"
#import "UIButton+wzmcate.h"
#import "UIScrollView+wzmcate.h"
#import "UINavigationBar+wzmcate.h"
#import "UIWindow+wzmcate.h"
#import "UIWindow+WZMTransformAnimation.h"
#import "UIViewController+WZMModalAnimation.h"
#import "UINavigationController+WZMNavAnimation.h"

//时间差 CFAbsoluteTime
#define WZMStartTime CFAbsoluteTimeGetCurrent()
#define WZMEndTime   (CFAbsoluteTimeGetCurrent() - WZMStartTime)

//当前时间
#define WZM_TIME [[NSDateFormatter wzm_defaultDateFormatter] stringFromDate:[NSDate date]]

//日志打印
#ifdef DEBUG
#define __WZMFILE__ [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent]
#define __WZMTIME__ [[WZM_TIME componentsSeparatedByString:@" "] lastObject]
#define MyLog(format, ...) printf("[%s][%s]: %s\n\n", [__WZMFILE__ UTF8String], [__WZMTIME__ UTF8String], [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])

#define NSLog(format, ...) printf("%s\n\n",[[WZMLogView outputString:[NSString stringWithFormat:@"时间：%@\n文件：%@\n行数：第%d行\n方法：%@\n输出：%@",WZM_TIME,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithUTF8String:__FUNCTION__],[NSString stringWithFormat:format, ## __VA_ARGS__]]] UTF8String])
#else
#define MyLog(format, ...)
#define NSLog(format, ...)
#endif

#endif /* WZMKit_h */
