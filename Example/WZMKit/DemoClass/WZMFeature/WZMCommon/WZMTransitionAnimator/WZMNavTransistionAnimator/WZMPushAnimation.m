//
//  WZMPushAnimation.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPushAnimation.h"
#import "UIView+wzmcate.h"

@implementation WZMPushAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    [self a_animateTransition:transitionContext];
}

- (void)a_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    __block CGRect toFrame = toView.frame;
    toFrame.origin.x = toFrame.size.width;
    toView.frame = toFrame;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        
        toFrame.origin.x = 0;
        toView.frame = toFrame;
        
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

///波纹扩散
- (void)b_animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toView];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [containerView wzm_transitionFromLeftWithType:RippleEffect duration:duration completion:^{
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
