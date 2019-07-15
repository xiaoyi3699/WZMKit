//
//  NSObject+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (wzmcate)

#pragma mark - 为系统类追加属性
- (void)setStrFlag:(NSString *)strFlag;
- (NSString *)strFlag;

- (void)setIntFlag:(int)intFlag;
- (int)intFlag;

- (NSString *)className;
+ (NSString *)className;

@end
