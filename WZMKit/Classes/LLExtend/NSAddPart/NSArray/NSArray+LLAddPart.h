//
//  NSArray+AddPart.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/9/14.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLEnum.h"

@interface NSArray (LLAddPart)

///随机元素
- (id)ll_getRandomObject;
///数组运算
- (id)ll_getResultWithStyle:(LLTakingValueStyle)style;
///谓词搜索
- (NSArray *)ll_searchWithKey:(NSString *)key;

@end

@interface NSMutableArray (LLAddPart)

///emoji表情
+ (NSMutableArray *)ll_getEmojis;
+ (NSMutableArray *)ll_getEmojisBeginCode:(unsigned int)code1 endCode:(unsigned int)code2;

///倒序
- (void)ll_reverse;
///随机排序
- (void)ll_shuffle;

/* 数组排序
 1、创建随机数组
 NSMutableArray *nums = [[NSMutableArray alloc] initWithCapacity:20];
 for (NSInteger i = 0; i < 20; i ++) {
 NSInteger j = arc4random()%100;
 LLBaseModel *model = [[LLBaseModel alloc] init];
 model.age = j;
 [nums addObject:model];
 }
 
 2、排序(可变数组可自身排序)
 NSArray *array = [nums sortedArrayUsingComparator:^NSComparisonResult(LLBaseModel *obj1, LLBaseModel *obj2) {
 //按照升续排列
 if (obj1.age > obj2.age){
 return NSOrderedDescending;
 }
 else if (obj1.age == obj2.age){
 return NSOrderedSame;
 }
 else{
 return NSOrderedAscending;
 }
 }];
 
 3、打印排序结果
 for (NSInteger i = 0; i < 20; i ++) {
 LLBaseModel *model = array[i];
 ll_log(@"age=%ld",(long)model.age);
 }
 */

@end
