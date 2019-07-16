//
//  LLVideoPlayerHelper.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/23.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLVideoPlayerHelper.h"

@implementation LLVideoPlayerHelper

+ (UIImage *)ll_imageNamed:(NSString *)imageName ofType:(NSString *)type {
    NSString *imagePath = [[self ll_bundleWithName:@"LLVideoPlayer"] pathForResource:imageName ofType:type];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image == nil) {
        imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return image;
}

+ (NSBundle *)ll_bundleWithName:(NSString *)bundleName {
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"]];
}

@end
