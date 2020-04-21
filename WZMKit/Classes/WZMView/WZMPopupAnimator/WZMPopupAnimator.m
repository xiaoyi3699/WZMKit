//
//  WZMPopupAnimator.m
//  WZMFoundation
//
//  Created by zhaomengWang on 17/3/3.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPopupAnimator.h"
#import "WZMMacro.h"
#import "UIView+wzmcate.h"
#import "WZMDefined.h"

@implementation WZMPopupAnimator{
    __weak UIView    *_alertView;
    WZMAnimationStyle _animationStyle;
}

+ (instancetype)shareAnimator {
    static dispatch_once_t onceToken;
    static WZMPopupAnimator *animator;
    dispatch_once(&onceToken, ^{
        animator = [[WZMPopupAnimator alloc] init];
    });
    return animator;
}

- (instancetype)init {
    self = [super initWithFrame:WZM_SCREEN_BOUNDS];
    if (self) {
        self.backgroundColor = WZM_ALERT_BG_COLOR;
    }
    return self;
}

- (void)popUpView:(UIView *)view animationStyle: (WZMAnimationStyle)animationStyle duration:(NSTimeInterval)duration completion:(wzm_doBlock)completion{
    
    if (_alertView.superview) {
        [_alertView removeFromSuperview];
    }
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    _alertView      = view;
    _animationStyle = animationStyle;
    
    if (animationStyle == WZMAnimationStyleOutFromCenterAnimation) {
        _alertView.center = self.center;
    }
    else if (animationStyle == WZMAnimationStyleFromDownAnimation) {
        _alertView.wzm_minY = self.wzm_maxY;
    }
    self.alpha = 0;
    [self addSubview:view];
#if WZM_APP
    [[UIApplication sharedApplication].delegate.window addSubview:self];
#endif
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1;
        if (animationStyle == WZMAnimationStyleOutFromCenterNone) {
            [_alertView wzm_outFromCenterNoneWithDuration:duration];
        }
        else if (animationStyle == WZMAnimationStyleOutFromCenterAnimation) {
            [_alertView wzm_outFromCenterAnimationWithDuration:duration];
        }
        else if (animationStyle == WZMAnimationStyleFromDownAnimation) {
            _alertView.wzm_minY = self.wzm_height-_alertView.wzm_height;
        }
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)dismiss:(BOOL)animated completion:(wzm_doBlock)completion{
    if (animated) {
        wzm_doBlock animation;
        if (_animationStyle == WZMAnimationStyleOutFromCenterNone) {
            animation = ^(){
                [_alertView wzm_dismissToCenterNoneWithDuration:.2];
                self.alpha = 0;
            };
        }
        else if (_animationStyle == WZMAnimationStyleOutFromCenterAnimation) {
            animation = ^(){
                [_alertView wzm_dismissToCenterAnimationWithDuration:.2];
                self.alpha = 0;
            };
        }
        else {
            animation = ^(){
                _alertView.wzm_minY = self.wzm_maxY;
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

- (void)removeCurrentViewCompletion:(wzm_doBlock)completion {
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
    if (_animationStyle == WZMAnimationStyleFromDownAnimation) {
        NSSet *allTouches = [event allTouches];
        UITouch *touch = [allTouches anyObject];
        if (touch.view == self) {
            [self dismiss:YES completion:nil];
        }
    }
}

@end
