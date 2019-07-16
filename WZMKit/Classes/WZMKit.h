//
//  WZMKit.h
//  Pods
//
//  Created by WangZhaomeng on 2019/7/15.
//

#ifndef WZMKit_h
#define WZMKit_h

//全局类
#import "LLLog.h"
#import "WZMEnum.h"
#import "WZMBlock.h"
#import "WZMMacro.h"
#import "LLInline.h"
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
#import "LLSingleRotationGestureRecognizer.h"

#import "LLNSHandle.h"
#import "LLViewHandle.h"

//视图类
#import "LLAlertView.h"
#import "LLCycleView.h"
#import "LLAutoHeader.h"
#import "LLActionSheet.h"
#import "LLGifImageView.h"
#import "LLPhotoBrowser.h"
#import "LLPopupAnimator.h"
#import "WZMSegmentedView.h"
#import "WZMScrollImageView.h"
#import "LLAnimationNumView.h"

//工具类
#import "LLCamera.h"
#import "LLAppJump.h"
#import "WZMRefresh.h"
#import "LLReaction.h"
#import "LLDispatch.h"
#import "LLKeychain.h"
#import "LLFontView.h"
#import "LLLogView.h"
#import "LLLogModel.h"
#import "LLDrawView.h"
#import "WZMSendEmail.h"
#import "LLAVManager.h"
#import "LLDeviceUtil.h"
#import "LLCatchStore.h"
#import "LLImageCache.h"
#import "LLNetWorking.h"
#import "LLAudioPlayer.h"
#import "LLFileManager.h"
#import "LLProgressHUD.h"
#import "WZMSelectedView.h"
#import "WZMSqliteManager.h"
#import "LLJSONParseUtil.h"
#import "LLAppStoreScore.h"
#import "LLLocationManager.h"
#import "LLNetworkDownload.h"
#import "WZMSignalException.h"
#import "LLLogTableViewCell.h"
#import "WZMUncaughtException.h"
#import "WZMVideoPlayerViewController.h"

//时间差 CFAbsoluteTime
#define LLStartTime CFAbsoluteTimeGetCurrent()
#define LLEndTime   (CFAbsoluteTimeGetCurrent() - LLStartTime)

//当前时间
#define LL_TIME [[NSDateFormatter ll_defaultDateFormatter] stringFromDate:[NSDate date]]

//日志打印
#ifdef DEBUG
#define __LLFILE__ [[NSString stringWithFormat:@"%s",__FILE__] lastPathComponent]
#define __LLTIME__ [[LL_TIME componentsSeparatedByString:@" "] lastObject]
#define MyLog(format, ...) printf("[%s][%s]: %s\n\n", [__LLFILE__ UTF8String], [__LLTIME__ UTF8String], [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])

#define NSLog(format, ...) printf("%s\n\n",[[LLLogView outputString:[NSString stringWithFormat:@"时间：%@\n文件：%@\n行数：第%d行\n方法：%@\n输出：%@",LL_TIME,[[NSString stringWithUTF8String:__FILE__] lastPathComponent],__LINE__,[NSString stringWithUTF8String:__FUNCTION__],[NSString stringWithFormat:format, ## __VA_ARGS__]]] UTF8String])
#else
#define MyLog(format, ...)
#define NSLog(format, ...)
#endif

#endif /* WZMKit_h */
