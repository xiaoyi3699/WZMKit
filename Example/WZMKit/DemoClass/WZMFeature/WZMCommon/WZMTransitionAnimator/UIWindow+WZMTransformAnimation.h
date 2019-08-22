//
//  UIWindow+WZMTransformAnimation.h
//  LLFirstAPP
//
//  Created by WangZhaomeng on 2018/3/21.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (WZMTransformAnimation)

- (UIImage *)screenImage;
- (void)setScreenImage:(UIImage *)screenImage;

- (void)ll_openTearAnimation:(BOOL)hasClose;

- (void)ll_closeTearAnimation:(void(^)(void))completion;

@end
