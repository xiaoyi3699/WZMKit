//
//  WZMVideoPlayerHelper.m
//  WZMFeature
//
//  Created by WangZhaomeng on 2017/11/23.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMVideoPlayerHelper.h"

@implementation WZMVideoPlayerHelper

+ (UIImage *)wzm_imageNamed:(NSString *)imageName ofType:(NSString *)type {
    NSString *imagePath = [[self wzm_bundleWithName:@"WZMVideoPlayer"] pathForResource:imageName ofType:type];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image == nil) {
        imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:type];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    return image;
}

+ (NSBundle *)wzm_bundleWithName:(NSString *)bundleName {
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:bundleName ofType:@"bundle"]];
}

@end
