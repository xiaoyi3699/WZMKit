//
//  WZMHttpResponseResult.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

///自定义状态码
typedef NS_ENUM(NSInteger, WZMHttpResponseCode) {
    WZMHttpResponseCodeFail    = 0, //请求失败
    WZMHttpResponseCodeSuccess = 1, //请求成功
};

@interface WZMHttpResponseResult : NSObject

@property (nonatomic, assign) WZMHttpResponseCode code; //状态码
@property (nonatomic, strong) NSString *message;       //提示信息
@property (nonatomic, strong) NSString *serverTime;    //服务器获取的时间

@end
