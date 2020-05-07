//
//  UIWindow+WZMTransformAnimation.m
//  LLFirstAPP
//
//  Created by WangZhaomeng on 2018/3/21.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIWindow+WZMTransformAnimation.h"
#if WZM_APP
#import <objc/runtime.h>
#import "WZMMacro.h"
#import "UIImage+wzmcate.h"
#import "UIView+wzmcate.h"

@implementation UIWindow (WZMTransformAnimation)
static NSString *_screenImageKey = @"screenImage";
static NSString *_leftImageViewKey = @"leftImageView";
static NSString *_rightImageViewKey = @"rightImageView";

- (UIImage *)screenImage
{
    return objc_getAssociatedObject(self, &_screenImageKey);
}

- (void)setScreenImage:(UIImage *)screenImage
{
    objc_setAssociatedObject(self, &_screenImageKey, screenImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImageView *)leftImageView
{
    return objc_getAssociatedObject(self, &_leftImageViewKey);
}

- (void)setLeftImageView:(UIImageView *)leftImageView
{
    objc_setAssociatedObject(self, &_leftImageViewKey, leftImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wzm_setLeftImage:(UIImage *)leftImage
{
    if (self.leftImageView) {
        self.leftImageView.frame = CGRectMake(0, 0, WZM_SCREEN_WIDTH/2, WZM_SCREEN_HEIGHT);
    }
    else {
        self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WZM_SCREEN_WIDTH/2, WZM_SCREEN_HEIGHT)];
    }
    self.leftImageView.image = leftImage;
}

- (UIImageView *)rightImageView
{
    return objc_getAssociatedObject(self, &_rightImageViewKey);
}

- (void)setRightImageView:(UIImageView *)rightImageView
{
    objc_setAssociatedObject(self, &_rightImageViewKey, rightImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wzm_setRightImage:(UIImage *)rightImage
{
    if (self.rightImageView) {
        self.rightImageView.frame = CGRectMake(WZM_SCREEN_WIDTH/2, 0, WZM_SCREEN_WIDTH/2, WZM_SCREEN_HEIGHT);
    }
    else {
        self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(WZM_SCREEN_WIDTH/2, 0, WZM_SCREEN_WIDTH/2, WZM_SCREEN_HEIGHT)];
    }
    self.rightImageView.image = rightImage;
}

- (void)wzm_openTearAnimation:(BOOL)hasClose {
    self.screenImage = [UIImage wzm_getScreenImageByView:self];
    CGRect rect = WZM_SCREEN_BOUNDS;
    rect.size.width /= 2.0;
    [self wzm_setLeftImage:[self.screenImage wzm_clipImageWithRect:rect]];
    rect.origin.x += rect.size.width;
    [self wzm_setRightImage:[self.screenImage wzm_clipImageWithRect:rect]];
    if (self.leftImageView.superview == nil) {
        [self addSubview:self.leftImageView];
    }
    if (self.rightImageView.superview == nil) {
        [self addSubview:self.rightImageView];
    }
    [UIView animateWithDuration:.5 animations:^{
        self.leftImageView.wzm_minX = -WZM_SCREEN_WIDTH/2;
        self.rightImageView.wzm_minX = WZM_SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        if (hasClose == NO) {
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
        }
    }];
}

- (void)wzm_closeTearAnimation:(void(^)(void))completion {
    [UIView animateWithDuration:.5 animations:^{
        self.leftImageView.wzm_minX = 0;
        self.rightImageView.wzm_minX = WZM_SCREEN_WIDTH/2;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        [self.leftImageView removeFromSuperview];
        [self.rightImageView removeFromSuperview];
    }];
}

@end
#endif
