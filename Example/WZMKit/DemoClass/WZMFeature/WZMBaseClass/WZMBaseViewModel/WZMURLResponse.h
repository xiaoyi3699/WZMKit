//
//  WZMURLResponse.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

///自定义状态码
typedef NS_ENUM(NSInteger, WZMURLResponseCode) {
    WZMURLResponseCodeFail    = 0, //请求失败
    WZMURLResponseCodeSuccess = 1, //请求成功
};

@interface WZMURLResponse : NSObject

///状态码
@property (nonatomic, assign) WZMURLResponseCode code;
///提示信息
@property (nonatomic, strong) NSString *message;
///请求返回值
@property (nonatomic, assign) id data;
///请求返回值字符串
@property (nonatomic, strong) NSString *dataStr;
///请求返回的错误信息
@property (nonatomic, strong) NSError *error;
///服务器获取的时间
@property (nonatomic, strong) NSString *serverTime;

@end
