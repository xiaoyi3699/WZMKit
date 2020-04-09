//
//  WZMFontManager.m
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/2/26.
//  Copyright © 2020 Vincent. All rights reserved.
//

#import "WZMFontManager.h"
#import "UIFont+wzmcate.h"
#import "WZMBase64.h"

@interface WZMFontManager ()

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
    NSString *key = [path wzm_base64EncodedString];
    NSString *fontName = [[WZMFontManager shareManager].fontNames objectForKey:key];
    if (fontName == nil) {
        fontName = [UIFont wzm_fontNameWithPath:path];
        if (fontName) {
            [[WZMFontManager shareManager].fontNames setObject:fontName forKey:key];
        }
    }
    return fontName;
}

///从路径加载字体
+ (UIFont *)fontWithPath:(NSString *)path size:(CGFloat)size {
    NSString *fontName = [self fontNameWithPath:path];
    if (fontName) {
        return [UIFont fontWithName:fontName size:size];
    }
    else {
        return [UIFont systemFontOfSize:size];
    }
}

@end
