//
//  UIViewController+WZMModalAnimation.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/9.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMDefined.h"
#if WZM_APP
#import "WZMEnum.h"

@interface UIViewController (WZMModalAnimation)

//当WZMModalAnimationType为zoom时,设置present/dismiss的初始/结束位置
- (void)setWzm_showFromFrame:(CGRect)wzm_showFromFrame;
- (CGRect)wzm_showFromFrame;
- (void)setWzm_showToFrame:(CGRect)wzm_showToFrame;
- (CGRect)wzm_showToFrame;
- (void)setWzm_dismissFromFrame:(CGRect)wzm_dismissFromFrame;
- (CGRect)wzm_dismissFromFrame;
- (void)setWzm_dismissToFrame:(CGRect)wzm_dismissToFrame;
- (CGRect)wzm_dismissToFrame;

//设置动画类型
- (void)setWzm_presentAnimationType:(WZMModalAnimationType)type;
- (WZMModalAnimationType)wzm_presentAnimationType;
- (void)setWzm_dismissAnimationType:(WZMModalAnimationType)type;
- (WZMModalAnimationType)wzm_dismissAnimationType;

@end
#endif
