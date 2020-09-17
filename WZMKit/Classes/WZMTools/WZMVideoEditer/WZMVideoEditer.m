//
//  WZMVideoEditer.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/8/24.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMVideoEditer.h"
#import "WZMEditerModel.h"
#import "WZMAssetExportSession.h"
#import "WZMLogPrinter.h"
#import "WZMAlbumHelper.h"
#import "WZMViewHandle.h"

@interface WZMVideoEditer ()<WZMAssetExportSessionDelegate>
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) NSString *exportPath;
@property (nonatomic, strong) AVAudioMix *audioMix;
@property (nonatomic, assign, getter=isExporting) BOOL exporting;
@property (nonatomic, strong) AVMutableComposition *mixComposition;
@end

@implementation WZMVideoEditer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.volume = 1.0;
        self.volume2 = 1.0;
        self.start = 0.0;
        self.duration = 0.0;
        self.exporting = NO;
        self.cropFrame = CGRectZero;
        self.exportFileType = AVFileTypeMPEG4;
        self.exportRenderSize = CGSizeZero;
    }
    return self;
}

#pragma mark - 视频处理
- (void)handleVideoWithPath:(NSString *)path {
    if (path == nil) return;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path] == NO) return;
    NSURL *url = [NSURL fileURLWithPath:path];
    [WZMViewHandle wzm_showProgressMessage:@"处理中..."];
    [WZMAlbumHelper wzm_fixVideoOrientation:url completion:^(NSURL *videoURL) {
        [WZMViewHandle wzm_dismiss];
        [self handleVideoWithPath:videoURL.path otherPath:nil];
    }];
}

- (void)handleVideoWithPath:(NSString *)path otherPath:(NSString *)path2 {
    if (self.isExporting) return;
    self.exporting = YES;
    //处理原视频
    WZMEditerModel *editer = [[WZMEditerModel alloc] initWithPath:path];
    if (editer.video == nil) {
        [self exportFinish:nil];
        return;
    }
    //起止时间
    CGFloat duration = CMTimeGetSeconds(editer.asset.duration);
    if (self.start < 0.0) {
        self.start = 0.0;
    }
    if (self.duration <= 0.0) {
        self.duration = duration-self.start;
    }
    if (self.duration <= 0.0) {
        self.start = 0.0;
        self.duration = duration;
    }
    self.start = ceil(self.start);
    self.duration = floor(self.duration);
    CMTime t1 = CMTimeMakeWithSeconds(self.start, 30);
    CMTime t2 = CMTimeMakeWithSeconds((self.start+self.duration), 30);
    CMTimeRange range = CMTimeRangeFromTimeToTime(t1, t2);
    
    //创建空白容器
    self.mixComposition = [[AVMutableComposition alloc] init];
    //向容器中新增视频轨道
    AVMutableCompositionTrack *videoTrack = [self addVideoTrack];
    //把原视频加入到视频轨道中
    [videoTrack insertTimeRange:range
                        ofTrack:editer.video
                         atTime:kCMTimeZero
                          error:nil];
    //判断原视频是否包含声音
    AVMutableCompositionTrack *audioTrack;
    if (editer.audio) {
        //向容器中新增音频轨道
        audioTrack = [self addAudioTrack];
        //把音频加入到音频轨道中
        [audioTrack insertTimeRange:range
                            ofTrack:editer.audio
                             atTime:kCMTimeZero
                              error:nil];
    }
    
    //处理配音
    AVMutableCompositionTrack *audioTrack2;
    WZMEditerModel *editer2 = [[WZMEditerModel alloc] initWithPath:path2];
    if (editer.audio) {
        //新增音频轨道-配音使用
        audioTrack2 = [self addAudioTrack];
        //计算时间
        NSMutableArray *times = [[NSMutableArray alloc] init];
        CGFloat time = self.duration;
        CGFloat oTime = CMTimeGetSeconds(editer2.asset.duration);
        if (oTime > time) {
            [times addObject:@(time)];
        }
        else {
            if (self.isLoop2) {
                CGFloat count = (time/oTime);
                for (NSInteger i = 1; i < count; i ++) {
                    [times addObject:@(oTime)];
                }
                NSInteger rTime = (NSInteger)(time-oTime*((NSInteger)count));
                if (rTime > 0.5) {
                    [times addObject:@(rTime)];
                }
            }
            else {
                [times addObject:@(oTime)];
            }
        }
        CGFloat totleTime = 0.0;
        for (NSNumber *timeNum in times) {
            CMTime atTime = CMTimeMakeWithSeconds(totleTime, 30.0);
            CMTime tTime = CMTimeMakeWithSeconds(timeNum.floatValue, 30.0);
            //把音频数据加入到可变轨道中
            [audioTrack2 insertTimeRange:CMTimeRangeMake(kCMTimeZero, tTime)
                                 ofTrack:editer2.audio
                                  atTime:atTime
                                   error:nil];
            totleTime += timeNum.floatValue;
        }
    }
    if ((audioTrack && self.volume < 1) || (audioTrack2 && self.volume2 < 1)) {
        //调节合成的音量
        self.audioMix = [self createAudioMixWithVideoTrack:audioTrack VideoVolume:self.volume BGMTrack:audioTrack2 BGMVolume:self.volume2];
    }
    //矫正视频角度、剪裁、设置透明度等操作
    CGAffineTransform transform = [self videoCompositionVideoAssetTrack:videoTrack];
    AVMutableVideoComposition *mainCompositionInst = [self videoCompositionVideoTrack:videoTrack videoAssetTrack:editer.video transform:transform];
    //添加视图动画等
    if ([self.delegate respondsToSelector:@selector(videoEditer:renderLayerWithComposition:)]) {
        [self.delegate videoEditer:self renderLayerWithComposition:mainCompositionInst];
    }
    //导出
    [self videoExportComosition:self.mixComposition videoComposition:mainCompositionInst quality:AVAssetExportPresetHighestQuality];
}

