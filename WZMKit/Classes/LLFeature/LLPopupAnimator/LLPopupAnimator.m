//
//  LLPopupAnimator.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/3/3.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLPopupAnimator.h"
#import "LLMacro.h"
#import "UIView+LLAddPart.h"

@implementation LLPopupAnimator{
    __weak UIView    *_alertView;
    LLAnimationStyle _animationStyle;
}

+ (instancetype)animator {
    static dispatch_once_t onceToken;
    static LLPopupAnimator *animator;
    dispatch_once(&onceToken, ^{
        animator = [[LLPopupAnimator alloc] init];
    });
    return animator;
}

- (instancetype)init {
    self = [super initWithFrame:LL_SCREEN_BOUNDS];
    if (self) {
        self.backgroundColor = CUSTOM_ALERT_BG_COLOR;
    }
    return self;
}

- (void)popUpView:(UIView *)view animationStyle:(LLAnimationStyle)animationStyle duration:(NSTimeInterval)duration completion:(doBlock)completion{
    
    if (_alertView.superview) {
        [_alertView removeFromSuperview];
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    _alertView      = view;
    _animationStyle = animationStyle;
    
    if (animationStyle == LLAnimationStyleOutFromCenterAnimation) {
        _alertView.center = self.center;
    }
    else if (animationStyle == LLAnimationStyleFromDownAnimation) {
        _alertView.minY = self.maxY;
    }
    self.alpha = 0;
    [self addSubview:view];
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
        if (animationStyle == LLAnimationStyleOutFromCenterNone) {
            [_alertView outFromCenterNoneWithDuration:duration];
        }
        else if (animationStyle == LLAnimationStyleOutFromCenterAnimation) {
            [_alertView outFromCenterAnimationWithDuration:duration];
        }
        else if (animationStyle == LLAnimationStyleFromDownAnimation) {
            _alertView.minY = self.LLHeight-_alertView.LLHeight;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismiss:(BOOL)animated completion:(doBlock)completion{
    if (animated) {
        doBlock animation;
        if (_animationStyle == LLAnimationStyleOutFromCenterNone) {
            animation = ^(){
                [_alertView dismissToCenterNoneWithDuration:.2];
                self.alpha = 0;
            };
        }
        else if (_animationStyle == LLAnimationStyleOutFromCenterAnimation) {
            animation = ^(){
                [_alertView dismissToCenterAnimationWithDuration:.2];
                self.alpha = 0;
            };
        }
        else {
            animation = ^(){
                _alertView.minY = self.maxY;
                self.alpha = 0;
            };
        }
        [UIView animateWithDuration:.2
                         animations:animation
                         completion:^(BOOL finished) {
                             [self removeCurrentViewCompletion:completion];
                         }];
    }
    else {
        [self removeCurrentViewCompletion:completion];
    }
}

- (void)removeCurrentViewCompletion:(doBlock)completion {
    if ([self.delegate respondsToSelector:@selector(dismissAnimationCompletion)]) {
        [self.delegate dismissAnimationCompletion];
    }
    else if (completion) {
        completion();
    }
    [_alertView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_animationStyle == LLAnimationStyleFromDownAnimation) {
        NSSet *allTouches = [event allTouches];
        UITouch *touch = [allTouches anyObject];
        if (touch.view == self) {
            [self dismiss:YES completion:nil];
        }
    }
}

@end
