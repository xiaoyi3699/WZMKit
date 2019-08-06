//
//  WZMDownloader.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/28.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMDownloader.h"
#import "WZMLogPrinter.h"
#import "NSString+wzmcate.h"

@interface WZMDownloader ()<NSURLSessionDownloadDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSURLSessionDownloadTask *task;
@property (nonatomic, strong) NSData *resumeData;
@property (nonatomic, assign, getter=isDownloading) BOOL downloading;

@end

@implementation WZMDownloader

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        //监听程序进入前台
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//
//        //监听程序退到后台
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
//    }
//    return self;
//}

//开始
- (void)start {
    if (self.isDownloading) return;
    self.downloading = YES;
    if (self.resumeData.length) {
        self.task = [self.session downloadTaskWithResumeData:self.resumeData];
        [self.task resume];
    }
    else {
        if (_url.length == 0) {
            WZMLog(@"网址不能为空");
        }
        NSURL *URL = [NSURL URLWithString:_url];
        if (URL == nil) {
            URL = [NSURL URLWithString:[_url wzm_getURLEncoded]];
        }
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
            self.task = [self.session downloadTaskWithURL:URL];
            [self.task resume];
        }
        else {
            WZMLog(@"无效网址");
        }
    }
}

//暂停
- (void)pause:(void(^)(void))completion {
    if (self.isDownloading == NO) return;
    self.downloading = NO;
    __weak typeof(self) weakSelf = self;
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        weakSelf.resumeData = resumeData;
        if (completion) {
            completion();
        }
    }];
}

//停止
- (void)stop:(void(^)(void))completion {
    self.resumeData = nil;
    if (self.isDownloading == NO) return;
    self.downloading = NO;
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    if (self.isDownloading == NO) return;
    if ([self.delegate respondsToSelector:@selector(downloader:didWriteBytes:totalBytes:)]) {
        [self.delegate downloader:self didWriteBytes:totalBytesWritten totalBytes:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    self.downloading = NO;
    NSString *filePath;
    if (self.folderPath.length) {
        BOOL isDirectory;
        if ([[NSFileManager defaultManager] fileExistsAtPath:self.folderPath isDirectory:&isDirectory]) {
            if (isDirectory) {
                NSString *filePath2 = [self.folderPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
                //移动文件到指定路径
                if ([[NSFileManager defaultManager] moveItemAtPath:location.path toPath:filePath2 error:nil]) {
                    [[NSFileManager defaultManager] removeItemAtURL:location error:nil];
                    filePath = filePath2;
                }
            }
        }
    }
    if (filePath == nil) {
        filePath = location.path;
    }
    if ([self.delegate respondsToSelector:@selector(downloader:didFinish:)]) {
        [self.delegate downloader:self didFinish:filePath];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    
}

//通知监听
- (void)applicationDidBecomeActive:(NSNotification *)n {
    [self start];
}

- (void)applicationWillResignActive:(NSNotification *)n {
    [self pause:nil];
}

- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
