//
//  LLJSONParseUtil.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLJSONParseUtil.h"
#import "LLLog.h"

@implementation LLJSONParseUtil

+ (long long)getLongValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id tmp = nil;
    @try {
        tmp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (tmp == nil) {
        return 0;
    }
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp isKindOfClass:[NSString class]]) {
        return [tmp longLongValue];
    }
    return 0;
}

+ (NSInteger)getIntValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id tmp = nil;
    @try {
        tmp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (tmp == nil) {
        return 0;
    }
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp isKindOfClass:[NSString class]]) {
        return [tmp integerValue];
    }
    return 0;
}

+ (BOOL)getBoolValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id tmp = nil;
    @try {
        tmp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (tmp == nil) {
        return NO;
    }
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp isKindOfClass:[NSString class]]) {
        return [tmp boolValue];
    }
    return NO;
}

+ (float)getFloatValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id tmp = nil;
    @try {
        tmp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (tmp == nil) {
        return 0.0f;
    }
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp isKindOfClass:[NSString class]]) {
        return [tmp floatValue];
    }
    return 0.0f;
}

+ (NSString *)getStringValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id temp = nil;
    @try {
        temp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (temp == nil) {
        return @"";
    }
    if ([temp isKindOfClass:[NSString class]]) {
        return temp;
    }
    if ([temp isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",temp];
    }
    return @"";
}

+ (NSNumber *)getNumberValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [LLJSONParseUtil getDataInDict:dict withKey:key ofClass:[NSNumber class]];
}

+ (NSDictionary *)getDictionaryValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [LLJSONParseUtil getDataInDict:dict withKey:key ofClass:[NSDictionary class]];
}

+ (NSArray *)getArrayValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [LLJSONParseUtil getDataInDict:dict withKey:key ofClass:[NSArray class]];
}

+ (NSMutableArray *)getMutableArrayValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [[LLJSONParseUtil getArrayValueInDict:dict withKey:key] mutableCopy];
}

+ (id)getDataInDict:(NSDictionary *)dict withKey:(NSString *)key ofClass:(Class)class {
    id temp = nil;
    @try {
        temp = [dict objectForKey:key];
    }
    @catch (NSException *exception) {
        ll_log(@"很遗憾的跟你说，程序出错了：%@",exception);
    }
    if (temp == nil) {
        return nil;
    }
    return [temp isKindOfClass:class]?temp:nil;
}

@end
