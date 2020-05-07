//
//  UIWindow+WZMTransformAnimation.h
//  LLFirstAPP
//
//  Created by WangZhaomeng on 2018/3/21.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMDefined.h"
#if WZM_APP
@interface UIWindow (WZMTransformAnimation)

- (UIImage *)screenImage;
- (void)setScreenImage:(UIImage *)screenImage;

- (void)wzm_openTearAnimation:(BOOL)hasClose;

- (void)wzm_closeTearAnimation:(void(^)(void))completion;

@end
#endif
