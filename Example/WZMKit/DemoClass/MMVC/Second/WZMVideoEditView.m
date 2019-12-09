//
//  WZMVideoEditView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoEditView.h"
#import "FLLayerBuilderTool.h"

@interface WZMVideoEditView ()<WZMPlayerDelegate>

@property (nonatomic ,assign) CGFloat scale;
@property (nonatomic ,assign) CGRect videoFrame;
@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playView;

@end

@implementation WZMVideoEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self layoutWithFrame:self.bounds];
    }
    return self;
}

- (void)layoutWithFrame:(CGRect)frame {
    self.renderSize = CGSizeZero;
    self.playView = [[WZMPlayerView alloc] initWithFrame:frame];
    [self addSubview:self.playView];
    
    self.player = [[WZMPlayer alloc] init];
    self.player.delegate = self;
    self.player.playerView = self.playView;
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
    CGRect playViewRect = CGRectZero;
    playViewRect.origin.x = (self.bounds.size.width-playViewSize.width)/2;
    playViewRect.origin.y = (self.bounds.size.height-playViewSize.height)/2;
    playViewRect.size = playViewSize;
    self.playView.frame = playViewRect;
    self.videoFrame = playViewRect;
    
    self.scale = self.renderSize.width/self.videoFrame.size.width;
    
    NSLog(@"%@",self.videoUrl);
    if (self.videoUrl) {
        [self.player playWithURL:self.videoUrl];
    }
}

- (void)showNoteAnimation:(NSInteger)index {
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    CALayer *layer = [self animationTextLayerWithFrame:[noteModel textFrame] preview:YES index:index];
    [self.playView.layer addSublayer:layer];
}

- (void)exportVideoWithNoteAnimationCompletion:(void(^)(NSURL *exportURL))completion {
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    [self addWatermarkWithVideoUrl:self.videoUrl completion:completion];
}

