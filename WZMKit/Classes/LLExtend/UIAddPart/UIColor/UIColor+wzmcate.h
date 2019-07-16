//
//  UIColor+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (wzmcate)

+ (UIColor *)wzm_colorWithImage:(UIImage *)image;
+ (UIColor *)wzm_colorWithHex:(NSInteger)hexValue;
+ (UIColor *)wzm_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alpha;
+ (UIColor *)wzm_colorWithHexString:(NSString *)hexString;
+ (UIColor *)wzm_colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

@end
