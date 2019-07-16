//
//  MyLog.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/27.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMLog : NSObject

void wzm_openLogEnable(BOOL enable);

void wzm_log(NSString *format, ...);

@end
