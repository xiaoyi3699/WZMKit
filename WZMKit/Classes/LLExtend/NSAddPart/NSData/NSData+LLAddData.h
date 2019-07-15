//
//  NSData+LLAddData.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/9/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLEnum.h"

@interface NSData (LLAddData)

///16进制转NSData
+ (NSData *)ll_getDataByHex1:(NSString *)hex;
+ (NSData *)ll_getDataByHex2:(NSString *)hex;

///字典/数组转换为NSData
+ (NSData *)ll_getDataByObj:(id)obj;

///NSString转换成NSData
+ (NSData *)ll_getDataByString:(NSString *)string;

//获取图片扩展名
- (LLImageType)ll_contentType;

@end

@interface NSMutableData (LLAddPart)

@end
