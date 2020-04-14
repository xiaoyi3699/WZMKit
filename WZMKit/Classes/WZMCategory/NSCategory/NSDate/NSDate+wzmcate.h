//
//  NSDate+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (wzmcate)

///获取当前时区与系统时区的差值
+ (NSTimeInterval)wzm_getDTimeValue;
///时间戳转换为日期
+ (NSDate *)wzm_getDateByTimeStamp:(NSString *)timeStamp;
///根据timeString串获取date(timeString格式:@"2016-08-01 15:28:30")
+ (NSDate *)wzm_getDateByTimeString:(NSString *)timeString;
///判断是不是今天
+ (BOOL)wzm_isToday:(NSDate *)date;
///判断两个日期是否在同一周
+ (BOOL)wzm_isInSameWeek:(NSDate *)date1 date2:(NSDate *)date2;
///是否在指定时间内
+ (BOOL)wzm_isInTime:(NSString *)time days:(NSInteger)days;
///这个月有几天
+ (NSInteger)wzm_getTotaldaysByDate:(NSDate *)date;
///第一天是周几
+ (NSInteger)wzm_getFirstWeekdayByDate:(NSDate *)date;

@end
