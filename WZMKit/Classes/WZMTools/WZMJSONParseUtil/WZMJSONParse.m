//
//  WZMJSONParse.m
//  WZMFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMJSONParse.h"
#import "WZMLogPrinter.h"

@implementation WZMJSONParse

+ (BOOL)getBoolValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [[self getDataInDict:dict withKey:key] boolValue];
}

+ (NSInteger)getIntegerValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [[self getDataInDict:dict withKey:key] integerValue];
}

+ (CGFloat)getFloatValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    return [[self getDataInDict:dict withKey:key] doubleValue];
}

+ (NSString *)getStringValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id v = [self getDataInDict:dict withKey:key];
    return [NSString stringWithFormat:@"%@",v];
}

+ (NSDictionary *)getDictionaryValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id v = [self getDataInDict:dict withKey:key];
    if ([v isKindOfClass:[NSDictionary class]]) return v;
    return nil;
}

+ (NSArray *)getArrayValueInDict:(NSDictionary *)dict withKey:(NSString *)key {
    id v = [self getDataInDict:dict withKey:key];
    if ([v isKindOfClass:[NSArray class]]) return v;
    return nil;
}

+ (id)getDataInDict:(NSDictionary *)dict withKey:(NSString *)key {
    if (key == nil || dict == nil) return nil;
    if ([dict isKindOfClass:[NSDictionary class]] == NO) return nil;
    return [dict objectForKey:key];
}

@end
