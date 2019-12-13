//
//  WZMVideoEditView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMCaptionModel.h"
@protocol WZMVideoEditViewDelegate;

@interface WZMVideoEditView : UIView

///视频路径
@property (nonatomic, strong) NSURL *videoUrl;
///视频渲染frame,添加水印、文字等均以此frame为准
@property (nonatomic, readonly ,assign) CGRect videoFrame;
///字幕
@property (nonatomic, strong) NSArray<WZMCaptionModel *> *noteModels;
///是否正在导出
@property (nonatomic, readonly, assign) BOOL exporting;
///代理
@property (nonatomic, weak) id<WZMVideoEditViewDelegate> delegate;

///初始化
- (instancetype)initWithFrame:(CGRect)frame;

- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToTime:(NSInteger)time;
- (void)seekToProgress:(CGFloat)progress;
///拖动进度结束,根据字幕调整当前播放进度
- (void)checkPlayIfAdjustCaption;
///查询当前正在编辑的字幕
- (WZMCaptionModel *)checkHasEditingModel;

///导出视频
- (void)exportVideoWithNoteAnimationCompletion:(void(^)(NSURL *exportURL))completion;

@end

@protocol WZMVideoEditViewDelegate <NSObject>

@optional
///加载成功
- (void)playerLoadSuccess:(WZMPlayer *)player;
///加载失败
- (void)playerLoadFailed:(WZMPlayer *)player error:(NSString *)error;
///缓冲进度
- (void)playerLoadProgress:(WZMPlayer *)player;
///开始播放
- (void)playerBeginPlaying:(WZMPlayer *)player;
///正在播放, 多次调用
- (void)playerPlaying:(WZMPlayer *)player;
///结束播放
- (void)playerEndPlaying:(WZMPlayer *)player;
///播放状态改变
- (void)playerChangeStatus:(WZMPlayer *)player;

@end
