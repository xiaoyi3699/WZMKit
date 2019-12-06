//
//  WZMVideoEditView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoEditView.h"
#import "FLLayerBuilderTool.h"
#import "WZMNoteAnimation.h"

@interface WZMVideoEditView ()<WZMPlayerDelegate>

@property (nonatomic ,assign) CGRect videoFrame;
@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playView;
///字幕配置
@property (nonatomic, strong) NSArray<WZMNoteModel *> *noteModels;

@end

@implementation WZMVideoEditView

- (instancetype)initWithFrame:(CGRect)frame noteModels:(NSArray<WZMNoteModel *> *)noteModels {
    self = [super initWithFrame:frame];
    if (self) {
        self.noteModels = noteModels;
        [self layoutWithFrame:self.bounds];
    }
    return self;
}

- (void)layoutWithFrame:(CGRect)frame {
    self.renderSize = CGSizeZero;
    self.playView = [[WZMPlayerView alloc] initWithFrame:frame];
    self.playView.backgroundColor = [UIColor redColor];
    [self addSubview:self.playView];
    
    self.player = [[WZMPlayer alloc] init];
    self.player.delegate = self;
    self.player.playerView = self.playView;
}

- (void)layoutPlayView {
    if (CGSizeEqualToSize(self.bounds.size, CGSizeZero)) return;
    if (CGSizeEqualToSize(self.renderSize, CGSizeZero)) return;
    CGSize playViewSize = WZMSizeRatioToMaxSize(self.renderSize, self.bounds.size);
    CGRect playViewRect = CGRectZero;
    playViewRect.origin.x = (self.bounds.size.width-playViewSize.width)/2;
    playViewRect.origin.y = (self.bounds.size.height-playViewSize.height)/2;
    playViewRect.size = playViewSize;
    self.playView.frame = playViewRect;
    self.videoFrame = playViewRect;
    
    if (self.videoUrl && self.player.isPlaying == NO) {
        [self.player playWithURL:self.videoUrl];
    }
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

- (void)showNoteAnimation:(NSInteger)index {
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    CALayer *layer = [self animationTextLayerWithFrame:noteModel.textFrame preview:YES index:index];
    [self.playView.layer addSublayer:layer];
}

- (void)exportVideoWithNoteAnimationCompletion:(void(^)(NSURL *exportURL))completion {
    [self addWatermarkWithVideoUrl:self.videoUrl completion:completion];
}

#pragma mark -- 添加水印、字幕、动画
- (void)addWatermarkWithVideoUrl:(NSURL *)videoUrl completion:(void(^)(NSURL *exportURL))completion {
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
    [self renderWaterMarkWithComposition:mainCompositionInst];
    
    [self videoExportComosition:mixComposition videoComposition:mainCompositionInst quality:AVAssetExportPresetHighestQuality completion:completion];
}

//添加水印
- (void)renderWaterMarkWithComposition:(AVMutableVideoComposition *)composition {
    CGSize renderSize = composition.renderSize;
    CALayer *parentLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    
    CALayer *videoLayer = [CALayer layer];
    videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    [parentLayer addSublayer:videoLayer];
    
    //1、视频实际尺寸/当前显示尺寸,计算出视频的缩放比例
    CGFloat scale = renderSize.width/self.videoFrame.size.width;
    //2、左下角为原点,对水印图片坐标系进行转换
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        WZMNoteModel *noteModel = [self.noteModels objectAtIndex:i];
        CGRect markFrame = noteModel.textFrame;
        markFrame.origin.x *= scale;
        markFrame.origin.y *= scale;
        markFrame.size.width *= scale;
        markFrame.size.height *= scale;
        markFrame = [self convertToLandscapeRect:markFrame superSize:renderSize];
        
        CALayer *layer = [self animationTextLayerWithFrame:markFrame preview:NO index:i];
        [parentLayer addSublayer:layer];
    }
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

//layer动画
- (CALayer *)animationTextLayerWithFrame:(CGRect)frame preview:(BOOL)preview index:(NSInteger)index {
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = frame;
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *contentLayer = [self textLayerWithFrame:overlayLayer.bounds preview:preview index:index];
    [overlayLayer addSublayer:contentLayer];
    
    // 3.显示动画
    NSTimeInterval animationDuration = 0.1f;
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = @0.0f;
    fadeInAnimation.toValue = @1.0f;
    fadeInAnimation.additive = NO;
    fadeInAnimation.autoreverses = NO;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode = kCAFillModeBoth;
    fadeInAnimation.duration = animationDuration;
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fromValue = @1.0f;
    fadeOutAnimation.toValue = @0.0f;
    fadeOutAnimation.additive = NO;
    fadeOutAnimation.autoreverses = NO;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.fillMode = kCAFillModeBoth;
    fadeOutAnimation.duration = animationDuration;
    
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    if (preview) {
        [contentLayer addAnimation:fadeInAnimation forKey:@"opacity"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(noteModel.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [overlayLayer addAnimation:fadeOutAnimation forKey:@"opacity"];
        });
    }
    else {
        fadeInAnimation.beginTime = noteModel.startTime;
        fadeOutAnimation.beginTime = (noteModel.startTime+noteModel.duration);
        [contentLayer addAnimation:fadeInAnimation forKey:@"opacity"];
        [overlayLayer addAnimation:fadeOutAnimation forKey:@"opacity"];
    }
    return overlayLayer;
}

- (CALayer *)textLayerWithFrame:(CGRect)frame preview:(BOOL)preview index:(NSInteger)index {
    CALayer *contentLayer = [CALayer layer];
    contentLayer.frame = frame;
    contentLayer.backgroundColor = [UIColor greenColor].CGColor;
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    if (noteModel.text.length <= 0) return contentLayer;
    
    //缩放比例
    CGFloat scale = (frame.size.width/noteModel.textFrame.size.width);
    //单个字的宽和高
    CGFloat singleW = (frame.size.width/noteModel.text.length);
    //音符上下波动间距
    CGFloat dy = frame.size.height-singleW;
    //音符起始x、y坐标
    CGFloat startX = 0.0, startY = dy;
    
    NSMutableArray *words = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *layers = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < noteModel.text.length; i ++) {
        @autoreleasepool {
            NSString *word = [noteModel.text substringWithRange:NSMakeRange(i, 1)];
            [words addObject:word];
            
            CGRect rect = CGRectMake(startX+i*singleW, startY, singleW, singleW);
            if (preview == NO) {
                rect = [self convertToLandscapeRect:rect superSize:frame.size];
            }
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = word;
            textLayer.font = noteModel.textFont;
            textLayer.fontSize = noteModel.textFontSize*scale;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.frame = rect;
            textLayer.foregroundColor = [UIColor redColor].CGColor;
            textLayer.backgroundColor = [UIColor blueColor].CGColor;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [contentLayer addSublayer:textLayer];
            
            CGPoint point1, point2;
            if (preview == NO) {
                point1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
                point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect)+dy);
            }
            else {
                point1 = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
                point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect)-dy);
            }
            [points addObject:NSStringFromCGPoint(point1)];
            [points addObject:NSStringFromCGPoint(point2)];
        }
    }
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    if (points.count > 1) {
        CGPoint startPoint = CGPointFromString(points[0]);
        [bezierPath moveToPoint:startPoint];
        NSInteger count = points.count;
        for (NSInteger i = 1; i < count; i ++) {
            CGPoint endPoint = CGPointFromString(points[i]);
            [bezierPath addLineToPoint:endPoint];
        }
    }
    
    CGRect noteRect = CGRectMake(0, 0, 10, 10);
    if (preview == NO) {
        noteRect.origin.x *= scale;
        noteRect.origin.y *= scale;
        noteRect.size.width *= scale;
        noteRect.size.height *= scale;
        noteRect = [self convertToLandscapeRect:noteRect superSize:frame.size];
    }
    CALayer *noteLayer = [CALayer layer];
    noteLayer.frame = noteRect;
    noteLayer.backgroundColor = [UIColor redColor].CGColor;
    [contentLayer addSublayer:noteLayer];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //设置动画属性，因为是沿着贝塞尔曲线动，所以要设置为position
    animation.keyPath = @"position";
    //设置动画时间
    animation.duration = noteModel.duration;
    // 告诉在动画结束的时候不要移除
    animation.removedOnCompletion = NO;
    // 始终保持最新的效果
    animation.fillMode = kCAFillModeForwards;
    // 设置贝塞尔曲线路径
    animation.path = bezierPath.CGPath;
    // 将动画对象添加到视图的layer上
    if (preview == NO) {
        animation.beginTime = noteModel.startTime;
    }
    [noteLayer addAnimation:animation forKey:@"noteAnimation"];
    
    return contentLayer;
}

