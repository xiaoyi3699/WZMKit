//
//  NSData+wzmcate.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/9/8.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLEnum.h"

@interface NSData (wzmcate)

///16进制转NSData
+ (NSData *)wzm_getDataByHex1:(NSString *)hex;
+ (NSData *)wzm_getDataByHex2:(NSString *)hex;

///字典/数组转换为NSData
+ (NSData *)wzm_getDataByObj:(id)obj;

///NSString转换成NSData
+ (NSData *)wzm_getDataByString:(NSString *)string;

//获取图片扩展名
- (LLImageType)wzm_contentType;

@end

@interface NSMutableData (wzmcate)

@end
