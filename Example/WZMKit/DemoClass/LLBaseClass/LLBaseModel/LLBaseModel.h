//
//  LLBaseModel.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/21.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLBaseModel : NSObject<NSCoding>

///将字典转化为model
+ (instancetype)modelWithDic:(NSDictionary *)dic;

///将model转化为字典
- (NSDictionary *)transfromDictionary;

///获取类的所有属性名称与类型
+ (NSArray *)allPropertyName;

///解档
+ (instancetype)ll_unarchiveObjectWithData:(NSData *)data;

@end

@interface NSData (LLBaseModel)

///归档
+ (NSData *)ll_archivedDataWithModel:(LLBaseModel *)model;

@end
