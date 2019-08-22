//
//  UINavigationController+WZMNavAnimation.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UINavigationController+WZMNavAnimation.h"
#import "WZMNavControllerAnimator.h"
#import <objc/runtime.h>

@implementation UINavigationController (WZMNavAnimation)
static NSString *_animatorKey = @"animator";

- (WZMNavControllerAnimator *)animator {
    return objc_getAssociatedObject(self, &_animatorKey);
}

- (void)setAnimator:(WZMNavControllerAnimator *)animator {
    objc_setAssociatedObject(self, &_animatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)openPushAnimation:(BOOL)enable {
    if (enable) {
        if (self.animator == nil) {
            self.animator = [WZMNavControllerAnimator new];
            self.animator.pushAnimation = @"WZMPushAnimation";
            self.animator.popAnimation  = @"WZMPopAnimation";
            self.delegate = self.animator;
        }
    }
    else {
        self.animator = nil;
        self.delegate = nil;
    }
}

@end
