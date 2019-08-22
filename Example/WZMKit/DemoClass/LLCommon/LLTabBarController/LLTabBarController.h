//
//  LLTabBarController.h
//  LLTabBarViewController
//
//  Created by zhaomengWang on 2017/3/31.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLScreenShotView.h"

@interface LLTabBarController : UITabBarController

@property (nonatomic, strong) LLScreenShotView *screenShotView;

+ (instancetype)tabBarController;

- (void)setBadgeValue:(NSString *)badgeValue atIndex:(NSInteger)index;

@end
