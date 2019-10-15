//
//  WZMProviderDataCache.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/5/29.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//  网络请求的缓存处理

#import <Foundation/Foundation.h>
#import "WZMBlock.h"

@interface WZMProviderDataCache : NSObject

+ (instancetype)cache;
///存数据
- (NSString *)storeData:(id)data forKey:(NSString *)key;
///取数据
- (id)dataForKey:(NSString *)key;
///文件路径
- (NSString *)filePathForKey:(NSString *)key;
///清理内存
- (void)clearMemory;
///清理所有数据
- (void)clearAllCacheCompletion:(doBlock)completion;

@end
