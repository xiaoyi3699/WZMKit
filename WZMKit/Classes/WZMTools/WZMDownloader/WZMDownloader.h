//
//  WZMDownloader.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/28.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WZMDownloaderDelegate;

@interface WZMDownloader : NSObject

///下载地址
@property (nonatomic, strong) NSString *url;
///下载后的文件保存的目录(必须是文件夹,可以不设置,默认保存在临时文件夹)
@property (nonatomic, strong) NSString *folderPath;
///是否正在下载
@property (nonatomic, assign, readonly, getter=isDownloading) BOOL downloading;
///代理
@property (nonatomic, weak) id<WZMDownloaderDelegate> delegate;
///开始
- (void)start;
///暂停
- (void)pause:(void(^)(void))completion;
///停止
- (void)stop:(void(^)(void))completion;

@end

@protocol WZMDownloaderDelegate <NSObject>

@optional
- (void)downloader:(WZMDownloader *)downloader didWriteBytes:(int64_t)didWriteBytes totalBytes:(int64_t)totalBytes;
- (void)downloader:(WZMDownloader *)downloader didFinish:(NSString *)path;

@end
