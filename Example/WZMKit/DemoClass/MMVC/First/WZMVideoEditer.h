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
///渲染尺寸,当代理函数videoEditerDidLoad被调用后被赋值
@property (nonatomic, assign, readonly) CGSize renderSize;

#pragma mark - 配音
///音量
@property (nonatomic, assign) CGFloat volume2;
///配音时长不足时,是否循环播放
@property (nonatomic, assign, getter=isLoop2) BOOL loop2;

#pragma mark - other
///输出的视频的渲染尺寸(即导出视频的分辨率),默认跟随原视频
@property (nonatomic, assign) CGSize exportRenderSize;
///输出视频的类型,默认AVFileTypeMPEG4
@property (nonatomic, strong) AVFileType exportFileType;
///输出进度
@property (nonatomic, assign, readonly) CGFloat progress;
///输出路径,默认temp文件夹
@property (nonatomic, strong, readonly) NSString *exportPath;
///other
@property (nonatomic, weak) id<WZMVideoEditerDelegate> delegate;
@property (nonatomic, assign, readonly ,getter=isExporting) BOOL exporting;

#pragma mark - 视频处理
///视频时长、尺寸剪裁
- (void)handleVideoWithPath:(NSString *)path;
///视频时长、尺寸剪裁，并添加配音
- (void)handleVideoWithPath:(NSString *)path otherPath:(NSString *)path2;

@end

@protocol WZMVideoEditerDelegate <NSObject>

@optional
- (void)videoEditerDidLoad:(WZMVideoEditer *)videoEditer;
- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer;
- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer;
- (void)videoEditer:(WZMVideoEditer *)videoEditer renderLayerWithComposition:(AVMutableVideoComposition *)composition;

@end
