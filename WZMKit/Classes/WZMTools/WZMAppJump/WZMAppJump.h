//
//  WZMAppJump.h
//  WZMFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMAppJump : NSObject

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

///加入QQ群聊
+ (BOOL)QQJoinGroup:(NSString *)group key:(NSString *)key;

///打开应用
+ (BOOL)openAppWithAppType: (WZMAPPType)type;

///AppStore评论
+ (void)openAppStoreScore:(NSString *)appId type: (WZMAppScoreType)type;

///AppStore下载
+ (void)openAppStoreDownload:(NSString *)appId type: (WZMAppScoreType)type;

@end
