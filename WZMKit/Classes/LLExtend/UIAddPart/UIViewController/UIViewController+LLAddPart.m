//
//  UIViewController+LLAddPart.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/22.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIViewController+LLAddPart.h"

@implementation UIViewController (LLAddPart)

- (void)ll_goBack{
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (UIViewController *)ll_visibleViewController {
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [[((UINavigationController*) self) visibleViewController] ll_visibleViewController];
    }
    else if ([self isKindOfClass:[UITabBarController class]]){
        return [[((UITabBarController*) self) selectedViewController] ll_visibleViewController];
    }
    else {
        if (self.presentedViewController) {
            return [self.presentedViewController ll_visibleViewController];
        } else {
            return self;
        }
    }
}

- (BOOL)ll_isVisible {
    if (self.isViewLoaded && (self.view.window || self.view.superview)) {
        return YES;
    }
    return NO;
}

- (void)ll_interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

@end
