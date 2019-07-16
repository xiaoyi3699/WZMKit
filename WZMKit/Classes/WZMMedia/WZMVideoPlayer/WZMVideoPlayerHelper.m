//
//  WZMVideoPlayerHelper.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/23.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMVideoPlayerHelper.h"
#import "WZMLog.h"

@implementation WZMVideoPlayerHelper

+ (UIImage *)wzm_imageNamed:(NSString *)name ofType:(NSString *)type {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,@"WZMKit.bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    if (bundle == nil) {
        bundlePath = [NSString stringWithFormat:@"%@/%@",mainBundlePath,@"Frameworks/WZMKit.framework/WZMKit.bundle"];
        bundle = [NSBundle bundleWithPath:bundlePath];
    }
    wzm_log(@"调用了一哈");
    return [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:type]];
}

@end
