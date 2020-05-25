//
//  WZMNetWorking.m
//  WZMFoundation
//
//  Created by zhaomengWang on 17/3/23.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMNetWorking.h"
#import "WZMLogPrinter.h"
#import "NSString+wzmcate.h"
#import "NSURLRequest+wzmcate.h"

NSString * const WZMNetRequestContentTypeForm = @"application/x-www-form-urlencoded";
NSString * const WZMNetRequestContentTypeJson = @"application/json;charset=utf-8";

@interface WZMNetWorking ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSSet *HTTPMethodsEncodingParametersInURI;

@end

#define WZMEncode(_str_) [_str_ dataUsingEncoding:NSUTF8StringEncoding]
@implementation WZMNetWorking

+ (instancetype)shareNetWorking {
    static WZMNetWorking *netWorking;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        netWorking = [[WZMNetWorking alloc] init];
    });
    return netWorking;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestContentType = WZMNetRequestContentTypeForm;
        self.resultContentType = WZMNetResultContentTypeJson;
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
        URL = [NSURL URLWithString:[url wzm_getURLEncoded]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    request.HTTPMethod = method;
    
    if (parameters) {
        NSString *params = [self parameters:parameters];
        if ([self.HTTPMethodsEncodingParametersInURI containsObject:[method uppercaseString]]) {
            NSString *formattUrl = [url stringByAppendingFormat:request.URL.query ? @"&%@" : @"?%@", params];
            NSURL *formattURL = [NSURL URLWithString:formattUrl];
            if (formattURL == nil) {
                formattURL = [NSURL URLWithString:[formattUrl wzm_getURLEncoded]];
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
        //            WZMLog(@"%ld",(long)httpResponse.statusCode);
        //        }
        if (callBack) {
            if (self.resultContentType == WZMNetResultContentTypeData) {
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
                        WZMLog(@"网络请求成功，数据解析失败：%@",jsonError);
                    }
                }
                else {
                    WZMLog(@"请求数据失败：%@",error);
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultObj) {
                        callBack(resultObj,error);
                    }
                    else {
                        callBack(data,error);
                    }
                });
            }
        }
    }];
    [task resume];
    return task;
}

//处理请求头等
- (NSURLRequest *)handlingRequest:(NSMutableURLRequest *)request {
    return [request wzm_handlingRequest];
}

///参数解析
- (NSString *)parameters:(id)parameters {
    if ([parameters isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)parameters;
        if (dic.allKeys.count) {
            NSString *result = nil;
            for (NSString *key in dic.allKeys) {
                id value = [dic objectForKey:key];
                if (result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@",key,[self parameters:value]];
                }
                else {
                    result = [NSString stringWithFormat:@"%@&%@=%@",result,key,[self parameters:value]];
                }
            }
            return result;
        }
    }
    else if ([parameters isKindOfClass:[NSString class]]) {
        return [(NSString *)parameters wzm_getURLEncoded2];
    }
    else if ([parameters isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",parameters];
    }
    return @"";
}

/**
 文件流格式上传
 
 @param url      上传地址
 @param key      对应字段名
 @param filename 文件名称
 @param mimeType 文件类型 如:@"image/jpeg"
 @param data     要上传的文件
 @param params   其他参数
 */
- (void)uploadUrl:(NSString *)url
              key:(NSString *)key
         filename:(NSString *)filename
         mimeType:(NSString *)mimeType
             data:(NSData *)data
           parmas:(NSDictionary *)params
         callBack:(void(^)(id responseObject,NSError *error))callBack {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod =@"POST";
    //设置请求体
    NSMutableData *body = [NSMutableData data];
    /***************文件参数***************/
    // 参数开始的标志
    [body appendData:WZMEncode(@"--WZM\r\n")];
    //key: 参数名,必须跟服务器端保持一致
    //filename: 文件名
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",key,filename];
    [body appendData:WZMEncode(disposition)];
    NSString *type = [NSString stringWithFormat:@"Content-Type: %@\r\n", mimeType];
    [body appendData:WZMEncode(type)];
    [body appendData:WZMEncode(@"\r\n")];
    [body appendData:data];
    [body appendData:WZMEncode(@"\r\n")];
    /***************普通参数***************/
    [params enumerateKeysAndObjectsUsingBlock:^(id key,id obj, BOOL *stop) {
        //参数开始的标志
        [body appendData:WZMEncode(@"--WZM\r\n")];
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [body appendData:WZMEncode(disposition)];
        [body appendData:WZMEncode(@"\r\n")];
        [body appendData:WZMEncode(obj)];
        [body appendData:WZMEncode(@"\r\n")];
    }];
    [body appendData:WZMEncode(@"--WZM--\r\n")];
    /***************参数结束***************/
    request.HTTPBody = body;
    //请求体的长度
    [request setValue:[NSString stringWithFormat:@"%zd", body.length] forHTTPHeaderField:@"Content-Length"];
    //声明这个POST请求是个文件上传
    [request setValue:@"multipart/form-data; boundary=WZM" forHTTPHeaderField:@"Content-Type"];
    [self request:[self handlingRequest:request] callBack:callBack];
}

@end
