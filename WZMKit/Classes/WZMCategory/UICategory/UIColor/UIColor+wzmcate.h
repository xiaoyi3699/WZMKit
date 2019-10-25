//
//  UIColor+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (wzmcate)

+ (UIColor *)wzm_getColorByImage:(UIImage *)image;
+ (UIColor *)wzm_getColorByHex:(NSInteger)hexValue;
+ (UIColor *)wzm_getColorByHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)wzm_getColorByHexString:(NSString *)hexString;
+ (UIColor *)wzm_getColorByHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)wzm_getDynamicColor:(UIColor *)lightColor;
+ (UIColor *)wzm_getDynamicColorByLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor;

@end
