//
//  LLWindPresentAnimation.h
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMPresentAnimation : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) CGRect showFromFrame;
@property (nonatomic, assign) CGRect showToFrame;
@property (nonatomic, assign) WZMModalAnimationType type;
@property (nonatomic, assign) BOOL interactionEnabled;

@end
