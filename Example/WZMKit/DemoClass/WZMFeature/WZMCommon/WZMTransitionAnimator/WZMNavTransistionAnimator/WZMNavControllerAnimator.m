//
//  LLNavControllerDelegate.m
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMNavControllerAnimator.h"

@interface WZMNavControllerAnimator ()

@end

@implementation WZMNavControllerAnimator

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        if (self.pushAnimation) {
            return [NSClassFromString(self.pushAnimation) new];
        }
    }
    else if (operation == UINavigationControllerOperationPop) {
        if (self.popAnimation) {
            return [NSClassFromString(self.popAnimation) new];
        }
    }
    return nil;
}

@end
