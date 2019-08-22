//
//  LLAVLameManager.m
//  LLFileManager
//
//  Created by wangzhaomeng on 16/8/25.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLAVLameManager.h"
#import <AVFoundation/AVFoundation.h>
#import "lame.h"

@interface LLAVLameManager ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) NSString *recordFilePath;       //录音存储路径
@property (nonatomic, strong) NSString *mp3FilePath;          //转码后的存储路径
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) AVAudioSession *audioSession;
@property (nonatomic, strong) NSString *fileName;

@end

@implementation LLAVLameManager

/**
 *  初始化录音设置
 *
 *  @param fileName 为录音命名(不用加后缀)
 *
 *  @return id
 */
- (id)initWithFileName:(NSString *)fileName{
    self = [super init];
    if (self) {
        _fileName = fileName;
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
        //存储录音文件
        NSString *tureFileName = [NSString stringWithFormat:@"%@.caf",fileName];
        _recordFilePath = [NSTemporaryDirectory() stringByAppendingString:tureFileName];
        NSURL *url = [NSURL fileURLWithPath:_recordFilePath];
        //初始化
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:nil];
        //开启音量检测
        _audioRecorder.meteringEnabled = YES;
        _audioRecorder.delegate = self;
    }
    return self;
}

/**
 *  开始录音
 */
- (BOOL)startRecord{
    if ([_audioRecorder isRecording]) {
        return NO;
    }
    _audioSession = [AVAudioSession sharedInstance];
    [_audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [_audioSession setActive:YES error:nil];
    
    [_audioRecorder prepareToRecord];
    [_audioRecorder peakPowerForChannel:0.0];
    return [_audioRecorder record];
}

/**
 *  结束录音，并将录音转码为mp3格式
 *
 *  @param completion 转码完成block
 */
- (void)stopRecord:(void(^)(NSString *fullPath,NSTimeInterval time,NSException *exception))completion{
    if ([_audioRecorder isRecording]) {
        NSTimeInterval time = _audioRecorder.currentTime;
        [_audioRecorder stop];                          //录音停止
        [_audioSession setActive:NO error:nil];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3",_fileName];
        _mp3FilePath = [NSTemporaryDirectory() stringByAppendingString:fileName];
        @try {
            size_t read;
            int write;
            FILE *pcm = fopen([_recordFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
            fseek(pcm, 4*1024, SEEK_CUR);                                       //skip file header
            FILE *mp3 = fopen([_mp3FilePath cStringUsingEncoding:1], "wb");     //output 输出生成的Mp3文件位置
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            lame_t lame = lame_init();
            //与setting设置成比例, 越小播放速度越慢
            lame_set_in_samplerate(lame, 11025.0);
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            do {
                read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            } while (read != 0);
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
        }
        @catch (NSException *exception) {
            if (completion) {
                completion(nil,0,exception);
            }
        }
        @finally {
            if (completion) {
            completion(_mp3FilePath,time,nil);
            }
        }
    }
}

+ (void)PCM:(NSString *)PCMPath toMP3:(NSString *)MP3Path completion:(void(^)(NSString *fullPath,NSException *exception))completion{
    @try {
        size_t read;
        int write;
        FILE *pcm = fopen([PCMPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                               //skip file header
        FILE *mp3 = fopen([MP3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, (int)read, mp3_buffer, MP3_SIZE);
            fwrite(mp3_buffer, write, 1, mp3);
        } while (read != 0);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        if (completion) {
            completion(nil,exception);
        }
    }
    @finally {
        if (completion) {
            completion(MP3Path,nil);
        }
    }
}

@end
