//
//  WZMNSHandle.m
//  test
//
//  Created by wangzhaomeng on 16/8/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMNSHandle.h"
#import "NSDateFormatter+wzmcate.h"

@implementation WZMNSHandle

+ (BOOL)wzm_checkEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)wzm_checkUrl:(NSString *)candidate{
    NSString *urlRegEx =
    @"(http|ftp|https):\\/\\/[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    if ([candidate hasPrefix:@"www"]){
        candidate = [NSString stringWithFormat:@"http://%@", candidate];
    }
    BOOL isVaild = [urlTest evaluateWithObject:candidate];
    return isVaild;
}

+ (BOOL)wzm_checkPhoneNum:(NSString *)phoneNum{
    if (phoneNum.length != 11) {
        return NO;
    }
    NSString *phoneRegex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNum];
}

@end
