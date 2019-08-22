//
//  LLPercentDrivenInteractiveTransition.h
//  LLFoundation
//
//  Created by XHL on 17/4/4.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  手势管理者

#import <UIKit/UIKit.h>

@interface LLDismissInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;

- (void)wireToViewController:(UIViewController*)viewController;

@end
