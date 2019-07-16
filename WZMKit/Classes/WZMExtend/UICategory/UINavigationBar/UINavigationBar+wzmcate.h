//
//  UINavigationBar+wzmcate.h
//  WZMFeature
//
//  Created by WangZhaomeng on 2017/9/28.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (wzmcate)

- (void)wzm_setBackgroundColor:(UIColor *)backgroundColor;
- (void)wzm_setElementsAlpha:(CGFloat)alpha;
- (void)wzm_setTranslationY:(CGFloat)translationY;
- (void)wzm_reset;

@end
