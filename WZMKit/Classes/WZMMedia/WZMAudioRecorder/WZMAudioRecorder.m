//
//  WZMAudioRecorder.m
//  WZMKit
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMAudioRecorder.h"
#import "WZMLogPrinter.h"
#import <AVFoundation/AVFoundation.h>

@interface WZMAudioRecorder ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSDictionary *setting;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@end

@implementation WZMAudioRecorder

- (void)setToPath:(NSString *)toPath {
    if (toPath.length == 0) return;
    if ([toPath isEqualToString:@"0"]) {
        _toPath = [NSTemporaryDirectory() stringByAppendingString:[self fileName]];
    }
    else {
        if ([_toPath isEqualToString:toPath]) return;
        _toPath = toPath;
    }
    NSURL *url = [NSURL fileURLWithPath:_toPath];
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.setting error:nil];
    self.audioRecorder.delegate = self;
    //开启音量检测
    self.audioRecorder.meteringEnabled = YES;
}

///开始录音
- (void)startRecord{
    if ([self.audioRecorder isRecording]) return;
    if (self.audioSession == nil) {
        self.audioSession = [AVAudioSession sharedInstance];
    }
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [self.audioSession setActive:YES error:nil];
    
    [self.audioRecorder prepareToRecord];
    [self.audioRecorder record];
    [self timerFire];
}

///结束录音
- (void)stopRecord:(void(^)(NSString *toPath,NSInteger time))completion{
    if ([self.audioRecorder isRecording] == NO) return;
    NSTimeInterval time = self.audioRecorder.currentTime;
    [self.audioRecorder stop];
    [_audioSession setActive:NO error:nil];
    if (completion) {
        completion(self.toPath,time);
    }
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self timerInvalidate];
    self.audioRecorder = nil;
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError * __nullable)error {
    [self timerInvalidate];
    self.audioRecorder = nil;
}

- (NSDictionary *)setting {
    if (_setting == nil) {
        //录音设置
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000(影响音频的质量),采样率必须要设为11025才能使转化成mp3格式后不会失真
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数  8、16、24、32
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        //录音的质量
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        _setting = [recordSetting copy];
    }
    return _setting;
}

- (void)timerFire {
    if ([self.delegate respondsToSelector:@selector(audioRecorderr:didChangeVolume:)]) {
        if (self.timer == nil) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(timerRun) userInfo:nil repeats:YES];
            [self.timer fire];
        }
    }
}

- (void)timerInvalidate {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timerRun {
    if (self.audioRecorder.recording) {
        [self.audioRecorder updateMeters];
        //获取通道0的平均音量，声音不大的情况下avg是个负数，没有启动MIC是-160
        CGFloat avg = [self.audioRecorder averagePowerForChannel:0];
        ///获取通道0的峰值音量，声音不大的情况下avg是个负数，没有启动MIC是-160
        //CGFloat max = [self.audioRecorder peakPowerForChannel:0];
        [self.delegate audioRecorderr:self didChangeVolume:(avg+160)/160.0];
    }
}

//获取当前时间戳
- (NSString *)fileName {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSInteger time = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%@.caf",@(time)];
}

@end
