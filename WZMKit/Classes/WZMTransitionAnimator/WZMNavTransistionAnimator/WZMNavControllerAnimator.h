//
//  LLNavControllerDelegate.h
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  动画管理者

#import <Foundation/Foundation.h>
#import "WZMPushAnimation.h"
#import "WZMPopAnimation.h"
#import "WZMDefined.h"
#if WZM_APP
@interface WZMNavControllerAnimator : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) WZMPushAnimation *pushAnimation;
@property (nonatomic, strong) WZMPopAnimation *popAnimation;

@end
#endif
