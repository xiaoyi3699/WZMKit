//
//  NSString+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/7/26.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (wzmcate)

#pragma mark - 进制转换
///10进制转换成16进制
+ (NSString *)wzm_getHexByDecimal:(NSString *)decimal;
///16进制转换成10进制
+ (NSString *)wzm_getDecimalByHex:(NSString *)hex;
///10进制转换成2进制
+ (NSString *)wzm_getBinaryByDecimal:(NSInteger)decimal;
///2进制转换成10进制
+ (NSInteger)wzm_getDecimalByBinary:(NSString *)binary;
///2进制转换成16进制
+ (NSString *)wzm_getHexByBinary:(NSString *)binary;
///16进制转换成2制
+ (NSString *)wzm_getBinaryByHex:(NSString *)hex;
///NSData转16进制
+ (NSString *)wzm_getHexByData:(NSData *)data;

#pragma mark - 时间、日期
///计算星座
+ (NSString *)wzm_getAstroByBirthday:(NSDate *)birthday;
///计算年龄
+ (NSString *)wzm_getAgeByBirthday:(NSDate *)birthday;
///日期转换为时间戳
+ (NSString *)wzm_getTimeStampByDate:(NSDate *)date;
///日期转换为字符串
+ (NSString *)wzm_getTimeStringByDate:(NSDate *)date;
///获取时间差, 今天:、昨天:、2000年01月01日 00:00:00
+ (NSString *)wzm_getDTimeByDate:(NSDate *)date;

#pragma mark - 其他
///是否为空
+ (BOOL)wzm_isBlankString:(NSString *)str;
///是否含有汉字
+ (BOOL)wzm_isContainChinese:(NSString *)str;
///字典/数组转json
+ (NSString *)wzm_getJsonByObj:(id)obj;
///json转字典/数组
+ (id)wzm_getObjByJson:(NSString *)json;
///color转16进制字符串
+ (NSString *)wzm_getHexByColor:(UIColor *)color;
///图片转换为base64编码
+ (NSString *)wzm_getBase64ByImage:(UIImage *)image;
///多个字符串拼接
+ (NSString *)wzm_getStringByFormat:(NSString *)value,...;
///随机字符串
+ (NSString *)wzm_getRandomWithConut:(int)count;
///获取随机不重复字符串(重复几率很小)
+ (NSString *)wzm_getUniqueString;
///阿拉伯数字转中文格式
+ (NSString *)wzm_getChineseByArebic:(NSString *)arebic;
///将秒数换算成具体时长
+ (NSString *)wzm_getTimeBySecond:(NSInteger)second;
//获取实际使用的LaunchImage图片
+ (NSString *)wzm_getLaunchImageName;
///data转字符串
+ (NSString *)wzm_getStringByData:(NSData *)data;
///剪切板
+ (NSString *)wzm_getPasteboardString;
+ (void)wzm_setPasteboardString:(NSString *)string;
///将十六进制的编码转为 emoji 字符串
+ (NSString *)wzm_getEmojiByIntCode:(unsigned int)intCode;
///将十六进制的编码转为 emoji 字符串
+ (NSString *)wzm_getEmojiByStringCode:(NSString *)stringCode;
///计算高度
+ (CGFloat)wzm_heightWithStr:(NSString *)string width:(CGFloat)width font:(UIFont *)font;

#pragma mark - 实例方法
///MD5编码
- (NSString *)wzm_getMD5;
///unicode编码
- (NSString *)wzm_getUniEncode;
///unicode解码
- (NSString *)wzm_getUniDecode;
///URLEnCode编码
- (NSString *)wzm_getURLEncoded;
- (NSString *)wzm_getURLEncoded2;
///URLEnCode解码
- (NSString *)wzm_getURLDecoded;
///遍历字符(支持emjio表情遍历)
- (void)wzm_enumerateSubstrings:(void(^)(NSString *subStr, NSRange range))completion;
///正则匹配
- (NSString *)wzm_mstchStrWithRegular:(NSString *)regular;
///匹配两个字符之间的字符
- (NSString *)wzm_mstchStrBetweenStr1:(NSString *)str1 str2:(NSString *)str2;
///根据多个字符串截取
- (NSArray *)wzm_componentsByStringSet:(NSString *)stringSet;
///asc码提取字符串
- (NSArray *)wzm_specifiedWithStartASC:(int)start endASC:(int)end unnecessaries:(NSArray **)unnecessaries;
///汉字转拼音
- (NSString *)wzm_getPinyin;
///小写
- (NSString *)wzm_getLowercase;
///大写
- (NSString *)wzm_getUppercase;
///删除特殊字符
- (NSString *)wzm_deleteSpecialCharacter;
///删除所有空格
- (NSString *)wzm_deleteAllWhitespace;
///删除字符串头尾空格
- (NSString *)wzm_deleteHeadAndTailWhitespace;
///按照字母排序
- (NSComparisonResult)wzm_compareOtherString:(NSString *)otherString;

@end

@interface NSMutableString (wzmcate)


@end
