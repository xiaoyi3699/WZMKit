//
//  NSObject+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (wzmcate)

#if DEBUG
+ (void)wzm_loadDealloc;
#endif

- (void)setWzm_tag:(int)wzm_tag;
- (int)wzm_tag;

- (NSString *)wzm_className;
+ (NSString *)wzm_className;

@end
