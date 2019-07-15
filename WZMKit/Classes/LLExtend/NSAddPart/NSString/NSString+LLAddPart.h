//
//  NSString+LLAddPart.h
//  test
//
//  Created by wangzhaomeng on 16/7/26.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (LLAddPart)

#pragma mark - 进制转换
///10进制转换成16进制
+ (NSString *)ll_getHexByDecimal:(NSString *)decimal;
///16进制转换成10进制
+ (NSString *)ll_getDecimalByHex:(NSString *)hex;
///10进制转换成2进制
+ (NSString *)ll_getBinaryByDecimal:(NSInteger)decimal;
///2进制转换成10进制
+ (NSInteger)ll_getDecimalByBinary:(NSString *)binary;
///2进制转换成16进制
+ (NSString *)ll_getHexByBinary:(NSString *)binary;
///16进制转换成2制
+ (NSString *)ll_getBinaryByHex:(NSString *)hex;
///NSData转16进制
+ (NSString *)ll_getHexByData:(NSData *)data;

#pragma mark - 时间、日期
///计算星座
+ (NSString *)ll_getAstroByBirthday:(NSDate *)birthday;
///计算年龄
+ (NSString *)ll_getAgeByBirthday:(NSDate *)birthday;
///日期转换为时间戳
+ (NSString *)ll_getTimeStampByDate:(NSDate *)date;
///日期转换为字符串
+ (NSString *)ll_getTimeStringByDate:(NSDate *)date;
///获取时间差, 今天:、昨天:、2000年01月01日 00:00:00
+ (NSString *)ll_getDTimeByDate:(NSDate *)date;

#pragma mark - 其他
///是否为空
+ (BOOL)ll_isBlankString:(NSString *)str;
///是否含有汉字
+ (BOOL)ll_isContainChinese:(NSString *)str;
///字典/数组转json
+ (NSString *)ll_getJsonByObj:(id)obj;
///json转字典/数组
+ (id)ll_getObjByJson:(NSString *)json;
///color转16进制字符串
+ (NSString *)ll_getHexByColor:(UIColor *)color;
///图片转换为base64编码
+ (NSString *)ll_getBase64ByImage:(UIImage *)image;
///多个字符串拼接
+ (NSString *)ll_getStringByFormat:(NSString *)value,...;
///随机字符串
+ (NSString *)ll_getRandomWithConut:(int)count;
///获取随机不重复字符串(重复几率很小)
+ (NSString *)ll_getUniqueString;
///阿拉伯数字转中文格式
+ (NSString *)ll_getChineseByArebic:(NSString *)arebic;
///将秒数换算成具体时长
+ (NSString *)ll_getTimeBySecond:(NSInteger)second;
//获取实际使用的LaunchImage图片
+ (NSString *)ll_getLaunchImageName;
///data转字符串
+ (NSString *)ll_getStringByData:(NSData *)data;
///剪切板
+ (NSString *)ll_getPasteboardString;
+ (void)ll_setPasteboardString:(NSString *)string;
///将十六进制的编码转为 emoji 字符串
+ (NSString *)ll_getEmojiByIntCode:(unsigned int)intCode;
///将十六进制的编码转为 emoji 字符串
+ (NSString *)ll_getEmojiByStringCode:(NSString *)stringCode;
///计算高度
+ (CGFloat)ll_heightWithStr:(NSString *)string width:(CGFloat)width font:(UIFont *)font;

#pragma mark - 实例方法
///MD5编码
- (NSString *)ll_getMD5;
///unicode编码
- (NSString *)ll_getUniEncode;
///unicode解码
- (NSString *)ll_getUniDecode;
///URLEnCode编码
- (NSString *)ll_getURLEncoded;
- (NSString *)ll_getURLEncoded2;
///URLEnCode解码
- (NSString *)ll_getURLDecoded;
///正则匹配
- (NSString *)ll_mstchStrWithRegular:(NSString *)regular;
///匹配两个字符之间的字符
- (NSString *)ll_mstchStrBetweenStr1:(NSString *)str1 str2:(NSString *)str2;
///根据多个字符串截取
- (NSArray *)ll_componentsByStringSet:(NSString *)stringSet;
///asc码提取字符串
- (NSArray *)ll_specifiedWithStartASC:(int)start endASC:(int)end unnecessaries:(NSArray **)unnecessaries;
///汉字转拼音
- (NSString *)ll_getPinyin;
///小写
- (NSString *)ll_getLowercase;
///大写
- (NSString *)ll_getUppercase;
///删除特殊字符
- (NSString *)ll_deleteSpecialCharacter;
///删除所有空格
- (NSString *)ll_deleteAllWhitespace;
///删除字符串头尾空格
- (NSString *)ll_deleteHeadAndTailWhitespace;
///按照字母排序
- (NSComparisonResult)ll_compareOtherString:(NSString *)otherString;

@end

@interface NSMutableString (AddPart)


@end