///播放器代理
- (void)playerPlaying:(WZMPlayer *)player {
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    static NSInteger index = 0;
    for (NSInteger i = index; i < self.noteModels.count; i ++) {
        @autoreleasepool {
            WZMNoteModel *noteModel = [self.noteModels objectAtIndex:i];
            if (fabs(player.currentTime - noteModel.startTime) <= 0.1) {
                [self showNoteAnimation:i];
                index = i+1;
                break;
            }
        }
    }
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
    CGFloat scale = self.scale;
    //2、左下角为原点,对水印图片坐标系进行转换
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        WZMNoteModel *noteModel = [self.noteModels objectAtIndex:i];
        CGRect markFrame = [noteModel textFrame];
        markFrame.origin.x *= scale;
        markFrame.origin.y *= scale;
        markFrame.size.width *= scale;
        markFrame.size.height *= scale;
        markFrame = WZMConvertToLandscapeRect(markFrame, renderSize);
        
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
    overlayLayer.contentsScale = [UIScreen mainScreen].scale;
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
    contentLayer.contentsScale = [UIScreen mainScreen].scale;
    contentLayer.frame = frame;
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    if (noteModel.text.length <= 0) return contentLayer;
    
    //缩放比例
    CGFloat scale = (frame.size.width/[noteModel textFrame].size.width);
    //单个字的宽和高
    CGFloat singleW = (noteModel.textFontSize+5)*scale;
    //音符上下波动间距
    CGFloat dy = 30*scale;
    //音符起始x、y坐标
    CGFloat startX = 0.0, startY = dy;
    
    NSMutableArray *words = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *textLayers = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *graLayers = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger columns = [noteModel textColumns];
    for (NSInteger i = 0; i < noteModel.text.length; i ++) {
        @autoreleasepool {
            //创建字符layer
            NSString *word = [noteModel.text substringWithRange:NSMakeRange(i, 1)];
            [words addObject:word];
            CGRect rect = CGRectMake(startX+i%columns*singleW, startY+i/columns*singleW, singleW, singleW);
            if (preview == NO) {
                rect = WZMConvertToLandscapeRect(rect, frame.size);
            }
            
            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.string = word;
            textLayer.font = noteModel.textFont;
            textLayer.fontSize = noteModel.textFontSize*scale;
            textLayer.alignmentMode = kCAAlignmentCenter;
            textLayer.frame = rect;
            textLayer.foregroundColor = noteModel.textColor.CGColor;
            textLayer.backgroundColor = noteModel.backgroundColor.CGColor;
            textLayer.contentsScale = [UIScreen mainScreen].scale;
            [contentLayer addSublayer:textLayer];
            [textLayers addObject:textLayer];
            
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = textLayer.frame;
            gradientLayer.colors = @[(id)noteModel.textColor.CGColor,(id)noteModel.textColor.CGColor];
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 1);
            gradientLayer.mask = textLayer;
            textLayer.frame = gradientLayer.bounds;
            gradientLayer.contentsScale = [UIScreen mainScreen].scale;
            [contentLayer addSublayer:gradientLayer];
            [graLayers addObject:gradientLayer];
            
            //记录音符轨迹
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
    noteModel.textLayers = [textLayers copy];
    noteModel.graLayers = [graLayers copy];
    noteModel.points = [points copy];
    
    [self showTextAnimationInLayer:contentLayer preview:preview index:index];
    [self showNoteAnimationInLayer:contentLayer preview:preview index:index];
    return contentLayer;
}

- (void)showTextAnimationInLayer:(CALayer *)contentLayer
                         preview:(BOOL)preview
                           index:(NSInteger)index {
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    //单个字的动画时长
    CGFloat singleDuration = (noteModel.duration/noteModel.text.length);
    //缩放比例
    CGFloat scale = (contentLayer.frame.size.width/[noteModel textFrame].size.width);
    
    NSMutableArray *animations = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < noteModel.textLayers.count; i ++) {
        CATextLayer *textLayer = [noteModel.textLayers objectAtIndex:i];
        CAGradientLayer *gradientLayer = [noteModel.graLayers objectAtIndex:i];
        
        //下移动画
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position";
        animation.duration = singleDuration;
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        
        CGPoint position = textLayer.position;
        CGFloat factor = 1;
        if (preview == NO) {
            factor = -1;
        }
        CGPoint position1 = position;
        position1.y += (5*scale*factor);
        
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCGPoint:position1]];
        [values addObject:[NSValue valueWithCGPoint:position]];
        
        animation.values = values;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        
        //变色动画
        CABasicAnimation *animation2 = [CABasicAnimation animation];
        animation2.keyPath = @"colors";
        animation2.duration = singleDuration;
        animation2.removedOnCompletion = NO;
        animation2.fillMode = kCAFillModeForwards;
        animation2.fromValue = @[(id)noteModel.highTextColor.CGColor,(id)noteModel.highTextColor.CGColor];
        animation2.toValue = @[(id)noteModel.textColor.CGColor,(id)noteModel.textColor.CGColor];
        animation2.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        
        //压扁动画
        CAKeyframeAnimation *animation3 = [CAKeyframeAnimation animation];
        animation3.keyPath = @"transform";
        animation3.duration = singleDuration;
        animation3.removedOnCompletion = NO;
        animation3.fillMode = kCAFillModeForwards;
        
        NSMutableArray *values3 = [NSMutableArray array];
        [values3 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 0.6, 1.0)]];
        [values3 addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        animation3.values = values3;
        animation3.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
        
        //动画组
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.animations = @[animation,animation3];
        
        CGFloat singleStartTime = noteModel.startTime+singleDuration*i;
        if (preview == NO) {
            group.beginTime = singleStartTime;
            [textLayer addAnimation:group forKey:@"sharkAnimation"];
            
            animation2.beginTime = singleStartTime;
            [gradientLayer addAnimation:animation2 forKey:@"colorAnimation"];
        }
        else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(singleDuration*i*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [textLayer addAnimation:group forKey:@"sharkAnimation"];
                [gradientLayer addAnimation:animation2 forKey:@"colorAnimation"];
            });
        }
        [animations addObject:group];
    }
    noteModel.animations = [animations copy];
}

/// 音符动画
/// @param contentLayer 父layer
/// @param preview      是否是预览
/// @param index        字幕索引
- (void)showNoteAnimationInLayer:(CALayer *)contentLayer
                         preview:(BOOL)preview
                           index:(NSInteger)index {
    WZMNoteModel *noteModel = [self.noteModels objectAtIndex:index];
    //缩放比例
    CGFloat scale = (contentLayer.frame.size.width/[noteModel textFrame].size.width);
    CGRect noteRect = CGRectMake(0, 0, 10, 10);
    if (preview == NO) {
        noteRect.origin.x *= scale;
        noteRect.origin.y *= scale;
        noteRect.size.width *= scale;
        noteRect.size.height *= scale;
        noteRect = WZMConvertToLandscapeRect(noteRect, contentLayer.frame.size);
    }
    //音符layer
    CALayer *noteLayer = [CALayer layer];
    noteLayer.frame = noteRect;
    noteLayer.contentsGravity = kCAGravityResize;
    noteLayer.contents = (__bridge id)(noteModel.noteImage.CGImage);
    noteLayer.contentsScale = [UIScreen mainScreen].scale;
    [contentLayer addSublayer:noteLayer];
    //贝塞尔曲线
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 1;
    bezierPath.lineCapStyle = kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    if (noteModel.points.count > 1) {
        CGPoint startPoint = CGPointFromString(noteModel.points[0]);
        [bezierPath moveToPoint:startPoint];
        NSInteger count = noteModel.points.count;
        for (NSInteger i = 1; i < count; i ++) {
            CGPoint endPoint = CGPointFromString(noteModel.points[i]);
            [bezierPath addLineToPoint:endPoint];
        }
    }
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
}

#pragma mark - 视频导出
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

@end
