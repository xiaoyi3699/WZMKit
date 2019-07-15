//
//  LLRefreshHelper.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLRefreshHelper.h"

NSString *const LLRefreshKeyPathContentOffset = @"contentOffset";
NSString *const LLRefreshKeyPathContentSize   = @"contentSize";
NSString *const LLRefreshKeyPathPanState      = @"state";
NSString *const LLRefreshHeaderTime           = @"LLRefreshHeaderTime";
NSString *const LLRefreshMoreData             = @"LLRefreshMoreData";

@implementation LLRefreshHelper

+ (NSString *)LL_getRefreshTime:(NSString *)key {
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (value) {
        NSArray *times = [value componentsSeparatedByString:@" "];
        NSString *day = times.firstObject;
        
        NSDateFormatter *dateFormatter = [self dateFormatter];
        NSString *nowValue = [dateFormatter stringFromDate:[NSDate date]];
        NSString *nowDay = [nowValue componentsSeparatedByString:@" "].firstObject;
        
        if ([day isEqualToString:nowDay]) {
            return [NSString stringWithFormat:@"最后更新：今天 %@",times.lastObject];
        }
        return [NSString stringWithFormat:@"最后更新：%@",value];
    }
    return [NSString stringWithFormat:@"最后更新：无记录"];
}

+ (void)LL_setRefreshTime:(NSString *)key {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSString *value = [dateFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//framework的bundle文件
+ (NSBundle *)LL_RefreshBundle_0 {
    return [NSBundle bundleWithPath:[[NSBundle bundleForClass:[LLRefreshHelper class]] pathForResource:@"LLRefresh" ofType:@"bundle"]];
}

//静态库的bundle文件
+ (NSBundle *)LL_RefreshBundle_1 {
    return [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LLRefresh" ofType:@"bundle"]];
}

+ (UIImage *)LL_ArrowImage {
    UIImage *image = [UIImage imageWithContentsOfFile:[[self LL_RefreshBundle_0] pathForResource:@"ll_arrow" ofType:@"png"]];
    if (image == nil) {
        image = [UIImage imageWithContentsOfFile:[[self LL_RefreshBundle_1] pathForResource:@"ll_arrow" ofType:@"png"]];
    }
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

#pragma mark - private method
+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    });
    return dateFormatter;
}

@end
