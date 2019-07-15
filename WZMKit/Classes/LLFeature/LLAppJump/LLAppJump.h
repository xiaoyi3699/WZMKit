//
//  LLAppJump.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEnum.h"

@interface LLAppJump : NSObject

+ (LLAppJump *)shareInstance;

///判断APP是否第一次启动
+ (BOOL)checkAppIsFirstLaunch:(NSString *)key;

///拨打指定电话号码
+ (void)callTelePhone:(NSString *)phone;

///打开链接
+ (BOOL)openUrlStr:(NSString *)urlStr;

///打开APP设置界面
+ (void)openAPPSetting;

///打开QQ私聊界面
+ (BOOL)QQChatToUser:(NSString *)account;

///打开应用
+ (BOOL)openAppWithAppType:(LLAPPType)type;

///AppStore评论
+ (void)openAppStoreScore:(NSString *)appId type:(LLAppStoreType)type;

///AppStore下载
+ (void)openAppStoreDownload:(NSString *)appId type:(LLAppStoreType)type;

@end
