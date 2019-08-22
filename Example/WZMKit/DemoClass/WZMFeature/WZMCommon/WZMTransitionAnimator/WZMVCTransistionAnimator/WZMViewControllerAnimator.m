//
//  LLViewControllerDelegate.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMViewControllerAnimator.h"
#import "WZMPresentAnimation.h"
#import "WZMDismissAnimation.h"
#import "WZMDismissInteractiveTransition.h"

@interface WZMViewControllerAnimator ()

@property (nonatomic, strong) WZMDismissInteractiveTransition *transitionController;

@end

@implementation WZMViewControllerAnimator

- (WZMDismissInteractiveTransition *)transitionController {
    if (!_transitionController) {
        _transitionController = [WZMDismissInteractiveTransition new];
    }
    return _transitionController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    if (self.presentAnimation) {
        [self.transitionController wireToViewController:presented];
        return [NSClassFromString(self.presentAnimation) new];
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.dismissAnimation) {
        return [NSClassFromString(self.dismissAnimation) new];
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}

@end
