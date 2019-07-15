//
//  LLNetWorking.m
//  LLFoundation
//
//  Created by zhaomengWang on 17/3/23.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLNetWorking.h"
#import "LLLog.h"
#import "NSString+LLAddPart.h"

NSString * const LLNetRequestContentTypeForm = @"application/x-www-form-urlencoded";
NSString * const LLNetRequestContentTypeJson = @"application/json;charset=utf-8";

@interface LLNetWorking ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSSet *HTTPMethodsEncodingParametersInURI;

@end

@implementation LLNetWorking

+ (instancetype)netWorking {
    static LLNetWorking *netWorking;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorking = [[LLNetWorking alloc] init];
    });
    return netWorking;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestContentType = LLNetRequestContentTypeForm;
        self.resultContentType = LLNetResultContentTypeJson;
        self.HTTPMethodsEncodingParametersInURI = [NSSet setWithObjects:@"GET",@"HEAD",@"DELETE",@"PATCH",nil];
    }
    return self;
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig];
    }
    return _session;
}

- (NSURLSessionDataTask *)GET:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"GET" url:url parameters:parameters callBack:callBack];
}

- (NSURLSessionDataTask *)POST:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"POST" url:url parameters:parameters callBack:callBack];
}

- (NSURLSessionDataTask *)PUT:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"PUT" url:url parameters:parameters callBack:callBack];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"DELETE" url:url parameters:parameters callBack:callBack];
}

- (NSURLSessionDataTask *)PATCH:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"PATCH" url:url parameters:parameters callBack:callBack];
}

- (NSURLSessionDataTask *)HEAD:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    return [self method:@"HEAD" url:url parameters:parameters callBack:callBack];
}

///参数拼接
- (NSURLSessionDataTask *)method:(NSString *)method url:(NSString *)url parameters:(id)parameters callBack:(void(^)(id responseObject,NSError *error))callBack {
    NSURL *URL = [NSURL URLWithString:url];
    if (URL == nil) {
        URL = [NSURL URLWithString:[url ll_getURLEncoded]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;
    
    if (parameters) {
        NSString *params = [self ll_parameters:parameters];
        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[method uppercaseString]]) {
            NSString *formattUrl = [url stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", params];
            NSURL *formattURL = [NSURL URLWithString:formattUrl];
            if (formattURL == nil) {
                formattURL = [NSURL URLWithString:[formattUrl ll_getURLEncoded]];
            }
            request.URL = formattURL;
        }
        else {
            [request setValue:self.requestContentType forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    return [self request:[self handlingRequest:request] callBack:callBack];
}

///发起请求
- (NSURLSessionDataTask *)request:(NSURLRequest *)request callBack:(void(^)(id responseObject,NSError *error))callBack {
    NSURLSessionDataTask *task = [[self session] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        //            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //            NSLog(@"%ld",(long)httpResponse.statusCode);
        //        }
        if (callBack) {
            if (self.resultContentType == LLNetResultContentTypeData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(data,error);
                });
            }
            else {
                NSError *jsonError; id resultObj;
                if (data) {
                    resultObj = [NSJSONSerialization JSONObjectWithData:data
                                                                options:kNilOptions//返回不可变对象
                                                                  error:&jsonError];
                    if (jsonError) {
                        ll_log(@"网络请求成功，数据解析失败：%@",jsonError);
                    }
                }
                else {
                    ll_log(@"请求数据失败：%@",error);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    callBack(resultObj,error);
                });
            }
        }
    }];
    [task resume];
    return task;
}

//处理请求头等
- (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request {
    
    return [request copy];
}

///参数解析
- (NSString *)ll_parameters:(id)parameters {
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)parameters;
        if (dic.allKeys.count) {
            NSString *result = nil;
            for (NSString *key in dic.allKeys) {
                id value = [dic objectForKey:key];
                if (result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@",key,[self ll_parameters:value]];
                }
                else {
                    result = [NSString stringWithFormat:@"%@&%@=%@",result,key,[self ll_parameters:value]];
                }
            }
            return result;
        }
    }
    else if ([parameters isKindOfClass:[NSString class]]) {
        return (NSString *)parameters;
    }
    else if ([parameters isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",parameters];
    }
    return @"";
}

@end
