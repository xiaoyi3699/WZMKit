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
@property (nonatomic, readonly, assign) CGFloat   playProgress;
///缓冲进度
@property (nonatomic, readonly, assign) CGFloat   loadProgress;
///音频总时长
@property (nonatomic, readonly, assign) NSInteger duration;
///当前播放时间
@property (nonatomic, readonly, assign) NSInteger currentTime;
///播放状态
@property (nonatomic, assign, getter=isPlaying) BOOL playing;
///是否允许后台播放, 默认NO, 后台播放需要应用简单配置
@property (nonatomic, assign, getter=isBackground) BOOL background;
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
- (void)playerLoadSuccess:(WZMPlayer *)player;
- (void)playerLoadFailed:(WZMPlayer *)player error:(NSString *)error;
- (void)playerLoadProgress:(WZMPlayer *)player;
- (void)playerBeginPlaying:(WZMPlayer *)player;
- (void)playerPlaying:(WZMPlayer *)player;
- (void)playerEndPlaying:(WZMPlayer *)player;
- (void)playerChangeStatus:(WZMPlayer *)player;

@end
