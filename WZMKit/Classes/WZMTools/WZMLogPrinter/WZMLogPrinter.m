//
//  MyLog.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/9/27.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMLogPrinter.h"
#import "WZMLogView.h"

@interface WZMLogPrinter ()

@property (nonatomic, assign) BOOL enable;

@end

@implementation WZMLogPrinter

+ (instancetype)printer {
    static WZMLogPrinter *printer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        printer = [[WZMLogPrinter alloc] init];
    });
    return printer;
}

+ (void)openLogEnable:(BOOL)enable {
    [WZMLogPrinter printer].enable = enable;
}

+ (void)log:(NSString *)string {
    if ([WZMLogPrinter printer].enable) {
        printf("%s\n\n", [[WZMLogView outputString:[NSString stringWithFormat:@"[WZNKitLog]: %@",string]] UTF8String]);
    }
}

@end
