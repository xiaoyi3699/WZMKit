//
//  LLViewControllerDelegate.h
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  动画管理者

#import <UIKit/UIKit.h>
#import "WZMDefined.h"
#if WZM_APP
#import "WZMPresentAnimation.h"
#import "WZMDismissAnimation.h"

@interface WZMViewControllerAnimator : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL interactionEnabled;
@property (nonatomic, assign) WZMPanGestureRecognizerDirection direction;
@property (nonatomic, strong) WZMPresentAnimation *presentAnimation;
@property (nonatomic, strong) WZMDismissAnimation *dismissAnimation;

@end
#endif
