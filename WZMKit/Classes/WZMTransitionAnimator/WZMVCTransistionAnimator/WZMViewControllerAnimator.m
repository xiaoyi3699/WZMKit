//
//  LLViewControllerDelegate.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMViewControllerAnimator.h"
#if WZM_APP
#import "WZMDismissInteractiveTransition.h"

@interface WZMViewControllerAnimator ()

@property (nonatomic, strong) WZMDismissInteractiveTransition *transitionController;

@end

@implementation WZMViewControllerAnimator

- (instancetype)init {
    self = [super init];
    if (self) {
        self.direction = WZMPanGestureRecognizerDirectionHorizontal;
    }
    return self;
}

- (WZMDismissInteractiveTransition *)transitionController {
    if (!_transitionController) {
        _transitionController = [[WZMDismissInteractiveTransition alloc] init];
    }
    _transitionController.direction = self.direction;
    return _transitionController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                   presentingController:(UIViewController *)presenting
                                                                       sourceController:(UIViewController *)source{
    if (self.dismissAnimation && self.interactionEnabled) {
        [self.transitionController wireToViewController:presented];
    }
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return self.dismissAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.transitionController.interacting ? self.transitionController : nil;
}

@end
#endif
