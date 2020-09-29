//
//  NSObject+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSObject+wzmcate.h"
#import <objc/runtime.h>
#import "WZMLogPrinter.h"

@implementation NSObject (wzmcate)
static NSString *_tag = @"wzm_tag";

#if DEBUG
+ (void)wzm_loadDealloc {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL systemSel = NSSelectorFromString(@"dealloc");
        SEL swizzSel = NSSelectorFromString(@"wzm_dealloc");
        [self wzm_swizzleMethod:self systemSel:systemSel swizzSel:swizzSel];
    });
}

- (void)wzm_dealloc {
    if ([self isKindOfClass:[UIViewController class]]) {
        WZMLog(@"%@释放了",NSStringFromClass(self.class));
    }
    [self wzm_dealloc];
}
#endif

//方法交换
+ (BOOL)wzm_swizzleMethod:(Class)class systemSel:(SEL)origSel swizzSel:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(class, origSel);
    Method altMethod = class_getInstanceMethod(class, altSel);
    if (origMethod == nil) {
        class = object_getClass(class);
        origMethod = class_getInstanceMethod(class, origSel);
        altMethod = class_getInstanceMethod(class, altSel);
    }
    if (!origMethod || !altMethod) {
        return NO;
    }
    BOOL didAddMethod = class_addMethod(class,origSel,
                                        method_getImplementation(altMethod),
                                        method_getTypeEncoding(altMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,altSel,
                            method_getImplementation(origMethod),
                            method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, altMethod);
    }
    return YES;
}

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
