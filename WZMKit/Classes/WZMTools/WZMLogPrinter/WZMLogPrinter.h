//
//  MyLog.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/9/27.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

#define WZMLog(format, ...) [WZMLogPrinter log:[NSString stringWithFormat:format, ## __VA_ARGS__]]
@interface WZMLogPrinter : NSObject

+ (void)openLogEnable:(BOOL)enable;

+ (void)log:(NSString *)string;

@end
