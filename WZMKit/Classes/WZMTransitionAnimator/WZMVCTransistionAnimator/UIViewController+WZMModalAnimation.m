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
static NSString *_showFromFrame = @"showFromFrame";
static NSString *_showToFrame = @"showToFrame";
static NSString *_dismissFromFrame = @"dismissFromFrame";
static NSString *_dismissToFrame = @"dismissToFrame";
static NSString *_animatorKey = @"animator";
static NSString *_oldDelegate = @"oldDelegate";

- (void)setWzm_showFromFrame:(CGRect)wzm_showFromFrame {
    NSString *frame = NSStringFromCGRect(wzm_showFromFrame);
    objc_setAssociatedObject(self, &_showFromFrame, frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)wzm_showFromFrame {
    NSString *frame = objc_getAssociatedObject(self, &_showFromFrame);
    if (frame) {
        return CGRectFromString(frame);
    }
    return CGRectZero;
}

- (void)setWzm_showToFrame:(CGRect)wzm_showToFrame {
    NSString *frame = NSStringFromCGRect(wzm_showToFrame);
    objc_setAssociatedObject(self, &_showToFrame, frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)wzm_showToFrame {
    NSString *frame = objc_getAssociatedObject(self, &_showToFrame);
    if (frame) {
        return CGRectFromString(frame);
    }
    return CGRectZero;
}

- (void)setWzm_dismissFromFrame:(CGRect)wzm_dismissFromFrame {
    NSString *frame = NSStringFromCGRect(wzm_dismissFromFrame);
    objc_setAssociatedObject(self, &_dismissFromFrame, frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)wzm_dismissFromFrame {
    NSString *frame = objc_getAssociatedObject(self, &_dismissFromFrame);
    if (frame) {
        return CGRectFromString(frame);
    }
    return CGRectZero;
}

- (void)setWzm_dismissToFrame:(CGRect)wzm_dismissToFrame {
    NSString *frame = NSStringFromCGRect(wzm_dismissToFrame);
    objc_setAssociatedObject(self, &_dismissToFrame, frame, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)wzm_dismissToFrame {
    NSString *frame = objc_getAssociatedObject(self, &_dismissToFrame);
    if (frame) {
        return CGRectFromString(frame);
    }
    return CGRectZero;
}

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

- (void)setWzm_presentAnimationType:(WZMModalAnimationType)type {
    [self openModalAnimation:type];
    self.animator.presentAnimation.type = type;
}

- (WZMModalAnimationType)wzm_presentAnimationType {
    if (self.animator && self.animator.presentAnimation) {
        return self.animator.presentAnimation.type;
    }
    return WZMModalAnimationTypeNormal;
}

- (void)setWzm_dismissAnimationType:(WZMModalAnimationType)type {
    [self openModalAnimation:type];
    self.animator.dismissAnimation.type = type;
}

- (WZMModalAnimationType)wzm_dismissAnimationType {
    if (self.animator && self.animator.dismissAnimation) {
        return self.animator.dismissAnimation.type;
    }
    return WZMModalAnimationTypeNormal;
}

- (void)openModalAnimation:(WZMModalAnimationType)type {
    if (type == WZMModalAnimationTypeNormal) {
        self.animator = nil;
        if (self.oldDelegate) {
            self.transitioningDelegate = self.oldDelegate;
        }
    }
    else {
        if (self.animator == nil) {
            self.oldDelegate = self.transitioningDelegate;
            self.animator = [WZMViewControllerAnimator new];
            self.animator.presentAnimation = [[WZMPresentAnimation alloc] init];
            self.animator.dismissAnimation  = [[WZMDismissAnimation alloc] init];
            self.transitioningDelegate = self.animator;
        }
        
        if (type == WZMModalAnimationTypeZoom) {
            self.animator.presentAnimation.showFromFrame = self.wzm_showFromFrame;
            self.animator.presentAnimation.showToFrame = self.wzm_showToFrame;
            self.animator.dismissAnimation.dismissFromFrame = self.wzm_dismissFromFrame;
            self.animator.dismissAnimation.dismissToFrame = self.wzm_dismissToFrame;
        }
    }
}

@end
