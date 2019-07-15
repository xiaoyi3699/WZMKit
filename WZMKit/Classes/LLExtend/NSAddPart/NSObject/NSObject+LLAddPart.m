//
//  NSObject+LLAddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSObject+LLAddPart.h"
#import <objc/runtime.h>

@implementation NSObject (LLAddPart)

#pragma mark - 为系统类追加属性
static NSString *_intFlagKey = @"intFlag";
static NSString *_strFlagKey = @"strFlag";

- (void)setStrFlag:(NSString *)flag {
    objc_setAssociatedObject(self, &_strFlagKey, flag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)strFlag {
    return objc_getAssociatedObject(self, &_strFlagKey);
}

- (void)setIntFlag:(int)intFlag {
    NSNumber *t = @(intFlag);
    objc_setAssociatedObject(self, &_intFlagKey, t, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (int)intFlag {
    NSNumber *t = objc_getAssociatedObject(self, &_intFlagKey);
    return (int)[t integerValue];
}

- (NSString *)className {
    return NSStringFromClass([self class]);
}

+ (NSString *)className {
    return NSStringFromClass([self class]);
}

@end
