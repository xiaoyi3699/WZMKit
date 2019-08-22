//
//  WZMDismissAnimation.m
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMDismissAnimation.h"

@interface WZMDismissAnimation ()

@end

@implementation WZMDismissAnimation

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.35f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
    UIView *toView   = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
    
    UIView *containerView = [transitionContext containerView];
    [containerView insertSubview:toView atIndex:0];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        fromView.transform = CGAffineTransformMakeTranslation(WZM_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        fromView.transform = CGAffineTransformIdentity;
    }];
}

@end
