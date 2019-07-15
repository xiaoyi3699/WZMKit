//
//  LLNSHandle.h
//  test
//
//  Created by wangzhaomeng on 16/8/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLNSHandle : NSObject

///email是否有效
+ (BOOL)checkEmail:(NSString *)email;

///url是否合法
+ (BOOL)checkUrl:(NSString *)candidate;

///判断手机号是否存在
+ (BOOL)checkPhoneNum:(NSString *)phoneNum;

///是否在指定时间内
+ (BOOL)isInTime:(NSString *)time days:(NSInteger)days;

///这个月有几天
+ (NSInteger)ll_getTotaldaysFromDate:(NSDate *)date;

///第一天是周几
+ (NSInteger)ll_getFirstWeekdayFromDate:(NSDate *)date;

@end
