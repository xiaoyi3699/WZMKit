//
//  MyLog.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/27.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLLog.h"

#define LL_LOG(format, ...) printf("[LLFeatureLog]: %s\n\n", [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
@interface LLLog ()

@property (nonatomic, assign) BOOL enable;

@end

@implementation LLLog

+ (instancetype)log {
    static LLLog *log;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        log = [[LLLog alloc] init];
    });
    return log;
}

void ll_openLogEnable(BOOL enable) {
    LLLog *log = [LLLog log];
    log.enable = enable;
}

void ll_log(NSString *format, ...) {
    if ([LLLog log].enable) {
        va_list args;
        va_start(args, format);
        NSString *str = [[NSString alloc] initWithFormat:format arguments:args];
        LL_LOG(@"%@",str);
        va_end(args);
    }
}

@end