///
- (CGPoint)convertToLandscapePoint:(CGPoint)point height:(CGFloat)height superSize:(CGSize)superSize {
    CGPoint portraitPoint = point;
    portraitPoint.y = (superSize.height-point.y-height);
    return portraitPoint;
}

- (CGRect)convertToLandscapeRect:(CGRect)rect superSize:(CGSize)superSize {
    CGRect portraitRect = rect;
    portraitRect.origin.y = (superSize.height-rect.origin.y-rect.size.height);
    return portraitRect;
}

- (CGPoint)convertToPortraitPoint:(CGPoint)point height:(CGFloat)height {
    CGPoint portraitPoint = point;
    portraitPoint.y = (point.y+height);
    return portraitPoint;
}

- (CGRect)convertToPortraitRect:(CGRect)rect {
    CGRect portraitRect = rect;
    portraitRect.origin.y = (rect.origin.y+rect.size.height);
    return portraitRect;
}

#pragma mark - private method
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
    assetExport.shouldOptimizeForNetworkUse = YES;
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

- (void)playerPlaying:(WZMPlayer *)player {
    static NSInteger index = 0;
    for (NSInteger i = index; i < self.noteModels.count; i ++) {
        @autoreleasepool {
            WZMNoteModel *noteModel = [self.noteModels objectAtIndex:i];
            if (noteModel.allowShow == NO) continue;
            if (fabs(player.currentTime - noteModel.startTime) <= 0.1) {
                noteModel.allowShow = NO;
                [self showNoteAnimation:i];
                index = i+1;
                break;
            }
        }
    }
}

@end
