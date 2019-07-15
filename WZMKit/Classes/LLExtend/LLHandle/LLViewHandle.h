//
//  LLViewHandle.h
//  test
//
//  Created by XHL on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLEnum.h"

@interface LLViewHandle : UIView

+ (void)showInfoMessage:(NSString *)message;
+ (void)showProgressMessage:(NSString *)message;
+ (void)dismiss;

/**
 在状态栏显示网络加载的齿轮图标
 */
+ (void)setNetworkActivityIndicatorVisible:(BOOL)visible;

/**
 屏蔽触发事件
 */
+ (void)beginIgnoringInteractionEventsDuration:(NSTimeInterval)duration;

/**
 隐藏/显示状态栏
 */
+ (void)setStatusBarHidden:(BOOL)hidden;

/**
 设置状态栏颜色,需要在info.plist中，将View controller-based status bar appearance设为NO
 */
+ (void)setStatusBarStyle:(LLStatusBarStyle)statusBarStyle;

/**
 当前展示的视图控制器
 */
+ (UIViewController *)theTopViewControler;

///寻找导航栏黑线
+ (UIImageView *)findShadowImageView:(UIView *)view;

@end
