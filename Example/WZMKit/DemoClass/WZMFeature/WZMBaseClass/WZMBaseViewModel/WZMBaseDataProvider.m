//
//  WZMBaseDataProvider.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMBaseDataProvider.h"
#import "WZMProviderDataCache.h"
#import "WZMNetWorking.h"
#import "WZMViewHandle.h"

@interface WZMBaseDataProvider ()

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, assign) id responseObject;
@property (nonatomic, strong) NSString *responseStr;
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) WZMHttpResponseResult *httpResponseResult;

@end

@implementation WZMBaseDataProvider

- (id)init{
    self = [super init];
    if (self) {
        self.pageEnable = NO;
        self.useLocalCache = NO;
        self.page = WZM_START_PAGE;
        self.httpResponseResult = [[WZMHttpResponseResult alloc] init];
    }
    return self;
}

- (void)loadData:(doHandler)loadHandler callBack:(doHandler)backHandler {
    [WZMViewHandle wzm_setNetworkActivityIndicatorVisible:YES];
    if (loadHandler) {
        loadHandler();
    }
    if (self.isUseLocalCache) {
        id responseObject = [[WZMProviderDataCache shareCache] dataForKey:self.requestUrl];
        if (responseObject) {
            [self handleResponseObj:responseObject
                              error:nil
                           callBack:backHandler
                          cacheData:NO];
            return;
        }
    }
    NSString *method = @"";
    if (self.httpRequestMethod == WZMHttpRequestMethodGet) {
        method = @"GET";
    }
    else if (self.httpRequestMethod == WZMHttpRequestMethodPost) {
        method = @"POST";
    }
    else if (self.httpRequestMethod == WZMHttpRequestMethodPut) {
        method = @"PUT";
    }
    else if (self.httpRequestMethod == WZMHttpRequestMethodDelete) {
        method = @"DELETE";
    }
    else if (self.httpRequestMethod == WZMHttpRequestMethodPatch) {
        method = @"PATCH";
    }
    else if (self.httpRequestMethod == WZMHttpRequestMethodHead) {
        method = @"HEAD";
    }
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    if (self.isPageEnable) {
        //拼接分页信息
        NSMutableDictionary *params;
        if (self.requestParams == nil) {
            params = [[NSMutableDictionary alloc] init];
        }
        else {
            params = [self.requestParams mutableCopy];
        }
        [params setValue:@(self.page) forKey:@"page"];
        self.requestParams = [params copy];
    }
    self.dataTask = [[WZMNetWorking shareNetWorking] method:method url:self.requestUrl parameters:self.requestParams callBack:^(id responseObject, NSError *error) {
        [self handleResponseObj:responseObject
                          error:error
                       callBack:backHandler
                      cacheData:YES];
    }];
    [self.dataTask resume];
}

- (void)handleResponseObj:(id)responseObject error:(NSError *)error callBack:(doHandler)backHandler cacheData:(BOOL)cacheData {
    [self handleResponseObj:responseObject error:error callBack:backHandler];
    if (self.isUseLocalCache && cacheData && responseObject && error == nil) {
        [[WZMProviderDataCache shareCache] storeData:responseObject forKey:self.requestUrl];
    }
}

- (void)handleResponseObj:(id)responseObject error:(NSError *)error callBack:(doHandler)backHandler {
    [WZMViewHandle wzm_setNetworkActivityIndicatorVisible:NO];
    self.responseObject = responseObject;
    if (error) {
        //自定义返回信息和状态码
        self.error = error;
        self.httpResponseResult.code    = WZMHttpResponseCodeFail;
        self.httpResponseResult.message = WZM_NO_NET;
        [self clearLastData];
    }
    else {
        if ([responseObject isKindOfClass:[NSData class]]) {
            self.responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        //mark: 自定义返回信息和状态码
        self.httpResponseResult.code    = WZMHttpResponseCodeSuccess;
        self.httpResponseResult.message = @"自定义message";
        //mark: 自定义返回信息和状态码
        
        if (self.httpResponseResult.code == WZMHttpResponseCodeSuccess) {
            if (self.page == WZM_START_PAGE) {
                [self clearLastData];
            }
            if (self.isPageEnable) {
                self.page ++;
            }
            if ([self respondsToSelector:@selector(parseJSON:)]) {
                [self parseJSON:responseObject];
            }
            //NSAssert(0, @"Sub dataprovider must implement parseJSON:");
        }
        else {
            [self clearLastData];
        }
    }
    if (backHandler) {
        backHandler();
    }
}

#pragma mark - 数据解析
- (void)parseJSON:(id)json{
    
}

- (void)clearLastData {
    
}

- (BOOL)isDataEmpty {
    return YES;
}

#pragma mark - 页面交互使用
//下拉刷新调用
- (void)headerLoadData:(doHandler)loadHandler
              callBack:(doHandler)backHandler {
    self.page = WZM_START_PAGE;
    [self loadData:loadHandler callBack:backHandler];
}

//上拉加载调用
- (void)footerLoadData:(doHandler)loadHandler
              callBack:(doHandler)backHandler {
    [self loadData:loadHandler callBack:backHandler];
}

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
