//
//  LLAppJump.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/18.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLAppJump.h"
#import "LLAlertView.h"
#import <StoreKit/StoreKit.h>

@interface LLAppJump ()<SKStoreProductViewControllerDelegate>

@end

@implementation LLAppJump

+ (LLAppJump *)shareInstance{
    static LLAppJump* instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LLAppJump alloc] init];
    });
    return instance;
}

//判断APP是否第一次启动
+ (BOOL)checkAppIsFirstLaunch:(NSString *)key {
    BOOL firstStart = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    if (!firstStart) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return !firstStart;
}

//拨打指定电话
+ (void)callTelePhone:(NSString *)phone {
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

//打开链接
+ (BOOL)openUrlStr:(NSString *)urlStr{
    NSURL *url = [NSURL URLWithString:urlStr];
    BOOL  canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpen) {
        [[UIApplication sharedApplication] openURL:url];
    }
    return canOpen;
}

//打开APP设置界面
+ (void)openAPPSetting{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

//打开QQ私聊界面
+ (BOOL)QQChatToUser:(NSString *)account{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web", account]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    return NO;
}

//打开应用
+ (BOOL)openAppWithAppType:(LLAPPType)type{
    NSString *APPSchemeName = [self getAPPSchemeName:type];
    if ([self checkIfAppInstalled:APPSchemeName]) {
        [self openAppWithAppScheme:APPSchemeName];
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)checkIfAppInstalled:(NSString *)appScheme{
    BOOL a = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", appScheme]]];
    return a;
}

+ (BOOL)openAppWithAppScheme:(NSString *)appScheme{
    BOOL a = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", appScheme]]];
    return a;
}

+ (NSString *)getAPPSchemeName:(LLAPPType)type{
    switch (type) {
        case 0:  return @"mqq://";
        case 1:  return @"weixin://";
        case 2:  return @"sinaweibo://";
        case 3:  return @"alipay://";
        case 4:  return @"taobao://";
        default: break;
    }
}

//AppStore评论
+ (void)openAppStoreScore:(NSString *)appId type:(LLAppStoreType)type{
    if (type == LLAppStoreTypeOpen) {
        [self ll_AppStoreScoreOpen:appId];
    }
    else {
        [self ll_AppStoreScoreInApp:appId];
    }
}

+ (void)ll_AppStoreScoreOpen:(NSString *)appId {
    NSString *store = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:store]];
}

+ (void)ll_AppStoreScoreInApp:(NSString *)appId {
    if (@available(iOS 10.3, *)) {
        if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
        }
    }
    else {
        [self ll_AppStoreScoreOpen:appId];
    }
}

//AppStore下载
+ (void)openAppStoreDownload:(NSString *)appId type:(LLAppStoreType)type{
    
    if (type == LLAppStoreTypeOpen) {
        [LLAppJump openAppStoreDownloadInAppStore:appId];
    }
    else {
        [[LLAppJump shareInstance] openAppStoreDownloadInInnerApp:appId];
    }
}

+ (void)openAppStoreDownloadInAppStore:(NSString *)appId{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appId]]];
}

- (void)openAppStoreDownloadInInnerApp:(NSString *)appId{
    SKStoreProductViewController *sc = [[SKStoreProductViewController alloc] init];
    sc.delegate = self;
    UIViewController* presentingCtrl = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (presentingCtrl.presentedViewController) {
        presentingCtrl = presentingCtrl.presentedViewController;
    }
    [sc loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId}
                  completionBlock:^(BOOL result, NSError *error) {
                      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                      if (error) {
                          //没有打开内部App Store弹窗
                          if (presentingCtrl.presentedViewController == sc) {
                              LLAlertView *alertView = [[LLAlertView alloc] initWithTitle:@"温馨提示" message:@"无法显示该应用,是否跳转到AppStore内查看" OKButtonTitle:@"确定" cancelButtonTitle:@"取消" type:LLAlertViewTypeNormal];
                              [alertView setOKBlock:^{
                                  [LLAppJump openAppStoreDownloadInAppStore:appId];
                              }];
                              [alertView showAnimated:YES];
                          }
                      }
                      else{
                          [presentingCtrl presentViewController:sc animated:YES completion:nil];
                      }
                  }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
