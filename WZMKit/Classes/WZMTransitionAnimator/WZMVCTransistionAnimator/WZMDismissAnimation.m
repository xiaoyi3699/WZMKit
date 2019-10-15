//
//  WZMDismissAnimation.m
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMDismissAnimation.h"
#import "WZMMacro.h"

@interface WZMDismissAnimation ()

@end

@implementation WZMDismissAnimation

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
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    if (toView.superview == nil) {
        [containerView insertSubview:toView atIndex:0];
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(WZM_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromView.transform = CGAffineTransformIdentity;
    }];
}

- (void)zoom_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    if (toView.superview == nil) {
        [containerView insertSubview:toView atIndex:0];
    }
    
    CGFloat scale = self.dismissToFrame.size.height/self.dismissFromFrame.size.height;
    CGPoint center = CGPointMake(CGRectGetMidX(self.dismissToFrame), CGRectGetMidY(self.dismissToFrame));
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.alpha = 0.0;
        fromView.center = center;
        fromView.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
