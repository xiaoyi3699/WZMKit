//
//  UIColor+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIColor+wzmcate.h"

@implementation UIColor (wzmcate)

+ (UIColor *)wzm_getColorByImage:(UIImage *)image {
    return [UIColor colorWithPatternImage:image];
}

- (NSString *)wzm_getHexString {
    CGFloat r, g, b, a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    int rgb = (int) (r * 255.0f)<<16 | (int) (g * 255.0f)<<8 | (int) (b * 255.0f)<<0;
    return [NSString stringWithFormat:@"%06x", rgb];
}

+ (UIColor *)wzm_getColorByHex:(NSInteger)hexValue {
    return [self wzm_getColorByHex:hexValue alpha:1.0];
}

+ (UIColor *)wzm_getColorByHex:(NSInteger)hexValue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alpha];
}

+ (UIColor *)wzm_getColorByHexString:(NSString *)hexString {
    return [self wzm_getColorByHexString:hexString alpha:1.0];
}

+ (UIColor *)wzm_getColorByHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

+ (UIColor *)wzm_getDynamicColor:(UIColor *)lightColor {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        CGFloat r=0,g=0,b=0,a=0;
        if ([lightColor respondsToSelector:@selector(getRed:green:blue:alpha:)]) {
            [lightColor getRed:&r green:&g blue:&b alpha:&a];
        }
        else {
            const CGFloat *components = CGColorGetComponents(lightColor.CGColor);
            r = components[0];
            g = components[1];
            b = components[2];
            a = components[3];
        }
        UIColor *darkColor = [UIColor colorWithRed:(1.0-r)
                                             green:(1.0-g)
                                              blue:(1.0-b)
                                             alpha:a];
        return [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            }
            return lightColor;
        }];
    }
    else {
        return lightColor;
    }
    #else
    return lightColor;
    #endif
}

+ (UIColor *)wzm_getDynamicColorByLightColor:(UIColor *)lightColor darkColor:(UIColor *)darkColor {
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        return [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection *traitCollection) {
            if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                return darkColor;
            }
            return lightColor;
        }];
    }
    else {
        return lightColor;
    }
    #else
    return lightColor;
    #endif
}

- (BOOL)wzm_isisEqualToColor:(UIColor *)color {
    if (color == nil) {
        return NO;
    }
    return CGColorEqualToColor(self.CGColor, color.CGColor);
}

@end
