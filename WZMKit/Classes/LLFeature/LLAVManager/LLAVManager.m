//
//  LLAVManager.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/11/10.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLAVManager.h"
#import "LLLog.h"

@implementation LLAVManager

//震动
+ (void)shake{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//播放默认音效
+ (void)playDefaultSoundID:(SystemSoundID)soundID {
    if (soundID <= 0) {
        soundID = 1007;
    }
    AudioServicesPlaySystemSound(soundID);
}

//播放自定义音效
+ (void)playCustomSoundPath:(NSString *)path {
    //组装并播放音效
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    AudioServicesPlaySystemSound(soundID);
    //声音停止
    //AudioServicesDisposeSystemSoundID(soundID);
}

///提示音
+ (void)playStartSound {
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/begin_record.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

///提示音
+ (void)playEndSound {
    NSURL *url = [NSURL URLWithString:@"/System/Library/Audio/UISounds/end_record.caf"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

///mov格式转mp4格式
+ (void)movTransformToMP4WithPath:(NSString *)path outputPath:(NSString *)outputPath {
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
        exportSession.outputFileType = AVFileTypeMPEG4;
        exportSession.shouldOptimizeForNetworkUse = YES;
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void) {
            switch (exportSession.status) {
                case AVAssetExportSessionStatusUnknown:
                    ll_log(@"视频格式转换：Unknown");
                    break;
                case AVAssetExportSessionStatusWaiting:
                    ll_log(@"视频格式转换：Waiting");
                    break;
                case AVAssetExportSessionStatusExporting:
                    ll_log(@"视频格式转换：Exporting");
                    break;
                case AVAssetExportSessionStatusCompleted:
                    ll_log(@"文件大小:%lfM",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                    break;
                case AVAssetExportSessionStatusFailed:
                    ll_log(@"视频格式转换：Failed");
                    break;
                case AVAssetExportSessionStatusCancelled:
                    ll_log(@"视频格式转换：Cancelled");
                    break;
            }
        }];
    }
}

//视频剪辑
+ (void)clippingVideoWithPath:(NSString *)path outputPath:(NSString *)outputPath start:(Float64)start end:(Float64)end {
    //加载视频资源的类
    AVURLAsset *anAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:anAsset];
    
    NSString *quality = nil;
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        quality = AVAssetExportPresetHighestQuality;
    }
    else if ([compatiblePresets containsObject:AVAssetExportPresetMediumQuality]) {
        quality = AVAssetExportPresetMediumQuality;
    }
    else if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
        quality = AVAssetExportPresetLowQuality;
    }
    if (quality == nil) return;
    //输出文件质量
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:anAsset presetName:quality];
    
    //输出文件路径
    exportSession.outputURL = [NSURL fileURLWithPath:outputPath];
    exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    exportSession.shouldOptimizeForNetworkUse = YES;
    
    //起止时间
    CMTime t1 = CMTimeMakeWithSeconds(start, 600);
    CMTime t2 = CMTimeMakeWithSeconds(end, 600);
    CMTimeRange range = CMTimeRangeFromTimeToTime(t1, t2);
    exportSession.timeRange = range;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusFailed:
                ll_log(@"Export failed: %@", [[exportSession error] localizedDescription]);
                break;
            case AVAssetExportSessionStatusCancelled:
                ll_log(@"Export canceled");
                break;
            case AVAssetExportSessionStatusExporting:
                ll_log(@"Exporting");
                break;
            case AVAssetExportSessionStatusCompleted:
                ll_log(@"Export completed");
                break;
            default:
                break;
        }
    }];
}

//视频合成
+ (void)splicingVideoWithPaths:(NSArray<NSString *> *)paths outputPath:(NSString *)outputPath {
    NSMutableArray *assetArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            NSURL *fileURL = [NSURL fileURLWithPath:path];
            AVAsset *asset = [AVAsset assetWithURL:fileURL];
            if (asset == nil) {
                continue;
            }
            [assetArray addObject:asset];
        }
        else {
            ll_log(@"音频文件不存在");
        }
    }
    
    //合成
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    //合成--音频--轨道
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //合成--视频--轨道
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    CMTime totalDuration = kCMTimeZero;
    for (int i = 0; i < [assetArray count] ; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        
        //把第一段录制的--音频--插入到AVMutableCompositionTrack
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] firstObject]
                             atTime:totalDuration
                              error:nil];
        
        //把录制的第一段--视频--插入到AVMutableCompositionTrack
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeVideo] firstObject]
                             atTime:totalDuration
                              error:nil];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
    }
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.outputURL = [NSURL fileURLWithPath:outputPath];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        //如果转换成功
        if (exporter.status == AVAssetExportSessionStatusCompleted)
        {
            ll_log(@"合成成功");
        }
        else {
            ll_log(@"失败");
        }
    }];
}

@end
