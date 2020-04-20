//
//  WZMBaseDataProvider.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMHttpResponseResult.h"
#import "WZMDataProviderProtocol.h"

///网络请求方式
typedef NS_ENUM(NSInteger, WZMHttpRequestMethod) {
    WZMHttpRequestMethodGet = 0,  //HTTP Get请求
    WZMHttpRequestMethodPost,     //HTTP Post请求
    WZMHttpRequestMethodPut,      //HTTP Put请求
    WZMHttpRequestMethodDelete,   //HTTP Delet请求
    WZMHttpRequestMethodPatch,    //HTTP Patch请求
    WZMHttpRequestMethodHead,     //HTTP Head请求
};

#define WZM_LOADING @"加载中..."
#define WZM_NO_NET  @"请检查网络连接后重试"
@interface WZMBaseDataProvider : NSObject<WZMDataProviderProtocol>

@property (nonatomic, assign) NSInteger    page;           //请求的页码
@property (nonatomic, strong) NSString     *requestUrl;    //请求的URL
@property (nonatomic, strong) NSDictionary *requestParams; //请求的参数
@property (nonatomic, strong) NSDictionary *headerParams;  //请求头的参数
@property (nonatomic, assign) WZMHttpRequestMethod httpRequestMethod; //请求方式

@property (nonatomic, assign) id responseObject;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) WZMHttpResponseResult *httpResponseResult;
@property (nonatomic, assign, getter=isUseLocalCache) BOOL useLocalCache;

@end
