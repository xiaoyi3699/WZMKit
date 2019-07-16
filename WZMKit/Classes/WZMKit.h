//
//  WZMKit.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef WZMKit_h
#define WZMKit_h

//全局类
#import "WZMLog.h"
#import "WZMEnum.h"
#import "WZMBlock.h"
#import "WZMMacro.h"
#import "WZMInline.h"
#import "WZMTextInfo.h"

//第三方
#import "WZMBase64.h"

//扩展类
#import "NSNull+wzmcate.h"
#import "NSObject+wzmcate.h"
#import "NSDateFormatter+wzmcate.h"
#import "NSString+wzmcate.h"
#import "NSAttributedString+wzmcate.h"
#import "NSDate+wzmcate.h"
#import "NSData+wzmcate.h"
#import "NSArray+wzmcate.h"
#import "NSDictionary+wzmcate.h"

//UIwzmcate
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

#import "WZMNSHandle.h"
#import "WZMViewHandle.h"

//视图类
#import "WZMAlertView.h"
#import "WZMCycleView.h"
#import "WZMAutoHeader.h"
#import "WZMActionSheet.h"
#import "WZMGifImageView.h"
#import "WZMPhotoBrowser.h"
#import "WZMPopupAnimator.h"
#import "WZMSegmentedView.h"
#import "WZMScrollImageView.h"
#import "WZMAnimationNumView.h"

//工具类
#import "WZMCamera.h"
#import "WZMAppJump.h"
#import "WZMRefresh.h"
#import "WZMReaction.h"
#import "WZMDispatch.h"
#import "WZMFontView.h"
#import "WZMLogView.h"
#import "WZMDrawView.h"
#import "WZMSendEmail.h"
#import "WZMAVManager.h"
#import "WZMDeviceUtil.h"
#import "WZMCatchStore.h"
#import "WZMImageCache.h"
#import "WZMNetWorking.h"
#import "WZMAudioPlayer.h"
#import "WZMFileManager.h"
#import "WZMProgressHUD.h"
#import "WZMSelectedView.h"
#import "WZMSqliteManager.h"
#import "WZMJSONParse.h"
#import "WZMAppStore.h"
#import "WZMLocationManager.h"
#import "WZMSignalException.h"
#import "WZMUncaughtException.h"
#import "WZMVideoPlayerViewController.h"

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
