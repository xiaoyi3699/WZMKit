//
//  NSDate+wzmcate.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSDate+wzmcate.h"
#import "NSDateFormatter+wzmcate.h"

@implementation NSDate (wzmcate)

+ (NSTimeInterval)wzm_getDTimeValue {
    NSDate *date = [NSDate date];//获得时间对象
    NSTimeZone *zone = [NSTimeZone localTimeZone];//获得当前时区
    NSTimeInterval DTimeValue = [zone secondsFromGMTForDate:date];//以秒为单位返回当前时间与系统格林尼治时间的差
    return DTimeValue;
}

+ (NSDate *)wzm_getDateByTimeStamp:(NSString *)timeStamp {
    NSInteger scale = 1;
    if (timeStamp.floatValue > 999999999999) {
        scale = 1000;
    }
    NSTimeInterval time = [timeStamp integerValue]/scale;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

+ (NSDate *)wzm_getDateByTimeString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [NSDateFormatter wzm_defaultDateFormatter];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

+ (BOOL)wzm_isToday:(NSDate *)date {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

+ (BOOL)wzm_isInSameWeek:(NSDate *)date1 date2:(NSDate *)date2 {
    //日期间隔大于七天之间返回NO
    if (fabs([date1 timeIntervalSinceDate:date2]) >= 7 * 24 *3600) {
        return NO;
    }
    NSCalendar *calender = [NSCalendar currentCalendar];
    calender.firstWeekday = 2;//设置每周第一天从周一开始
    //计算两个日期分别为这年第几周
    NSUInteger countDate1 = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date1];
    NSUInteger countDate2 = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date2];
    
    //相等就在同一周，不相等就不在同一周
    return countDate1 == countDate2;
}

+ (BOOL)wzm_isInTime:(NSString *)time days:(NSInteger)days{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [NSDateFormatter wzm_defaultDateFormatter];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate *nowDate=[dateFormatter dateFromString:dateString];
    NSTimeInterval lateNow=[nowDate timeIntervalSince1970]*1;
    
    NSDate * sinceDate = [dateFormatter dateFromString:time];
    NSTimeInterval lateSince = [sinceDate timeIntervalSince1970]*1;
    
    NSTimeInterval cha = lateNow - lateSince;
    
    if (cha >= days*24*3600) {
        return NO;
    }
    return YES;
}

+ (NSInteger)wzm_getTotaldaysByDate:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                                  inUnit:NSCalendarUnitMonth
                                                                 forDate:date];
    return totaldaysInMonth.length;
}

+ (NSInteger)wzm_getFirstWeekdayByDate:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear |
                                                   NSCalendarUnitMonth |
                                                   NSCalendarUnitDay)
                                         fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday
                                                  inUnit:NSCalendarUnitWeekOfMonth
                                                 forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

@end
