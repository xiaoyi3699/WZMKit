//
//  WZMVideoPlayerHelper.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/23.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMVideoPlayerHelper.h"
#import "WZMPublic.h"

@implementation WZMVideoPlayerHelper

+ (UIImage *)wzm_imageNamed:(NSString *)name ofType:(NSString *)type {
    NSBundle *bundle = [WZMPublic wzm_resourceBundle];
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:type]];
}

@end
