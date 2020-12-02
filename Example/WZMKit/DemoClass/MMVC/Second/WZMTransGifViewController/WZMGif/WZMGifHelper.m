//
//  WZMGifHelper.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/11/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMGifHelper.h"

@implementation WZMGifHelper

+ (UIImage *)getImage:(id)image {
    if ([image isKindOfClass:[NSURL class]]) {
        image = [(NSURL *)image path];
    }
    if ([image isKindOfClass:[NSString class]]) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:image]) {
            image = [[UIImage alloc] initWithContentsOfFile:image];
        }
        else {
            image = [UIImage imageNamed:image];
        }
    }
    if ([image isKindOfClass:[UIImage class]] == NO) {
        image = nil;
    }
    return image;
}

@end
