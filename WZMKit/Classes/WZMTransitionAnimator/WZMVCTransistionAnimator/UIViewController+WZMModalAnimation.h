//
//  UIViewController+WZMModalAnimation.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/9.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface UIViewController (WZMModalAnimation)

/**
 自定义的模态动画
 */
- (void)openModalAnimation:(WZMModalAnimationType)type;

@end
