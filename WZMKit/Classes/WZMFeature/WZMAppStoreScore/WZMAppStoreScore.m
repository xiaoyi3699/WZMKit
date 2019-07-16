//
//  WZMAppStoreScore.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/5/22.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMAppStoreScore.h"
#import "WZMFileManager.h"
#import "WZMAppJump.h"
#import "WZMDispatch.h"
#import "LLViewHandle.h"

//评分
#define LL_STORE_KEY @"llStoreKey"
#define LL_BAD_KEY   @"llBadKey"
@interface WZMAppStoreScore ()<UIAlertViewDelegate>

@end

@implementation WZMAppStoreScore {
    LLAppStoreType _type;
    NSString *_appId;
}

+ (instancetype)shareScore {
    static WZMAppStoreScore *score;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        score = [[WZMAppStoreScore alloc] initWithAppId:@""];
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

- (void)showScoreView:(LLAppStoreType)type isOnce:(BOOL)isOnce {
    _type = type;
    BOOL isStore = [[WZMFileManager objForKey:LL_STORE_KEY] boolValue];
    if (isOnce && isStore) return;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您的每一次反馈都非常重要" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"五星好评",@"我要吐槽", nil];
    [alertView show];
    [WZMFileManager setObj:@(YES) forKey:LL_STORE_KEY];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [WZMAppJump openAppStoreScore:_appId type:_type];
    }
    else if (buttonIndex == 2) {
        NSString *msg;
        BOOL isBad = [[WZMFileManager objForKey:LL_BAD_KEY] boolValue];
        if (isBad) {
            msg = @"您已经吐槽过了^_^";
        }
        else {
            msg = @"感谢您的反馈，我们会继续努力^_^";
            [WZMFileManager setObj:@(YES) forKey:LL_BAD_KEY];
        }
        WZMDispatch_after(1, ^{
            [LLViewHandle wzm_showInfoMessage:msg];
        });
    }
}

@end
