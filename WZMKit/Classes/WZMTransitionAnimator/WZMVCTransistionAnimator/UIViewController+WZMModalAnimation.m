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
static NSString *_oldDelegate = @"oldDelegate";

- (WZMViewControllerAnimator *)animator
{
    return objc_getAssociatedObject(self, &_animatorKey);
}

- (void)setAnimator:(WZMViewControllerAnimator *)animator
{
    objc_setAssociatedObject(self, &_animatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIViewControllerTransitioningDelegate>)oldDelegate
{
    return objc_getAssociatedObject(self, &_oldDelegate);
}

- (void)setOldDelegate:(id<UIViewControllerTransitioningDelegate>)oldDelegate
{
    objc_setAssociatedObject(self, &_oldDelegate, oldDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)openModalAnimation:(WZMModalAnimationType)type {
    if (type == WZMModalAnimationTypeNormal) {
        self.animator = nil;
        self.transitioningDelegate = self.oldDelegate;
    }
    else {
        if (self.animator == nil) {
            self.oldDelegate = self.transitioningDelegate;
            self.animator = [WZMViewControllerAnimator new];
            self.animator.presentAnimation = [[WZMPresentAnimation alloc] init];
            self.animator.dismissAnimation  = [[WZMDismissAnimation alloc] init];
            self.transitioningDelegate = self.animator;
        }
        
    }
}

@end
