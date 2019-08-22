//
//  UIViewController+WZMModalAnimation.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/9.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIViewController+WZMModalAnimation.h"
#import "WZMViewControllerAnimator.h"
#import <objc/runtime.h>

@implementation UIViewController (WZMModalAnimation)
static NSString *_animatorKey = @"animator";

- (WZMViewControllerAnimator *)animator
{
    return objc_getAssociatedObject(self, &_animatorKey);
}

- (void)setAnimator:(WZMViewControllerAnimator *)animator
{
    objc_setAssociatedObject(self, &_animatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)openModalAnimation:(BOOL)enable {
    if (enable) {
        if (self.animator == nil) {
            self.animator = [WZMViewControllerAnimator new];
            self.animator.presentAnimation = @"WZMPresentAnimation";
            self.animator.dismissAnimation  = @"WZMDismissAnimation";
            self.transitioningDelegate = self.animator;
        }
    }
    else {
        self.animator = nil;
        self.transitioningDelegate = nil;
    }
}

@end
