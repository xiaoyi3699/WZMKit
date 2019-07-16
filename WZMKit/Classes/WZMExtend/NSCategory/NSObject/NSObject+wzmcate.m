//
//  NSObject+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSObject+wzmcate.h"
#import <objc/runtime.h>

@implementation NSObject (wzmcate)

static NSString *_tag = @"wzm_tag";

- (void)setWzm_tag:(int)wzm_tag {
    NSNumber *t = @(wzm_tag);
    objc_setAssociatedObject(self, &_tag, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)wzm_tag {
    NSNumber *t = objc_getAssociatedObject(self, &_tag);
    return (int)[t integerValue];
}

- (NSString *)wzm_className {
    return NSStringFromClass([self class]);
}

+ (NSString *)wzm_className {
    return NSStringFromClass([self class]);
}

@end
