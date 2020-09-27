//
//  WZMJSONParse.h
//  WZMFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WZMJSONParse : NSObject

+ (BOOL)getBoolValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

+ (NSInteger)getIntegerValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

+ (CGFloat)getFloatValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

+ (NSString *)getStringValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

+ (NSDictionary *)getDictionaryValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

+ (NSArray *)getArrayValueInDict:(NSDictionary *)dict withKey:(NSString *)key;

@end
