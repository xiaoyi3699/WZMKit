//
//  WZMPopAnimation.h
//  LLFoundation
//
//  Created by zhaomengWang on 17/1/13.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMDefined.h"
#if WZM_APP
#import "WZMEnum.h"

@interface WZMPopAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) WZMNavAnimationType type;

@end
#endif
