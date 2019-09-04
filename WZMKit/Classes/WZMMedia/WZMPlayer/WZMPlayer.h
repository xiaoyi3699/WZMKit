//
//  WZMPlayer.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//  音频/视频播放器

#import <Foundation/Foundation.h>
#import "WZMPlayerView.h"
@protocol WZMPlayerDelegate;

@interface WZMPlayer : NSObject

///播放进度
@property (nonatomic, readonly, assign) CGFloat playProgress;
///缓冲进度
@property (nonatomic, readonly, assign) CGFloat loadProgress;
///音频总时长
@property (nonatomic, readonly, assign) CGFloat duration;
///当前播放时间
@property (nonatomic, readonly, assign) CGFloat currentTime;
///播放状态
@property (nonatomic, assign, readonly, getter=isPlaying) BOOL playing;
///是否允许后台播放, 默认NO, 后台播放需要应用简单配置
@property (nonatomic, assign, getter=isBackground) BOOL background;
///强制设置当前播放器是否允许播放,默认YES,如非特殊情况,不建议使用
@property (nonatomic, assign, getter=isAllowPlay) BOOL allowPlay;
///是否根据主线程RunLoopMode改变播放状态,默认YES
@property (nonatomic, assign, getter=isTrackingRunLoop) BOOL trackingRunLoop;
///代理事件
@property (nonatomic, weak) id<WZMPlayerDelegate> delegate;
///播放音频时不用设置, 播放视频是需要设置视图
@property (nonatomic, strong) WZMPlayerView *playerView;

- (void)playWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
- (void)stop;
- (void)seekToTime:(NSInteger)time;
- (void)seekToProgress:(CGFloat)progress;

@end

@protocol WZMPlayerDelegate <NSObject>

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
