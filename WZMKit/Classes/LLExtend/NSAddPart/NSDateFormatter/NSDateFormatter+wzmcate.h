//
//  NSDateFormatter+wzmcate.h
//  test
//
//  Created by XHL on 16/8/16.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (wzmcate)

+ (NSDateFormatter *)wzm_defaultDateFormatter;
+ (NSDateFormatter *)wzm_detailDateFormatter;
+ (NSDateFormatter *)wzm_dateFormatter:(NSString *)f;

@end
