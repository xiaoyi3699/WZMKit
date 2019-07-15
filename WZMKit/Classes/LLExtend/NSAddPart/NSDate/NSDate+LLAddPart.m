//
//  NSDate+LLAddPart.m
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "NSDate+LLAddPart.h"
#import "NSDateFormatter+LLAddPart.h"

@implementation NSDate (LLAddPart)

+ (NSTimeInterval)ll_getDTimeValue {
    NSDate *date = [NSDate date];//获得时间对象
    NSTimeZone *zone = [NSTimeZone localTimeZone];//获得当前时区
    NSTimeInterval DTimeValue = [zone secondsFromGMTForDate:date];//以秒为单位返回当前时间与系统格林尼治时间的差
    return DTimeValue;
}

+ (NSDate *)ll_getDateByTimeStamp:(NSString *)timeStamp {
    NSInteger scale = 1;
    if (timeStamp.floatValue > 999999999999) {
        scale = 1000;
    }
    NSTimeInterval time = [timeStamp integerValue]/scale;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    return date;
}

+ (NSDate *)ll_getDateByTimeString:(NSString *)timeString {
    NSDateFormatter *dateFormatter = [NSDateFormatter ll_defaultDateFormatter];
    NSDate *date = [dateFormatter dateFromString:timeString];
    return date;
}

- (BOOL)ll_isInSameWeek:(NSDate *)date {
    //日期间隔大于七天之间返回NO
    if (fabs([self timeIntervalSinceDate:date]) >= 7 * 24 *3600) {
        return NO;
    }
    NSCalendar *calender = [NSCalendar currentCalendar];
    calender.firstWeekday = 2;//设置每周第一天从周一开始
    //计算两个日期分别为这年第几周
    NSUInteger countSelf = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:self];
    NSUInteger countDate = [calender ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:date];
    
    //相等就在同一周，不相等就不在同一周
    return countSelf == countDate;
}

- (BOOL)ll_isToday {
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:self];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    if([today day] == [otherDay day] &&
       [today month] == [otherDay month] &&
       [today year] == [otherDay year] &&
       [today era] == [otherDay era]) {
        return YES;
    }
    return NO;
}

@end