#pragma mark - 调节合成的音量
- (AVAudioMix *)createAudioMixWithVideoTrack:(AVCompositionTrack *)videoTrack VideoVolume:(float)videoVolume BGMTrack:(AVCompositionTrack *)BGMTrack BGMVolume:(float)BGMVolume {
    NSMutableArray *inputParameters = [[NSMutableArray alloc] init];
    //创建音频混合类
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    if (videoTrack) {
        //原音
        AVMutableAudioMixInputParameters *Videoparameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:videoTrack];
        [Videoparameters setVolume:videoVolume atTime:kCMTimeZero];
        [inputParameters addObject:Videoparameters];
    }
    if (BGMTrack) {
        //配音
        AVMutableAudioMixInputParameters *BGMparameters = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:BGMTrack];
        [BGMparameters setVolume:BGMVolume atTime:kCMTimeZero];
        [inputParameters addObject:BGMparameters];
    }
    audioMix.inputParameters = inputParameters;
    return audioMix;
}

//添加视图动画等
- (void)renderLayerWithComposition:(AVMutableVideoComposition *)composition {
    CGSize renderSize = composition.renderSize;
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    parentLayer.masksToBounds = YES;
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = parentLayer.bounds;
    [parentLayer addSublayer:videoLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

//剪裁视频的尺寸
- (CGAffineTransform)videoCompositionVideoAssetTrack:(AVAssetTrack *)videoAssetTrack {
    CGSize naturalSize = videoAssetTrack.naturalSize;
    CGFloat renderWidth, renderHeight;
    CGRect cropRect = self.cropFrame;
    CGAffineTransform transform;
    if (CGPointEqualToPoint(CGPointZero, cropRect.origin)) {
        transform = videoAssetTrack.preferredTransform;
    }
    else {
        CGPoint point = cropRect.origin;
        transform = CGAffineTransformMakeTranslation(-point.x, -point.y);
    }
    if (cropRect.size.width == 0 || cropRect.size.height == 0) {
        renderWidth = naturalSize.width;
        renderHeight = naturalSize.height;
    }
    else {
        CGSize size = cropRect.size;
        renderWidth = size.width;
        renderHeight = size.height;
    }
    //修改视频的渲染尺寸
    CGSize cropSize = CGSizeMake(renderWidth, renderHeight);
    CGFloat scaleX = 1.0, scaleY = 1.0;
    if (self.exportRenderSize.width != 0.0 && self.exportRenderSize.height != 0.0) {
        scaleX = self.exportRenderSize.width/cropSize.width;
        scaleY = self.exportRenderSize.height/cropSize.height;
        CGAffineTransform transform2 = CGAffineTransformMakeScale(scaleX, scaleY);
        transform = CGAffineTransformConcat(transform, transform2);
    }
    else {
        self.exportRenderSize = cropSize;
    }
    return transform;
}

//视频重新合成
- (AVMutableVideoComposition *)videoCompositionVideoTrack:(AVMutableCompositionTrack *)videoTrack videoAssetTrack:(AVAssetTrack *)videoAssetTrack transform:(CGAffineTransform)transform {
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack.asset.duration);
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [videolayerInstruction setTransform:transform atTime:kCMTimeZero];
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.renderSize = [self handleVideoSize:self.exportRenderSize];
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    return mainCompositionInst;
}

///视频导出
- (void)videoExportComosition:(AVMutableComposition *)comosition videoComposition:(AVMutableVideoComposition *)mainCompositionInst quality:(NSString *)quality {
    //合成之后的输出路径
    NSString *outPutPath = self.exportPath;
    if (outPutPath == nil || outPutPath.length == 0) {
        outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"WZMVideoEditer.mp4"]];
    }
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    //创建输出
    NSArray *presets = [AVAssetExportSession exportPresetsCompatibleWithAsset:comosition];
    if ([presets containsObject:quality]) {
        WZMAssetExportSession *assetExport = [[WZMAssetExportSession alloc] initWithAsset:comosition presetName:quality];
        assetExport.delegate = self;
        assetExport.outputURL = outPutUrl;//输出路径
        assetExport.outputFileType = self.exportFileType;//输出类型
        assetExport.shouldOptimizeForNetworkUse = YES;
        if (mainCompositionInst) {
            assetExport.videoComposition = mainCompositionInst;
        }
        if (self.audioMix) {
            assetExport.audioMix = self.audioMix;
        }
        [assetExport startExport];
    }
    else {
        NSString *des = [NSString stringWithFormat:@"当前设备不支持该预设:%@",quality];
        WZMLog(@"%@",des);
    }
}

