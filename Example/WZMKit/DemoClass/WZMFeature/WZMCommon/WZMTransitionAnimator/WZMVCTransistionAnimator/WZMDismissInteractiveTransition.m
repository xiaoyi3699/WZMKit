//
//  LLPercentDrivenInteractiveTransition.m
//  LLFoundation
//
//  Created by XHL on 17/4/4.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMDismissInteractiveTransition.h"

@interface WZMDismissInteractiveTransition ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL shouldComplete;
@property (nonatomic,   weak) UIViewController *presentingVC;

@end

@implementation WZMDismissInteractiveTransition

-(void)wireToViewController:(UIViewController *)viewController{
    self.presentingVC = viewController;
    [self prepareGestureRecognizerInView:viewController.view];
}

- (void)prepareGestureRecognizerInView:(UIView*)view {
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    gesture.delegate = self;
    [view addGestureRecognizer:gesture];
}

-(CGFloat)completionSpeed{
    return 1;
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view.superview];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.interacting = YES;
        [self.presentingVC dismissViewControllerAnimated:YES completion:nil];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat fraction = translation.x / WZM_SCREEN_WIDTH;
        self.shouldComplete = (fraction > 0.3);
        [self updateInteractiveTransition:fraction];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        self.interacting = NO;
        [self cancelInteractiveTransition];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.interacting = NO;
        if (self.shouldComplete) {
            [self finishInteractiveTransition];
            
        } else {
            [self cancelInteractiveTransition];
        }
    }
}

#pragma mark - UIGestureRecognizerDelegate
//是否响应触摸事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint point = [touch locationInView:gestureRecognizer.view];
        if (point.x <= 100) {//设置手势触发区
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
    CGFloat tx = [pan translationInView:gestureRecognizer.view].x;
    if (tx < 0) {
        return NO;
    }
    return YES;
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    //UIScrollView的滑动冲突
    if ([otherGestureRecognizer.view isMemberOfClass:[UIScrollView class]]) {
        UIScrollView *scrollow = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollow.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

@end
