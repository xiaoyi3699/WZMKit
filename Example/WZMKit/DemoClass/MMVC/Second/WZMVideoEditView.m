//
//  WZMVideoEditView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoEditView.h"

@interface WZMVideoEditView ()

@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playView;
@property (nonatomic ,assign) CGRect videoFrame;
@property (nonatomic, strong) UIView *watermarkView;

@end

@implementation WZMVideoEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfig:self.bounds];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setConfig:CGRectZero];
    }
    return self;
}

- (void)setConfig:(CGRect)frame {
    self.renderSize = CGSizeZero;
    self.playView = [[WZMPlayerView alloc] initWithFrame:frame];
    self.playView.backgroundColor = [UIColor redColor];
    [self addSubview:self.playView];
    
    self.player = [[WZMPlayer alloc] init];
    self.player.playerView = self.playView;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (CGRectEqualToRect(self.frame, frame)) return;
    [self layoutPlayView];
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if ([_videoUrl.path isEqualToString:videoUrl.path]) return;
    _videoUrl = videoUrl;
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    self.renderSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
    [self layoutPlayView];
}

- (void)layoutPlayView {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
    if (CGSizeEqualToSize(self.renderSize, CGSizeZero)) return;
    CGSize playViewSize = WZMSizeRatioToMaxSize(self.renderSize, self.bounds.size);
    CGRect playViewRect;
    playViewRect.origin.x = (self.bounds.size.width-playViewSize.width)/2;
    playViewRect.origin.y = (self.bounds.size.height-playViewSize.height)/2;
    playViewRect.size = playViewSize;
    self.playView.frame = playViewRect;
    self.videoFrame = playViewRect;
    
    if (self.videoUrl && self.player.isPlaying == NO) {
        [self.player playWithURL:self.videoUrl];
    }
}

- (void)addWatermark:(UIView *)markView {
    self.watermarkView = markView;
    [self.playView addSubview:self.watermarkView];
}

- (void)exportVideoCompletion:(void(^)(NSURL *exportURL))completion {
    if (self.watermarkView == nil) return;
    UIImage *image = [UIImage wzm_getScreenImageByView:self.watermarkView];
    [self addWatermark:self.videoUrl frame:self.watermarkView.frame image:image completion:completion];
}

#pragma mark -- 添加简单的水印
- (void)addWatermark:(NSURL *)videoUrl frame:(CGRect)frame image:(UIImage *)image completion:(void(^)(NSURL *exportURL))completion {
    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
    AVAsset *videoAsset = [AVAsset assetWithURL:videoUrl];
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];

    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //把视频轨道数据加入到可变轨道中
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:videoAssetTrack
                         atTime:kCMTimeZero error:nil];

    AVMutableCompositionTrack *aduioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *aduioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    [aduioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:aduioAssetTrack atTime:kCMTimeZero error:nil];
    //矫正视频角度
    AVMutableVideoComposition *mainCompositionInst = [self videoCompositionVideoTrack:videoTrack videoAssetTrack:videoAssetTrack];
    //简单的水印
    [self composition:mainCompositionInst frame:frame image:image size:mainCompositionInst.renderSize];
    
    [self videoExportComosition:mixComposition videoComposition:mainCompositionInst quality:AVAssetExportPresetHighestQuality completion:completion];
}

//添加水印
- (void)composition:(AVMutableVideoComposition *)composition frame:(CGRect)frame image:(UIImage *)image size:(CGSize)size {
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, size.width, size.height);
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [parentLayer addSublayer:videoLayer];
    
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = CGRectMake(0, 0, size.width, size.height);
    [overlayLayer setMasksToBounds:YES];
    [parentLayer addSublayer:overlayLayer];
    
    //1、视频实际尺寸/当前显示尺寸,计算出视频的缩小比例或者放大倍数
    //2、左下角为原点,对水印图片坐标系进行转换
    CGFloat scale = size.width/self.videoFrame.size.width;
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.contents = (id)image.CGImage;
    imageLayer.frame = CGRectMake(frame.origin.x*scale, (self.videoFrame.size.height-(frame.origin.y+frame.size.height))*scale, frame.size.width*scale, frame.size.height*scale);
    [overlayLayer addSublayer:imageLayer];
    
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

//视频导出
- (void)videoExportComosition:(AVMutableComposition *)comosition videoComposition:(AVMutableVideoComposition *)mainCompositionInst quality:(NSString *)quality completion:(void(^)(NSURL *exportURL))completion {
    //合成之后的输出路径
    NSString *outPutPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"HYVideo-%d.mov",arc4random()%1000]];
    //混合后的视频输出路径
    NSURL *outPutUrl = [NSURL fileURLWithPath:outPutPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outPutPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:outPutPath error:nil];
    }
    //创建输出
    AVAssetExportSession * assetExport = [[AVAssetExportSession alloc] initWithAsset:comosition presetName:quality];
    assetExport.outputURL = outPutUrl;//输出路径
    assetExport.outputFileType = AVFileTypeQuickTimeMovie;//输出类型
    assetExport.shouldOptimizeForNetworkUse = YES;//是否优化   不太明白
    if (mainCompositionInst) {
        assetExport.videoComposition = mainCompositionInst;
    }
    [assetExport exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (assetExport.status == AVAssetExportSessionStatusCompleted) {
                if (completion) completion(assetExport.outputURL);
            }
            else if (assetExport.status == AVAssetExportSessionStatusFailed){
                if (completion) completion(nil);
            }
        });
    }];
}

//矫正视频角度
- (AVMutableVideoComposition *)videoCompositionVideoTrack:(AVMutableCompositionTrack *)videoTrack videoAssetTrack:(AVAssetTrack *)videoAssetTrack {
    //3.1 - Create AVMutableVideoCompositionInstruction
    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAssetTrack.asset.duration);

    // 3.2 - Create an AVMutableVideoCompositionLayerInstruction for the video track and fix the orientation.
    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
    BOOL isVideoAssetPortrait_  = NO;
    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ = UIImageOrientationRight;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
        videoAssetOrientation_ =  UIImageOrientationLeft;
        isVideoAssetPortrait_ = YES;
    }
    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
        videoAssetOrientation_ =  UIImageOrientationUp;
    }
    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
        videoAssetOrientation_ = UIImageOrientationDown;
    }
    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
    [videolayerInstruction setOpacity:0.0 atTime:videoAssetTrack.asset.duration];

    // 3.3 - Add instructions
    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];

    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];

    CGSize naturalSize;
    if(isVideoAssetPortrait_){
        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    } else {
        naturalSize = videoAssetTrack.naturalSize;
    }
    float renderWidth, renderHeight;
    renderWidth = naturalSize.width;
    renderHeight = naturalSize.height;
    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);

    return mainCompositionInst;
}

@end
