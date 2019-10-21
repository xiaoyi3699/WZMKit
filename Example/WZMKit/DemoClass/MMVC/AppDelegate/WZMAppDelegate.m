//
//  WZMAppDelegate.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

/* 快速掌握WZMKit的基础使用类库和常用方法 */

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
 
 NSObject扩展:
 [self className]
 [NSObject className]
 
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

#import "WZMAppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import <UserNotifications/UserNotifications.h>
#import <AdSupport/AdSupport.h>

@interface WZMAppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation WZMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor clearColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [WZMTabBarController tabBarController];
    
    //禁止多点触控
    [[UIView appearance] setExclusiveTouch:YES];
    
    //检查更新
    NSString *url = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",WZM_APP_ID];
    [[WZMNetWorking netWorking] GET:url parameters:nil callBack:^(id responseObject, NSError *error) {
        if (error == nil) {
            NSDictionary *data = [[responseObject objectForKey:@"results"] firstObject];
            NSString *version = [data objectForKey:@"version"];
            [self updateWithVersion:version
                      updateContent:@"1、优化用户体验；\n\n2、修复已知bug。"
                      isForceUpdate:NO];
        }
    }];
    
    NSLog(@"%@==%@",[UIDevice currentDevice].identifierForVendor,[[ASIdentifierManager sharedManager] advertisingIdentifier]);
    
#if DEBUG
    //开启手机端日志悬浮图标
    [WZMLogView startLog];
    //开启framework内部日志打印
    [WZMLogPrinter openLogEnable:YES];
    //开启异常采集
    WZMInstallSignalHandler();
    WZMInstallUncaughtExceptionHandler();
    //监听CPU使用量和FPS(页面帧率)
    [self.window wzm_startObserveFpsAndCpu];
#endif
    
    NSLog(@"恭喜你，成功打印日志！");
    
    WZMLog(@"恭喜你，成功打印日志！");
    
    return YES;
}

#pragma mark - 屏幕旋转处理
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    UIViewController *rootVC = self.window.rootViewController;
    UIViewController *presentedVC = rootVC.presentedViewController;
    
    if (presentedVC.isBeingDismissed) {
        if ([rootVC respondsToSelector:@selector(ll_supportedInterfaceOrientations)]) {
            return [rootVC ll_supportedInterfaceOrientations];
        }
    }
    else {
        if ([presentedVC respondsToSelector:@selector(ll_supportedInterfaceOrientations)]) {
            return [presentedVC ll_supportedInterfaceOrientations];
        }
    }
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -  APP弹框机制
/**
 APP弹框
 机制:每七天弹出一次
 
 @param key         弹框标识
 @param title       弹框标题
 @param message     弹框内容
 @param OKTitle     确定按钮
 @param cancelTitle 取消按钮
 @param isForce  是否强制确定
 @param OKBlock  确定按钮事件
 */
- (void)compareWithKey:(NSString *)key title:(NSString *)title message:(NSString *)message OKTitle:(NSString *)OKTitle cancelTitle:(NSString *)cancelTitle isForce:(BOOL)isForce OKBlock:(doBlock)OKBlock {
    NSString *time = [WZMFileManager objForKey:key];
    if (time == nil || [NSDate wzm_isInTime:time days:7] == NO) {
        WZMAlertView *alertView = [[WZMAlertView alloc] initWithTitle:title message:message OKButtonTitle:OKTitle cancelButtonTitle:cancelTitle type:WZMAlertViewTypeUpdate];
        [alertView setOKBlock:OKBlock];
        [alertView setCannelBlock:^{
            if (isForce) {
                exit(0);
            }
            else {
                [WZMFileManager setObj:[NSString wzm_getTimeStringByDate:[NSDate date]] forKey:key];
            }
        }];
        [alertView showAnimated:YES];
    }
}

#pragma mark -  APP检查更新
- (void)updateWithVersion:(NSString *)version updateContent:(NSString *)updateContent isForceUpdate:(BOOL)isForceUpdate {
    static NSString *versionKey = @"ll_version";
    //沙盒存储的version
    NSString * docVersion = [WZMFileManager objForKey:versionKey];
    if ([self compareVersion:version otherVersion:docVersion]) {
        //APP的version
        if ([self compareVersion:version otherVersion:WZM_APP_VERSION]) {
            NSString *title = @"版本升级了";
            NSString *cancel;
            if (isForceUpdate) {
                cancel = @"退出";
            }
            else {
                cancel = @"取消";
            }
            [WZMFileManager setObj:version forKey:versionKey];
            WZMAlertView *alertView = [[WZMAlertView alloc] initWithTitle:title message:updateContent OKButtonTitle:@"立即更新" cancelButtonTitle:cancel type:WZMAlertViewTypeUpdate];
            [alertView setOKBlock:^{
                [WZMAppJump openAppStoreDownload:WZM_APP_ID type:WZMAppScoreTypeOpen];
                exit(0);
            }];
            [alertView setCannelBlock:^{
                if (isForceUpdate) {
                    exit(0);
                }
            }];
            [alertView showAnimated:YES];
        }
    }
}

- (BOOL)compareVersion:(NSString *)version otherVersion:(NSString *)otherVersion {
    return ([version compare:otherVersion options:NSNumericSearch] == NSOrderedDescending);
}

#pragma mark - APP跳转相关
//NS_DEPRECATED_IOS(2_0, 9_0)
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [self openUrl:url];
    return YES;
}

//NS_DEPRECATED_IOS(4_2, 9_0)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    [self openUrl:url];
    return YES;
}

//NS_AVAILABLE_IOS(9_0)
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [self openUrl:url];
    return YES;
}

//自定义跳转回调
- (void)openUrl:(NSURL *)url {
    
}

#pragma mark - 推送相关
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (![deviceToken isKindOfClass:[NSData class]]) return;
    NSMutableString *deviceTokenString = [NSMutableString string];
    const char *bytes = deviceToken.bytes;
    NSInteger count = deviceToken.length;
    for (int i = 0; i < count; i++) {
        [deviceTokenString appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    NSString *deToken = [deviceTokenString copy];
    NSLog(@"deviceToken=%@",deToken);
}

//NS_DEPRECATED_IOS(3_0, 10_0)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self didReceiveRemoteNotification:userInfo];
}

//NS_AVAILABLE_IOS(7_0)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [self didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

//__IOS_AVAILABLE(10.0)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    //应用处于前台时收到推送
    NSDictionary * userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//远程
        
        [self didReceiveRemoteNotification:userInfo];
    }
    else {//本地
        
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    //点击推送进入应用
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {//远程
        [self didReceiveRemoteNotification:userInfo];
    }
    else {//本地
    }
}

//自定义推送处理
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {}
- (void)applicationDidEnterBackground:(UIApplication *)application {}
- (void)applicationWillEnterForeground:(UIApplication *)application {}
- (void)applicationDidBecomeActive:(UIApplication *)application {}
- (void)applicationWillTerminate:(UIApplication *)application {}

@end
