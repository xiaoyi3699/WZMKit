//
//  LLNavControllerDelegate.h
//  LLFoundation
//
//  Created by Mr.Wang on 17/1/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  动画管理者

#import <Foundation/Foundation.h>

@interface LLNavControllerAnimator : NSObject<UINavigationControllerDelegate>

@property (nonatomic, strong) NSString *pushAnimation;
@property (nonatomic, strong) NSString *popAnimation;

@end
