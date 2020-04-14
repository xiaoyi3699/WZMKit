//
//  WZMPopAnimation.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPopAnimation.h"
#if WZM_APP
#import "UIView+wzmcate.h"

@implementation WZMPopAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    if (self.type == WZMNavAnimationTypeScroll) {
        [self a_animateTransition:transitionContext];
    }
}

- (void)a_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView atIndex:0];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        
        CGRect rect = fromView.frame;
        rect.origin.x = rect.size.width;
        fromView.frame = rect;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

///波纹扩散
- (void)b_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView atIndex:0];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [containerView wzm_transitionFromRightWithType:RippleEffect duration:duration completion:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
#endif
