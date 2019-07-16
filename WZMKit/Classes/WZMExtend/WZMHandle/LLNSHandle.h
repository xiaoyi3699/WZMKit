//
//  LLNSHandle.h
//  test
//
//  Created by wangzhaomeng on 16/8/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLNSHandle : NSObject

///email是否有效
+ (BOOL)wzm_checkEmail:(NSString *)email;

///url是否合法
+ (BOOL)wzm_checkUrl:(NSString *)candidate;

///判断手机号是否存在
+ (BOOL)wzm_checkPhoneNum:(NSString *)phoneNum;

@end
