//
//  LLWindPresentAnimation.m
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPresentAnimation.h"
#import "WZMMacro.h"

@interface WZMPresentAnimation ()<UIViewControllerAnimatedTransitioning>

@end

@implementation WZMPresentAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.type == WZMModalAnimationTypeScroll) {
        [self a_animateTransition:transitionContext];
    }
    else if (self.type == WZMModalAnimationTypeZoom) {
        [self zoom_animateTransition:transitionContext];
    }
}

- (void)a_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    toView.transform = CGAffineTransformMakeTranslation(WZM_SCREEN_WIDTH, 0);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)zoom_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    CGFloat scale = self.showFromFrame.size.height/toView.bounds.size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(self.showFromFrame), CGRectGetMidY(self.showFromFrame));
    toView.alpha = 0.0;
    toView.center = center;
    toView.transform = CGAffineTransformMakeScale(scale, scale);
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        toView.alpha = 1.0;
        toView.center = CGPointMake(CGRectGetMidX(self.showToFrame), CGRectGetMidY(self.showToFrame));
        toView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
