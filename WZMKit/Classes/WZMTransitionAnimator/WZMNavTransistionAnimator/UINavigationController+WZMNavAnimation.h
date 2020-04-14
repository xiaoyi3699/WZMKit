//
//  UINavigationController+WZMNavAnimation.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMDefined.h"
#if WZM_APP
#import "WZMEnum.h"

@interface UINavigationController (WZMNavAnimation)

/**
 自定义的push和pop动画
 */
- (void)openPushAnimation:(WZMNavAnimationType)type;

@end
#endif
