//
//  LLPercentDrivenInteractiveTransition.h
//  LLFoundation
//
//  Created by XHL on 17/4/4.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  手势管理者

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMDismissInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interacting;
@property (nonatomic, assign) WZMPanGestureRecognizerDirection direction;

- (void)wireToViewController:(UIViewController*)viewController;

@end
