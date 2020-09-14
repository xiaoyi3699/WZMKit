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

#if DEBUG
+ (void)wzm_loadDealloc {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = NSSelectorFromString(@"dealloc");
        SEL swizzSel = NSSelectorFromString(@"wzm_dealloc");
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}

- (void)wzm_dealloc {
    if ([self isKindOfClass:[UIViewController class]]) {
        NSLog(@"%@释放了",NSStringFromClass(self.class));
    }
    [self wzm_dealloc];
}
#endif

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
