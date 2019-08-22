//
//  WZMCrashManager.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/3/1.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMCrashManager.h"

@implementation WZMCrashManager

+ (void)ocCrash {
    NSString *text = nil;
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:text];
}

+ (void)signalCrash {
    char *s = "hello world";
    *s = 'H';
}

@end
