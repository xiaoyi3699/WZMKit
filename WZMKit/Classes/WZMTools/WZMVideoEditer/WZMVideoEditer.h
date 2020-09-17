//
//  WZMVideoEditer.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/8/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@protocol WZMVideoEditerDelegate;
@protocol WZMVideoEditerDataSource;

@interface WZMVideoEditer : NSObject

#pragma mark - 原视频
///音量
@property (nonatomic, assign) CGFloat volume;
///开始,秒
@property (nonatomic, assign) CGFloat start;
///时长,秒
@property (nonatomic, assign) CGFloat duration;
///剪裁区域,相对于渲染尺寸
@property (nonatomic, assign) CGRect cropFrame;

#pragma mark - 配音
///音量
@property (nonatomic, assign) CGFloat volume2;
///配音时长不足时,是否循环播放
@property (nonatomic, assign, getter=isLoop2) BOOL loop2;

#pragma mark - other
///原视频尺寸,只在DataSource中使用,当视频被剪裁时,用来标记原视频size
@property (nonatomic, assign, readonly) CGSize renderSize;
///输出的视频的渲染尺寸(即导出视频的分辨率),默认跟随原视频
@property (nonatomic, assign) CGSize exportRenderSize;
///输出视频的类型,默认AVFileTypeMPEG4
@property (nonatomic, strong) AVFileType exportFileType;
///输出进度
@property (nonatomic, assign, readonly) CGFloat progress;
///输出路径,默认temp文件夹
@property (nonatomic, strong, readonly) NSString *exportPath;
///导出状态标记
@property (nonatomic, assign, readonly ,getter=isExporting) BOOL exporting;
///代理
@property (nonatomic, weak) id<WZMVideoEditerDelegate> delegate;
@property (nonatomic, weak) id<WZMVideoEditerDataSource> dataSource;

#pragma mark - 视频处理
///视频时长、尺寸剪裁
- (void)handleVideoWithPath:(NSString *)path;
///视频时长、尺寸剪裁，并添加配音
- (void)handleVideoWithPath:(NSString *)path otherPath:(NSString *)path2;

@end

@protocol WZMVideoEditerDelegate <NSObject>
@optional
///视频导出中,进度 = videoEditer.progress
- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer;
///视频导出结束,videoEditer.exportPath不为空,则成功,反之失败
- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer;
@end

@protocol WZMVideoEditerDataSource <NSObject>
@optional
///对视频进行绘制,比如添加文字、贴纸、画笔等
- (void)videoEditer:(WZMVideoEditer *)videoEditer renderLayerWithComposition:(AVMutableVideoComposition *)composition;
@end
