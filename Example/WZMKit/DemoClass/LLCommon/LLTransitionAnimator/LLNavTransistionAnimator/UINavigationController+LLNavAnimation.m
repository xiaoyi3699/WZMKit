//
//  UINavigationController+LLNavAnimation.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UINavigationController+LLNavAnimation.h"
#import "LLNavControllerAnimator.h"
#import <objc/runtime.h>

@implementation UINavigationController (LLNavAnimation)
static NSString *_animatorKey = @"animator";

- (LLNavControllerAnimator *)animator {
    return objc_getAssociatedObject(self, &_animatorKey);
}

- (void)setAnimator:(LLNavControllerAnimator *)animator {
    objc_setAssociatedObject(self, &_animatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)openPushAnimation:(BOOL)enable {
    if (enable) {
        if (self.animator == nil) {
            self.animator = [LLNavControllerAnimator new];
            self.animator.pushAnimation = @"LLPushAnimation";
            self.animator.popAnimation  = @"LLPopAnimation";
            self.delegate = self.animator;
        }
    }
    else {
        self.animator = nil;
        self.delegate = nil;
    }
}

@end
