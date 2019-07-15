//
//  LLNetworkDownload.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/28.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLNetworkDownload.h"
#import "LLLog.h"
#import "LLMacro.h"
#import "NSString+LLAddPart.h"

@interface LLNetworkDownload ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;

@end

@implementation LLNetworkDownload

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

//开始
- (void)start {
    
    if (self.resumeData.length) {
        self.task = [self.session downloadTaskWithResumeData:self.resumeData];
        [self.task resume];
    }
    else {
        if (_url.length == 0) {
            ll_log(@"网址不能为空");
        }
        NSURL *URL = [NSURL URLWithString:_url];
        if (URL == nil) {
            URL = [NSURL URLWithString:[_url ll_getURLEncoded]];
        }
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            self.task = [self.session downloadTaskWithURL:URL];
            [self.task resume];
        }
        else {
            ll_log(@"无效网址");
        }
    }
}

//暂停
- (void)pause {
    __weak typeof(self) weakSelf = self;
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.resumeData = resumeData;
    }];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
    ll_log(@"%.2f",(double)totalBytesWritten/totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    ll_log(@"下载完成==%@",location.path);
    
    NSString *filePath = nil;
    if (_filePath.length) {
        filePath = [_filePath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    }
    else {
        filePath = [APP_DocumentPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    }
    
    //移动文件到指定路径
    if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath error:nil]) {
        [[NSFileManager defaultManager] removeItemAtURL:location error:nil];
    }
}

@end
