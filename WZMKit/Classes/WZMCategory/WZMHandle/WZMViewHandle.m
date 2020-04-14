//
//  WZMViewHandle.m
//  test
//
//  Created by XHL on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMViewHandle.h"
#import "WZMProgressHUD.h"
#import "WZMDefined.h"

@implementation WZMViewHandle

+ (void)wzm_showAlertMessage:(NSString *)message {
#if WZM_APP
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
#endif
}

+ (void)wzm_showInfoMessage:(NSString *)message{
    [WZMProgressHUD showInfoMessage:message];
}

+ (void)wzm_showProgressMessage:(NSString *)message{
    [WZMProgressHUD showProgressMessage:message];
}

+ (void)wzm_dismiss{
    [WZMProgressHUD dismiss];
}

+ (void)wzm_setNetworkActivityIndicatorVisible:(BOOL)visible{
#if WZM_APP
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:visible];
#endif
}

+ (void)wzm_beginIgnoringInteractionEventsDuration:(NSTimeInterval)duration {
#if WZM_APP
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
#endif
}

+ (void)wzm_setStatusBarHidden:(BOOL)hidden {
#if WZM_APP
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationNone];
#endif
}

+ (void)wzm_setStatusBarStyle: (WZMStatusBarStyle)statusBarStyle{
#if WZM_APP
    switch (statusBarStyle) {
        case WZMStatusBarStyleDefault:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];//黑色
            break;
        case WZMStatusBarStyleLightContent:
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
            break;
        default:
            break;
    }
#endif
}

+ (UIImageView *)wzm_findShadowImageView:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self wzm_findShadowImageView:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end
