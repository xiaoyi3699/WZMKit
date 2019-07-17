//
//  WZMKit.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef WZMKit_h
#define WZMKit_h

//自定义日志输出
//在AppDelegate中允许打印日志
//wzm_openLogEnable(YES);
#import "WZMLog.h"
//常用枚举
#import "WZMEnum.h"
//常用block
#import "WZMBlock.h"
//常用宏定义
#import "WZMMacro.h"
//frame相关计算
#import "WZMInline.h"
//常用字符串
#import "WZMTextInfo.h"

/********************** ↓ 常用类库 ↓ **********************/

//网络请求
#import "WZMNetWorking.h"

//下拉刷新
#import "WZMRefresh.h"

//image缓存
#import "WZMImageCache.h"

//文件管理
#import "WZMFileManager.h"

//数据库管理
#import "WZMSqliteManager.h"

//简单缓存
#import "WZMCatchStore.h"

//常用的GCD快捷调用
#import "WZMDispatch.h"

//JSON解析, 内部实现了防崩溃处理
#import "WZMJSONParse.h"

//设备相关信息
//比如: 当前设备版本号、是否开启定位权限、是否联网、CPU使用量、IP地址、wifi名称等等
#import "WZMDeviceUtil.h"

//简单定位
#import "WZMLocationManager.h"

//崩溃日志采集
#import "WZMSignalException.h"
#import "WZMUncaughtException.h"

/********************** ↓ 常用视图 ↓ **********************/

//简单的加载中转圈提示 或者 纯文本提示信息
#import "WZMProgressHUD.h"

//轮播图
#import "WZMScrollImageView.h"

//优化了缓存的gif展示
#import "WZMGifImageView.h"

//图片浏览器, 支持本地、网络、gif
#import "WZMPhotoBrowser.h"

//tableView表头, 设置图片后, 可根据tableView偏移量自动拉伸图片
#import "WZMAutoHeader.h"

//选项卡 - 不可滑动, 所有item平分视图宽度
#import "WZMSelectedView.h"

//选项卡 - 可滑动, 根据item个数自动设置contentSize
#import "WZMSegmentedView.h"

/********************** ↓ 音视频播放 ↓ **********************/

//高度自定义音/视频播放, 所有控件须自己实现
//支持状态回调: 加载成功、失败、开始播放、播放进度、播放结束等等
#import "WZMPlayer.h"
#import "WZMPlayerView.h"

//一个功能齐全的视频播放器
//实现了左边上下滑动调节亮度、右边上下滑动调节音量、横向滑动调节进度等等
#import "WZMAVPlayerView.h"
#import "WZMVideoPlayerViewController.h"

//简单相机
#import "WZMCamera.h"

//简单音效
//包含震动等一些常用提示音
#import "WZMAVManager.h"

/********************** ↓ 其他类库 ↓ **********************/

//包含一些简单的判断, 比如: url、email是否合法
#import "WZMNSHandle.h"

//快捷视图操作
#import "WZMViewHandle.h"

//手机版日志控制台, 测试神器
#import "WZMLogView.h"

//查看所有的字体样式及其名称
#import "WZMFontView.h"

//手指移动绘图
#import "WZMDrawView.h"

//圆周运动
#import "WZMCycleView.h"

//自定义弹框, 使用block方式处理点击事件
#import "WZMAlertView.h"

//自定actionSheet
#import "WZMActionSheet.h"

//通用视图弹出动画
#import "WZMPopupAnimator.h"

//数字翻滚动画
#import "WZMAnimationNumView.h"

//仿rac, 响应式交互, 使用block方式回调
//注意: block内须使用weakself防止循环引用
//UIView的单击、双击、长按事件
//UIButton的所有事件
//UITextField、UITextView的输入监听事件
//UIAlertView的点击事件
//所有类使用block传值
//如有疑问欢迎留言 或 查看demo
#import "WZMReaction.h"

//一些常用的应用之间的跳转
//比如: 拨打电话、发送短信、跳转到QQ、微信、App Store等等
#import "WZMAppJump.h"

//发送邮件
#import "WZMSendEmail.h"

//显示App Store评分弹框
#import "WZMAppStore.h"

//base64
#import "WZMBase64.h"

/********************** ↓ 扩展类 ↓ **********************/

//定义了一些常用的函数
#import "NSNull+wzmcate.h"
#import "NSObject+wzmcate.h"
#import "NSDateFormatter+wzmcate.h"
#import "NSString+wzmcate.h"
#import "NSAttributedString+wzmcate.h"
#import "NSDate+wzmcate.h"
#import "NSData+wzmcate.h"
#import "NSArray+wzmcate.h"
#import "NSDictionary+wzmcate.h"

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
#import "UIWebView+wzmcate.h"
#import "UIScrollView+wzmcate.h"
#import "UINavigationBar+wzmcate.h"
#import "UIWindow+wzmcate.h"
#import "WZMSingleRotationGestureRecognizer.h"

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
