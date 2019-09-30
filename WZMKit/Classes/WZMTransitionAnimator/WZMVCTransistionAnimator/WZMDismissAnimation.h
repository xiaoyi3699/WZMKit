//
//  WZMDismissAnimation.h
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMDismissAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) WZMModalAnimationType type;

@end
