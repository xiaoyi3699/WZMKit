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
#import "LLEnum.h"
#import "LLBlock.h"
#import "LLMacro.h"
#import "LLInline.h"
#import "LLTextInfo.h"

//第三方
#import "LLBase64.h"

//扩展类
#import "NSNull+LLAddPart.h"
#import "NSObject+LLAddPart.h"
#import "NSDateFormatter+LLAddPart.h"
#import "NSString+LLAddPart.h"
#import "NSAttributedString+AddPart.h"
#import "NSDate+LLAddPart.h"
#import "NSData+LLAddData.h"
#import "NSArray+LLAddPart.h"
#import "NSDictionary+LLAddPart.h"

//UIAddPart
#import "UIImage+LLAddPart.h"
#import "UIView+LLAddPart.h"
#import "UIColor+LLAddPart.h"
#import "UITableView+LLAddPart.h"
#import "UIImageView+LLAddPart.h"
#import "UIFont+LLAddPart.h"
#import "UILabel+LLAddPart.h"
#import "UITextView+LLAddPart.h"
#import "UITextField+LLAddPart.h"
#import "UIViewController+LLAddPart.h"
#import "UIButton+LLAddPart.h"
#import "UIWebView+LLAddPart.h"
#import "UIScrollView+LLAddPart.h"
#import "UINavigationBar+LLAddPart.h"
#import "UIWindow+LLAddPart.h"
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
#import "LLSegmentedView.h"
#import "LLScrollImageView.h"
#import "LLAnimationNumView.h"

//工具类
#import "LLCamera.h"
#import "LLAppJump.h"
#import "LLRefresh.h"
#import "LLReaction.h"
#import "LLDispatch.h"
#import "LLKeychain.h"
#import "LLFontView.h"
#import "LLLogView.h"
#import "LLLogModel.h"
#import "LLDrawView.h"
#import "LLSendEmail.h"
#import "LLAVManager.h"
#import "LLDeviceUtil.h"
#import "LLCatchStore.h"
#import "LLImageCache.h"
#import "LLNetWorking.h"
#import "LLAudioPlayer.h"
#import "LLFileManager.h"
#import "LLProgressHUD.h"
#import "LLSelectedView.h"
#import "LLSqliteManager.h"
#import "LLJSONParseUtil.h"
#import "LLAppStoreScore.h"
#import "LLLocationManager.h"
#import "LLNetworkDownload.h"
#import "LLSignalException.h"
#import "LLLogTableViewCell.h"
#import "LLUncaughtException.h"
#import "LLVideoPlayerViewController.h"

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
