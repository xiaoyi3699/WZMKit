//
//  UIImage+WZMCustomImage.m
//  LLFirstAPP
//
//  Created by WangZhaomeng on 2018/3/25.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "UIImage+WZMCustomImage.h"

@implementation UIImage (LLNavBGImage)

+ (instancetype)defaultNavBGImage {
    static UIImage *bgImage;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bgImage = [UIImage wzm_getImageByColor:[UIColor whiteColor]];
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
