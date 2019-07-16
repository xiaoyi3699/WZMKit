//
//  WZMAudioPlayer.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/4/16.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "WZMAudioPlayerItem.h"
#import "WZMMacro.h"

@interface WZMAudioPlayer ()<AVAudioPlayerDelegate>


@property (nonatomic, strong) AVPlayer  *audioPlayer; //音频播放器
@property (nonatomic, assign) CGFloat   playProgress; //播放进度
@property (nonatomic, assign) CGFloat   loadProgress; //缓冲进度
@property (nonatomic, assign) CGFloat   duration;     //音频总时长
@property (nonatomic, assign) NSInteger currentTime;  //当前播放时间
@property (nonatomic, assign) NSInteger totalTime;    //播放总时长
@property (nonatomic, assign) id playTimeObserver;
@property (nonatomic, assign) UIBackgroundTaskIdentifier bgTaskId;


@end

@implementation WZMAudioPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        //监听音频播放结束
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        //监听程序退到后台
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)name:UIApplicationWillResignActiveNotification object:nil];
        
        //监听音频播放中断
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieInterruption:) name:AVAudioSessionInterruptionNotification object:nil];
        
        //设置并激活后台播放
        AVAudioSession *session=[AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        
        //允许应用程序接收远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        
        [self resetConfig];
    }
    return self;
}

- (void)resetConfig {
    self.duration = 0;
    self.totalTime = 0;
    self.currentTime = 0;
    self.playProgress = 0;
    self.loadProgress = 0;
}

//url：文件路径或文件网络地址
- (void)playWithURL:(NSURL *)fileURL {
    //加载视频资源的类
    AVURLAsset *asset = [AVURLAsset assetWithURL:fileURL];
    //AVURLAsset 通过tracks关键字会将资源异步加载在程序的一个临时内存缓冲区中
    [asset loadValuesAsynchronouslyForKeys:[NSArray arrayWithObject:@"tracks"] completionHandler:^{
        //能够得到资源被加载的状态
        NSError *error;
        AVKeyValueStatus status = [asset statusOfValueForKey:@"tracks" error:&error];
        //如果资源加载完成,开始进行播放
        if (status == AVKeyValueStatusLoaded) {
            //将加载好的资源放入AVPlayerItem 中，item中包含视频资源数据,视频资源时长、当前播放的时间点等信息
            WZMAudioPlayerItem *item = [WZMAudioPlayerItem playerItemWithAsset:asset];
            item.observer = self;
            
            //观察播放状态
            [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            
            //观察缓冲进度
            [item addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
            
            if (_audioPlayer) {
                [_audioPlayer removeTimeObserver:_playTimeObserver];
                [_audioPlayer replaceCurrentItemWithPlayerItem:item];
            }
            else {
                _audioPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
            }
            [self resetConfig];
            //需要时时显示播放的进度
            //根据播放的帧数、速率，进行时间的异步(在子线程中完成)获取
            
            @wzm_weakify(self);
            _playTimeObserver = [_audioPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
                @wzm_strongify(self);
                //获取当前播放时间
                self.currentTime = CMTimeGetSeconds(self.audioPlayer.currentItem.currentTime);
                float pro = self.currentTime/self.duration;
                if (pro >= 0.0 && pro <= 1.0) {
                    self.playProgress = pro;
                }
                [self wzm_playing];
            }];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self loadFailed:@"未识别的音频文件"];
            });
        }
    }];
}

//监听播放开始
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (item.status == AVPlayerStatusReadyToPlay) {
            //将要开始播放
            if (self.currentTime == 0) {
                [self wzm_loadSuccess];
                [self wzm_beginPlaying];
            }
            //获取当前播放时间
            self.currentTime = CMTimeGetSeconds(item.currentTime);
            //总时间
            self.duration = CMTimeGetSeconds(item.duration);
            float pro = self.currentTime*1.0/self.duration;
            if (pro >= 0.0 && pro <= 1.0) {
                self.playProgress  = pro;
            }
            [self play];
        }
        else if (item.status == AVPlayerStatusFailed) {
            [self loadFailed:@"未识别的音频文件"];
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDuration];
        float pro = timeInterval/self.duration;
        if (pro >= 0.0 && pro <= 1.0) {
            self.loadProgress = pro;
            [self wzm_loadProgress];
        }
    }
}

//锁屏界面的用户交互
- (void)remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        if (receivedEvent.subtype == UIEventSubtypeRemoteControlPlay) {//播放
            [self play];
        }
        else if (receivedEvent.subtype == UIEventSubtypeRemoteControlPause) {//暂停
            [self pause];
        }
    }
}