//视频导出代理
- (void)assetExportSessionExporting:(WZMAssetExportSession *)exportSession {
    self.progress = exportSession.progress;
    if ([self.delegate respondsToSelector:@selector(videoEditerExporting:)]) {
        [self.delegate videoEditerExporting:self];
    }
}

- (void)assetExportSessionExportSuccess:(WZMAssetExportSession *)exportSession {
    [self exportFinish:exportSession.outputURL.path];
}

- (void)assetExportSessionExportFail:(WZMAssetExportSession *)exportSession {
    WZMLog(@"导出视频失败:%@",exportSession.error);
    [self exportFinish:nil];
}

- (void)exportFinish:(NSString *)path {
    self.exporting = NO;
    self.exportPath = path;
    if (self.completion) {
        self.completion(self);
    }
    else {
        if ([self.delegate respondsToSelector:@selector(videoEditerDidExported:)]) {
            [self.delegate videoEditerDidExported:self];
        }
    }
}

//private method
- (AVMutableCompositionTrack *)addVideoTrack {
    return [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                            preferredTrackID:kCMPersistentTrackID_Invalid];
}

- (AVMutableCompositionTrack *)addAudioTrack {
    return [self.mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                            preferredTrackID:kCMPersistentTrackID_Invalid];
}

///视频的宽高必须是16的倍数
- (CGSize)handleVideoSize:(CGSize)size {
    NSInteger w = size.width;
    NSInteger h = size.height;
    NSInteger dw = w%16;
    NSInteger dh = h%16;
    if (dw != 0) {
        w -= dw;
    }
    if (dh != 0) {
        h -= dh;
    }
    return CGSizeMake(w, h);
}

- (CGFloat)volume {
    if (_volume < 0.0) {
        _volume = 0.0;
    }
    else if (_volume > 1) {
        _volume = 1.0;
    }
    return _volume;
}

- (CGFloat)volume2 {
    if (_volume2 < 0.0) {
        _volume2 = 0.0;
    }
    else if (_volume2 > 1) {
        _volume2 = 1.0;
    }
    return _volume2;
}

- (void)dealloc
{
    NSLog(@"释放");
}

@end
