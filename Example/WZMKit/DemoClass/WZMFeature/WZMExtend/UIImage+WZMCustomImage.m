//
//  UIImage+WZMCustomImage.m
//  LLFirstAPP
//
//  Created by WangZhaomeng on 2018/3/25.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIImage+WZMCustomImage.h"
#import "UIImage+wzmcate.h"
#import "UIColor+wzmcate.h"

@implementation UIImage (LLNavBGImage)

+ (instancetype)defaultNavBGImage {
    static UIImage *bgImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgImage = [UIImage wzm_getImageByColor:[UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] darkColor:[UIColor colorWithRed:8.0/255.0 green:8.0/255.0 blue:8.0/255.0 alpha:1.0]]];
    });
    return bgImage;
}

+ (instancetype)clearNavBGImage {
    static UIImage *bgImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgImage = [UIImage new];
    });
    return bgImage;
}

+ (instancetype)gradientNavBGImage {
    static UIImage *bgImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgImage = [UIImage wzm_getGradientImageByColors:@[[UIColor wzm_getColorByHex:0xbc93f1],[UIColor wzm_getColorByHex:0x4842d7]]
                                         gradientType:WZMGradientTypeLeftToRight
                                              imgSize:CGSizeMake(1, 1)];
    });
    return bgImage;
}

@end