//监听程序退到后台
- (void)applicationWillResignActive:(NSNotification *)notification {
    if (self.isBackground) {
        //注册后台播放,如果需要后台播放网络歌曲，必须注册taskId
        _bgTaskId = [self backgroundPlayerID:_bgTaskId];
        [self play];
    }
    else {
        [self pause];
    }
}

//监听音频播放中断
- (void)movieInterruption:(NSNotification *)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger interuptionType = [[interuptionDict valueForKey:AVAudioSessionInterruptionTypeKey] integerValue];
    NSNumber  *seccondReason  = [[notification userInfo] objectForKey:AVAudioSessionInterruptionOptionKey] ;
    switch (interuptionType) {
        case AVAudioSessionInterruptionTypeBegan: {
            //收到中断，停止音频播放
            [self pause];
            break;
        }
        case AVAudioSessionInterruptionTypeEnded:
            //系统中断结束
            break;
    }
    switch ([seccondReason integerValue]) {
        case AVAudioSessionInterruptionOptionShouldResume:
            //恢复音频播放
            [self play];
            break;
        default:
            break;
    }
}

//监听音频播放完成
- (void)moviePlayDidEnd:(NSNotification *)notification {
    [self wzm_endPlaying];
}

#pragma mark - private method
//播放状态
- (void)wzm_loadSuccess {
    if ([self.delegate respondsToSelector:@selector(audioPlayerLoadSuccess:)]) {
        [self.delegate audioPlayerLoadSuccess:self];
    }
}

- (void)loadFailed:(NSString *)error {
    if ([self.delegate respondsToSelector:@selector(audioPlayerLoadFailed:error:)]) {
        [self.delegate audioPlayerLoadFailed:self error:error];
    }
}

- (void)wzm_loadProgress {
    if ([self.delegate respondsToSelector:@selector(audioPlayerLoadProgress:)]) {
        [self.delegate audioPlayerLoadProgress:self];
    }
}

- (void)wzm_beginPlaying {
    if ([self.delegate respondsToSelector:@selector(audioPlayerBeginPlaying:)]) {
        [self.delegate audioPlayerBeginPlaying:self];
    }
}

- (void)wzm_playing {
    if ([self.delegate respondsToSelector:@selector(audioPlayerPlaying:)]) {
        [self.delegate audioPlayerPlaying:self];
    }
}

- (void)wzm_endPlaying {
    if ([self.delegate respondsToSelector:@selector(audioPlayerEndPlaying:)]) {
        [self.delegate audioPlayerEndPlaying:self];
    }
}

- (void)wzm_changeStatus {
    if ([self.delegate respondsToSelector:@selector(audioPlayerChangeStatus:)]) {
        [self.delegate audioPlayerChangeStatus:self];
    }
}

- (CGFloat)availableDuration {//计算缓冲时间
    NSArray *loadedTimeRanges = [_audioPlayer.currentItem loadedTimeRanges];
    CMTimeRange range = [loadedTimeRanges.firstObject CMTimeRangeValue];
    CGFloat start = CMTimeGetSeconds(range.start);
    CGFloat duration = CMTimeGetSeconds(range.duration);
    return (start + duration);
}

- (void)play {
    if (_audioPlayer) {
        self.playing = YES;
        [_audioPlayer play];
        [self wzm_changeStatus];
    }
}

- (void)pause {
    if (_audioPlayer) {
        self.playing = NO;
        [_audioPlayer pause];
        [self wzm_changeStatus];
    }
}

//注册taskId
- (UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId {
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId=UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

- (void)setUrl:(NSString *)url {
    if (url == nil) {
        [self loadFailed:@"url不能为空"];
    }
    else {
        _url = url;
        [self pause];
        NSURL *webUrl = [NSURL URLWithString:url];
        if (webUrl) {
            if ([[UIApplication sharedApplication] canOpenURL:webUrl]) {
                [self playWithURL:webUrl];
            }
        }
        else {
            if ([[NSFileManager defaultManager] fileExistsAtPath:url]) {
                [self playWithURL:[NSURL fileURLWithPath:url]];
            }
        }
    }
}

- (void)setCurrentTime:(NSInteger)currentTime {
    if (_currentTime == currentTime || currentTime > self.duration) return;
    _currentTime = currentTime;
    CMTime dur = self.audioPlayer.currentItem.duration;
    [self.audioPlayer seekToTime:CMTimeMultiplyByFloat64(dur, _currentTime)];
}

//移除相关监听
- (void)dealloc {
    NSLog(@"音乐播放器释放");
    [_audioPlayer removeTimeObserver:_playTimeObserver];
    [_audioPlayer.currentItem removeObserver:self forKeyPath:@"status"];
    [_audioPlayer.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
