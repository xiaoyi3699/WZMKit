//
//  LLViewControllerDelegate.h
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  动画管理者

#import <UIKit/UIKit.h>

@interface WZMViewControllerAnimator : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSString *presentAnimation;
@property (nonatomic, strong) NSString *dismissAnimation;

@end
