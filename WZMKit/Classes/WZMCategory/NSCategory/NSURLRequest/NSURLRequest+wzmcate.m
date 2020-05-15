//
//  NSURLRequest+wzmcate.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/15.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "NSURLRequest+wzmcate.h"

@implementation NSURLRequest (wzmcate)

- (NSURLRequest *)wzm_handlingRequest {
    NSMutableURLRequest *request;
    if ([self isKindOfClass:[NSMutableURLRequest class]]) {
        request = (NSMutableURLRequest *)self;
    }
    else {
        request = [self mutableCopy];
    }
    return request;
}

@end
