//
//  WZMAppStore.m
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2018/5/22.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMAppStore.h"
#import "WZMFileManager.h"
#import "WZMAppJump.h"
#import "WZMDispatch.h"
#import "WZMViewHandle.h"
#import "WZMDefined.h"
//评分
#define WZM_STORE_KEY @"wzmStoreKey"
#define WZM_BAD_KEY   @"wzmBadKey"
#if WZM_APP
@interface WZMAppStore ()<UIAlertViewDelegate>
#else
@interface WZMAppStore ()
#endif
@end

@implementation WZMAppStore {
    WZMAppStoreType _type;
    NSString *_appId;
}

+ (instancetype)shareStore {
    static WZMAppStore *score;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        score = [[WZMAppStore alloc] initWithAppId:@""];
    });
    return score;
}

- (instancetype)initWithAppId:(NSString *)appId {
    self = [super init];
    if (self) {
        _appId = appId;
    }
    return self;
}

- (void)showScoreView:(WZMAppStoreType)type isOnce:(BOOL)isOnce {
#if WZM_APP
    _type = type;
    BOOL isStore = [[WZMFileManager objForKey:WZM_STORE_KEY] boolValue];
    if (isOnce && isStore) return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的每一次反馈都非常重要" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"五星好评",@"我要吐槽", nil];
    [alertView show];
    [WZMFileManager setObj:@(YES) forKey:WZM_STORE_KEY];
#endif
}

#if WZM_APP
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [WZMAppJump openAppStoreScore:_appId type:_type];
    }
    else if (buttonIndex == 2) {
        NSString *msg;
        BOOL isBad = [[WZMFileManager objForKey:WZM_BAD_KEY] boolValue];
        if (isBad) {
            msg = @"您已经吐槽过了^_^";
        }
        else {
            msg = @"感谢您的反馈，我们会继续努力^_^";
            [WZMFileManager setObj:@(YES) forKey:WZM_BAD_KEY];
        }
        WZMDispatch_after(1, ^{
            [WZMViewHandle wzm_showInfoMessage:msg];
        });
    }
}
#endif

@end
