//
//  UIFont+wzmcate.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/9/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIFont+wzmcate.h"
#import "WZMLogPrinter.h"
#import <CoreText/CoreText.h>

@implementation UIFont (wzmcate)

///字体是否存在
+ (BOOL)wzm_fontExistWithFontName:(NSString *)fontName {
    UIFont* aFont = [UIFont fontWithName:fontName size:10];
    BOOL exist = (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame
                                 || [aFont.familyName compare:fontName] == NSOrderedSame));
    return exist;
}

///获取字体名称
+ (NSString *)wzm_fontNameWithPath:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) return nil;
    NSData *fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    CFErrorRef error; NSString *fontName;
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(providerRef);
    if (CTFontManagerRegisterGraphicsFont(fontRef, &error)) {
        //注册成功
        fontName = (__bridge NSString *)CGFontCopyFullName(fontRef);
    }
    else {
        //注册失败
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        WZMLog(@"Failed to load font: %@", errorDesc);
        CFRelease(errorDesc);
    }
    if (fontRef) {
        CFRelease(fontRef);
    }
    if (providerRef) {
        CFRelease(providerRef);
    }
    return fontName;
}

///从路径加载字体
+ (UIFont *)wzm_fontWithPath:(NSString *)path size:(CGFloat)size {
    NSString *fontName = [self wzm_fontNameWithPath:path];
    if (fontName) {
        return [UIFont fontWithName:fontName size:size];
    }
    else {
        return [UIFont systemFontOfSize:size];
    }
}

@end
