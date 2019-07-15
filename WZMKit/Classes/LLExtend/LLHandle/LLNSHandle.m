//
//  LLNSHandle.m
//  test
//
//  Created by wangzhaomeng on 16/8/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLNSHandle.h"
#import "NSDateFormatter+LLAddPart.h"

@implementation LLNSHandle

+ (BOOL)checkEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)checkUrl:(NSString *)candidate{
    NSString *urlRegEx =
    @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    if ([candidate hasPrefix:@"www"]){
        candidate = [NSString stringWithFormat:@"http://%@", candidate];
    }
    BOOL isVaild = [urlTest evaluateWithObject:candidate];
    return isVaild;
}

+ (BOOL)checkPhoneNum:(NSString *)phoneNum{
    if (phoneNum.length != 11) {
        return NO;
    }
    NSString *phoneRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

+ (BOOL)isInTime:(NSString *)time days:(NSInteger)days{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [NSDateFormatter ll_defaultDateFormatter];
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

+ (NSInteger)ll_getTotaldaysFromDate:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                                                  inUnit:NSCalendarUnitMonth
                                                                 forDate:date];
    return totaldaysInMonth.length;
}

+ (NSInteger)ll_getFirstWeekdayFromDate:(NSDate *)date{
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
