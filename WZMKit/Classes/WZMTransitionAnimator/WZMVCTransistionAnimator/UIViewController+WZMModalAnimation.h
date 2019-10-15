//
//  UIViewController+WZMModalAnimation.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/9.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface UIViewController (WZMModalAnimation)

- (void)setWzm_showFromFrame:(CGRect)wzm_showFromFrame;
- (CGRect)wzm_showFromFrame;
- (void)setWzm_showToFrame:(CGRect)wzm_showToFrame;
- (CGRect)wzm_showToFrame;
- (void)setWzm_dismissFromFrame:(CGRect)wzm_dismissFromFrame;
- (CGRect)wzm_dismissFromFrame;
- (void)setWzm_dismissToFrame:(CGRect)wzm_dismissToFrame;
- (CGRect)wzm_dismissToFrame;

/**
 自定义的模态动画
 */
- (void)openModalAnimation:(WZMModalAnimationType)type;

@end
