//
//  UIFont+wzmcate.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/9/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "UIFont+wzmcate.h"
#import "WZMLogPrinter.h"
#import "WZMBase64.h"
#import <CoreText/CoreText.h>

@interface WZMFontManager : NSObject
@property (nonatomic, strong) NSMutableDictionary *fontNames;
@end

@implementation WZMFontManager

+ (instancetype)shareManager {
    static WZMFontManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[WZMFontManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.fontNames = [[NSMutableDictionary alloc] init];
    }
    return self;
}

///获取字体名称
+ (NSString *)fontNameWithPath:(NSString *)path {
    NSString *key = [path.lastPathComponent wzm_base64EncodedString];
    return [[WZMFontManager shareManager].fontNames objectForKey:key];
}

+ (void)setFontName:(NSString *)fontName forPath:(NSString *)path {
    NSString *key = [path.lastPathComponent wzm_base64EncodedString];
    [[WZMFontManager shareManager].fontNames setObject:fontName forKey:key];
}

@end

@implementation UIFont (wzmcate)

///字体是否存在
+ (BOOL)wzm_fontExistWithFontName:(NSString *)fontName {
    UIFont *aFont = [UIFont fontWithName:fontName size:10];
    BOOL exist = (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame
                                 || [aFont.familyName compare:fontName] == NSOrderedSame));
    return exist;
}

///获取字体名称
+ (NSString *)wzm_fontNameWithPath:(NSString *)path {
    NSString *fontName = [WZMFontManager fontNameWithPath:path];
    if (fontName.length) return fontName;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) return nil;
    NSData *fontData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:path]];
    CFErrorRef error;
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
    if (fontName == nil) {
        fontName = [UIFont systemFontOfSize:15.0].fontName;
    }
    [WZMFontManager setFontName:fontName forPath:path];
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
