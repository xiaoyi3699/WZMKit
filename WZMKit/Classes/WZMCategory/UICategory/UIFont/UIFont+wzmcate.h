//
//  UIFont+wzmcate.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/9/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (wzmcate)

///获取字体名称
+ (NSString *)wzm_fontNameWithPath:(NSString *)path;
///字体是否存在
+ (BOOL)wzm_fontExistWithFontName:(NSString *)fontName;
///从路径加载字体
+ (UIFont *)wzm_fontWithPath:(NSString *)path size:(CGFloat)size;

@end
