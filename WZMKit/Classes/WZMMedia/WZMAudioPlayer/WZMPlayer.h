//
//  WZMPlayer.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZMPlayerView.h"
@protocol WZMPlayerDelegate;

@interface WZMPlayer : NSObject

@property (nonatomic, readonly, assign) CGFloat   playProgress; //播放进度
@property (nonatomic, readonly, assign) CGFloat   loadProgress; //缓冲进度
@property (nonatomic, readonly, assign) NSInteger duration;     //音频总时长
@property (nonatomic, readonly, assign) NSInteger currentTime;  //当前播放时间

@property (nonatomic, assign, getter=isPlaying) BOOL playing;
@property (nonatomic, assign, getter=isBackground) BOOL background;
@property (nonatomic, weak) id<WZMPlayerDelegate> delegate;
@property (nonatomic, strong) WZMPlayerView *playerView;

- (void)playWithURL:(NSURL *)url;
- (void)play;
- (void)pause;
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
