//
//  LLBaseDataProvider.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLBaseDataProvider.h"
#import "LLProviderDataCache.h"

@implementation LLBaseDataProvider

- (id)init{
    self = [super init];
    if (self) {
        self.useLocalCache = NO;
        self.httpResponseResult = [[LLHttpResponseResult alloc] init];
    }
    return self;
}

- (void)loadData:(doHandler)loadHandler callBack:(doHandler)backHandler {
    [WZMViewHandle wzm_setNetworkActivityIndicatorVisible:YES];
    if (loadHandler) {
        loadHandler();
    }
    if (self.isUseLocalCache) {
        id responseObject = [[LLProviderDataCache dataCache] dataForKey:self.requestUrl];
        if (responseObject) {
            [self handleResponseObj:responseObject
                              error:nil
                           callBack:backHandler
                          cacheData:NO];
            return;
        }
    }
    NSString *method = @"";
    if (self.httpRequestMethod == LLHttpRequestMethodGet) {
        method = @"GET";
    }
    else if (self.httpRequestMethod == LLHttpRequestMethodPost) {
        method = @"POST";
    }
    else if (self.httpRequestMethod == LLHttpRequestMethodPut) {
        method = @"PUT";
    }
    else if (self.httpRequestMethod == LLHttpRequestMethodDelete) {
        method = @"DELETE";
    }
    else if (self.httpRequestMethod == LLHttpRequestMethodPatch) {
        method = @"PATCH";
    }
    else if (self.httpRequestMethod == LLHttpRequestMethodHead) {
        method = @"HEAD";
    }
    
    if (self.dataTask) {
        [self.dataTask cancel];
        self.dataTask = nil;
    }
    
    self.dataTask = [[WZMNetWorking netWorking] method:method url:self.requestUrl parameters:self.requestParams callBack:^(id responseObject, NSError *error) {
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
        [[LLProviderDataCache dataCache] storeData:responseObject forKey:self.requestUrl];
    }
}

- (void)handleResponseObj:(id)responseObject error:(NSError *)error callBack:(doHandler)backHandler {
    [WZMViewHandle wzm_setNetworkActivityIndicatorVisible:NO];
    self.responseObject = responseObject;
    if (error) {
        //自定义返回信息和状态码
        self.httpResponseResult.code    = LLHttpResponseCodeFail;
        self.httpResponseResult.message = WZM_NO_NET;
        [self clearMemoryData];
    }
    else {
        //mark: 自定义返回信息和状态码
        self.httpResponseResult.code    = LLHttpResponseCodeSuccess;
        self.httpResponseResult.message = @"自定义message";
        //mark: 自定义返回信息和状态码
        
        if (self.httpResponseResult.code == LLHttpResponseCodeSuccess) {
            self.page ++;
            if ([self respondsToSelector:@selector(parseJSON:)]) {
                [self parseJSON:responseObject];
            }
            //NSAssert(0, @"Sub dataprovider must implement parseJSON:");
        }
        else {
            [self clearMemoryData];
        }
    }
    if (backHandler) {
        backHandler();
    }
}

#pragma mark - 数据解析
- (void)parseJSON:(id)json{
    if (self.page == LL_START_PAGE+1) {
        [self clearMemoryData];
    }
}

- (void)clearMemoryData {
    
}

- (void)refreshData {
    self.page = LL_START_PAGE;
}

- (BOOL)isDataEmpty {
    return YES;
}

- (void)dealloc {
    NSLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
