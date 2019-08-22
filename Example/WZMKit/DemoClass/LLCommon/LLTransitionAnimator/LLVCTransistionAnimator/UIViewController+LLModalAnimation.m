//
//  UIViewController+LLModalAnimation.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/9.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIViewController+LLModalAnimation.h"
#import "LLViewControllerAnimator.h"
#import <objc/runtime.h>

@implementation UIViewController (LLModalAnimation)
static NSString *_animatorKey = @"animator";

- (LLViewControllerAnimator *)animator
{
    return objc_getAssociatedObject(self, &_animatorKey);
}

- (void)setAnimator:(LLViewControllerAnimator *)animator
{
    objc_setAssociatedObject(self, &_animatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)openModalAnimation:(BOOL)enable {
    if (enable) {
        if (self.animator == nil) {
            self.animator = [LLViewControllerAnimator new];
            self.animator.presentAnimation = @"LLPresentAnimation";
            self.animator.dismissAnimation  = @"LLDismissAnimation";
            self.transitioningDelegate = self.animator;
        }
    }
    else {
        self.animator = nil;
        self.transitioningDelegate = nil;
    }
}

@end
