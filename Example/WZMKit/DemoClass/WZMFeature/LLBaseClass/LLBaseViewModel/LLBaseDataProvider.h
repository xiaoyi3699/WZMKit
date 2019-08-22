//
//  LLBaseDataProvider.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LLHttpResponseResult.h"
#import "LLDataProviderProtocol.h"

///网络请求方式
typedef enum : NSInteger {
    LLHttpRequestMethodGet = 0,  //HTTP Get请求
    LLHttpRequestMethodPost,     //HTTP Post请求
    LLHttpRequestMethodPut,      //HTTP Put请求
    LLHttpRequestMethodDelete,   //HTTP Delet请求
    LLHttpRequestMethodPatch,    //HTTP Patch请求
    LLHttpRequestMethodHead,     //HTTP Head请求
} LLHttpRequestMethod;

#define WZM_LOADING @"加载中..."
#define WZM_NO_NET  @"请检查网络连接后重试"
@interface LLBaseDataProvider : NSObject<LLDataProviderProtocol>

@property (nonatomic, assign) NSInteger    page;           //请求的页码
@property (nonatomic, strong) NSString     *requestUrl;    //请求的URL
@property (nonatomic, strong) NSDictionary *requestParams; //请求的参数
@property (nonatomic, strong) NSDictionary *headerParams;  //请求头的参数
@property (nonatomic, assign) LLHttpRequestMethod httpRequestMethod; //请求方式

@property (nonatomic, assign) id responseObject;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) LLHttpResponseResult *httpResponseResult;
@property (nonatomic, assign, getter=isUseLocalCache) BOOL useLocalCache;

@end
