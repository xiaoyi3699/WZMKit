//
//  WZMNetWorking.h
//  WZMFoundation
//
//  Created by zhaomengWang on 17/3/23.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMEnum.h"

extern NSString * const WZMNetRequestContentTypeForm;
extern NSString * const WZMNetRequestContentTypeJson;

@interface WZMNetWorking : NSObject

///发起请求时的参数格式 - 默认值: WZMNetRequestContentTypeForm, 键值对格式
@property (nonatomic, assign) NSString *requestContentType;
///请求返回的数据格式 - 默认值: WZMNetResultContentTypeJson, json格式
@property (nonatomic, assign) WZMNetResultContentType resultContentType;

+ (instancetype)netWorking;

- (NSURLSessionDataTask *)request:(NSURLRequest *)request callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)method:(NSString *)method url:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)GET:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)POST:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)PUT:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)DELETE:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)PATCH:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

- (NSURLSessionDataTask *)HEAD:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack;

/**
 文件流格式上传
 
 @param url      上传地址
 @param key      对应字段名
 @param filename 文件名称
 @param mimeType 文件类型
 @param data     要上传的文件
 @param params   其他参数
 */
- (void)uploadUrl:(NSString *)url
              key:(NSString *)key
         filename:(NSString *)filename
         mimeType:(NSString *)mimeType
             data:(NSData *)data
           parmas:(NSDictionary *)params
         callBack:(void(^)(id responseObject,NSError *error))callBack;

@end
