//
//  LLAVPlayerItem.m
//  LLplayer
//
//  Created by WangZhaomeng on 2017/4/18.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMPlayerItem.h"
#import "WZMLogPrinter.h"

NSString *const WZMPlayerStatus = @"status";
NSString *const WZMPlayerLoadedTimeRanges = @"loadedTimeRanges";
NSString *const WZMPlayerPlaybackBufferEmpty = @"playbackBufferEmpty";
NSString *const WZMPlayerPlaybackLikelyToKeepUp = @"playbackLikelyToKeepUp";

@interface WZMPlayerItem ()

@property (nonatomic, weak) id observer;
@property (nonatomic, assign) BOOL addObserver;

@end

@implementation WZMPlayerItem

//实现kvo自动释放
- (void)dealloc {
    [self removeItemObserver];
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

- (void)addItemObserver:(id)observer {
    //移除旧的监听
    [self removeItemObserver];
    //设置监听者
    self.observer = observer;
    //添加新的监听
    [self addItemObserver];
}

- (void)addItemObserver {
    if (self.observer == nil) return;
    if (self.addObserver) return;
    self.addObserver = YES;
    //观察播放状态
    [self addObserver:self.observer forKeyPath:WZMPlayerStatus options:NSKeyValueObservingOptionNew context:nil];
    //观察缓冲进度
    [self addObserver:self.observer forKeyPath:WZMPlayerLoadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
    //缓冲区空了，需要等待数据
    [self addObserver:self.observer forKeyPath:WZMPlayerPlaybackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
    // 缓冲区有足够数据可以播放了
    [self addObserver:self.observer forKeyPath:WZMPlayerPlaybackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeItemObserver {
    if (self.observer == nil) return;
    if (self.addObserver == NO) return;
    self.addObserver = NO;
    [self removeObserver:self.observer forKeyPath:WZMPlayerStatus];
    [self removeObserver:self.observer forKeyPath:WZMPlayerLoadedTimeRanges];
    [self removeObserver:self.observer forKeyPath:WZMPlayerPlaybackBufferEmpty];
    [self removeObserver:self.observer forKeyPath:WZMPlayerPlaybackLikelyToKeepUp];
}

@end
