//
//  MyLog.m
//  WZMFeature
//
//  Created by WangZhaomeng on 2017/9/27.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMLog.h"

#define WZM_LOG(format, ...) printf("[LLFeatureLog]: %s\n\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
@interface WZMLog ()

@property (nonatomic, assign) BOOL enable;

@end

@implementation WZMLog

+ (instancetype)log {
    static WZMLog *log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = [[WZMLog alloc] init];
    });
    return log;
}

void wzm_openLogEnable(BOOL enable) {
    WZMLog *log = [WZMLog log];
    log.enable = enable;
}

void wzm_log(NSString *format, ...) {
    if ([WZMLog log].enable) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        WZM_LOG(@"%@",str);
        va_end(args);
    }
}

@end
