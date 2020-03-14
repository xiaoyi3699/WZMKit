//
//  WZMRefreshHelper.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/25.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMRefreshHelper.h"

NSString *const WZMRefreshKeyPathContentOffset = @"contentOffset";
NSString *const WZMRefreshKeyPathContentSize   = @"contentSize";
NSString *const WZMRefreshKeyPathPanState      = @"state";
NSString *const WZMRefreshHeaderTime           = @"WZMRefreshHeaderTime";
NSString *const WZMRefreshMoreData             = @"WZMRefreshMoreData";

@implementation WZMRefreshHelper

+ (NSString *)getRefreshTime:(NSString *)key {
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

+ (void)setRefreshTime:(NSString *)key {
    NSDateFormatter *dateFormatter = [self dateFormatter];
    NSString *value = [dateFormatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UIImage *)arrowImage {
    return [WZMPublic imageWithFolder:@"refresh" imageName:@"arrow.png"];
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
