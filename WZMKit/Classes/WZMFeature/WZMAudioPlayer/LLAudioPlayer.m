//
//  LLAudioPlayer.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/8/25.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLAudioPlayer.h"
#import <MediaPlayer/MediaPlayer.h>

@interface LLAudioPlayer ()

@property (nonatomic, strong) AVAudioSession *audioSession;

@end

@implementation LLAudioPlayer

- (id)initWithContentsOfURL:(NSURL *)url error:(NSError * _Nullable __autoreleasing *)outError{
    self = [super initWithContentsOfURL:url error:outError];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (id)initWithData:(NSData *)data error:(NSError * _Nullable __autoreleasing *)outError{
    self = [super initWithData:data error:outError];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    //音量 0.0-1.0之间
    self.volume = 1.0;
    //循环次数 默认只播放一次
    self.numberOfLoops = 0;
    //播放位置 可以指定从任意位置开始播放
    self.currentTime = 0.0;
}

- (AVAudioSession *)audioSession {
    if (_audioSession == nil) {
        _audioSession = [AVAudioSession sharedInstance];
    }
    return _audioSession;
}

- (void)startPlay{//播放
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.audioSession setActive:YES error:nil];
    [self prepareToPlay];//分配播放所需的资源，并将其加入内部播放队列
    [self play];
}

- (void)pausePlay{//暂停
    [self pause];
    [self.audioSession setActive:NO error:nil];
}

- (void)stopPlay{//停止
    [self stop];
    [self.audioSession setActive:NO error:nil];
}

@end
