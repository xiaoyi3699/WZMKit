//
//  WZMBaseDataProvider.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMHttpResponseResult.h"

///网络请求方式
typedef NS_ENUM(NSInteger, WZMHttpRequestMethod) {
    WZMHttpRequestMethodGet = 0,  //HTTP Get请求
    WZMHttpRequestMethodPost,     //HTTP Post请求
    WZMHttpRequestMethodPut,      //HTTP Put请求
    WZMHttpRequestMethodDelete,   //HTTP Delet请求
    WZMHttpRequestMethodPatch,    //HTTP Patch请求
    WZMHttpRequestMethodHead      //HTTP Head请求
};
typedef void(^doHandler)(void);
#define WZM_START_PAGE 1
#define WZM_LOADING @"加载中..."
#define WZM_NO_NET  @"请检查网络连接后重试"
@interface WZMBaseDataProvider : NSObject

@property (nonatomic, assign) NSInteger    page;           //请求的页码
@property (nonatomic, strong) NSString     *requestUrl;    //请求的URL
@property (nonatomic, strong) NSDictionary *requestParams; //请求的参数
@property (nonatomic, strong) NSDictionary *headerParams;  //请求头的参数
@property (nonatomic, assign) WZMHttpRequestMethod httpRequestMethod; //请求方式

@property (nonatomic, assign) id responseObject;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) WZMHttpResponseResult *httpResponseResult;
@property (nonatomic, assign, getter=isUseLocalCache) BOOL useLocalCache;
@property (nonatomic, assign, getter=isPageEnable) BOOL pageEnable;

#pragma mark - 子类回调
///加载数据
- (void)loadData:(doHandler)loadHandler
        callBack:(doHandler)backHandler;
///解析服务端返回的字符串数据
- (void)parseJSON:(id)json;

///清空已有数据
- (void)clearLastData;

///是否为空的,默认空
- (BOOL)isDataEmpty;

#pragma mark - 页面交互使用
///下拉刷新调用
- (void)headerLoadData:(doHandler)loadHandler
              callBack:(doHandler)backHandler;
///上拉加载调用
- (void)footerLoadData:(doHandler)loadHandler
              callBack:(doHandler)backHandler;

@end
