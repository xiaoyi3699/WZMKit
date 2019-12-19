//
//  WZMVideoEditView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/11/28.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMVideoEditView.h"
#import "WZMTextLayer.h"

@interface WZMVideoEditView ()<WZMPlayerDelegate,WZMCaptionViewDelegate>

@property (nonatomic, assign) CGRect videoFrame;
@property (nonatomic, assign) CGSize renderSize;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playView;

///最大宽度/高度,根据playView计算
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat maxHeight;
///是否正在导出
@property (nonatomic, assign) BOOL exporting;

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
    self.player.trackingRunLoop = NO;
}

- (void)setVideoUrl:(NSURL *)videoUrl {
    if ([_videoUrl.path isEqualToString:videoUrl.path]) return;
    _videoUrl = videoUrl;
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    //矫正视频角度
    NSUInteger degress = 0;
    CGAffineTransform t = track.preferredTransform;
    BOOL isVideoAssetPortrait_  = NO;
    if (t.a == 0 && t.b == 1.0 && t.c == -1.0 && t.d == 0) {
        degress = 90;
        isVideoAssetPortrait_ = YES;
    } else if (t.a == 0 && t.b == -1.0 && t.c == 1.0 && t.d == 0) {
        degress = 270;
        isVideoAssetPortrait_ = YES;
    } else if (t.a == 1.0 && t.b == 0 && t.c == 0 && t.d == 1.0) {
        degress = 0;
    } else if (t.a == -1.0 && t.b == 0 && t.c == 0 && t.d == -1.0) {
        degress = 180;
    }
    if (isVideoAssetPortrait_) {
        self.renderSize = CGSizeMake(track.naturalSize.height, track.naturalSize.width);
    }
    else {
        self.renderSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
    }
    [self layoutPlayView];
    [self setConfigNoteModels];
}

- (void)setNoteModels:(NSArray<WZMCaptionModel *> *)noteModels {
    if (_noteModels == noteModels) return;
    _noteModels = noteModels;
    [self setConfigNoteModels];
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
    if (self.videoUrl) {
        [self.player playWithURL:self.videoUrl];
    }
}

//初始化字幕的位置
- (void)setConfigNoteModels {
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    if (CGSizeEqualToSize(self.playView.bounds.size, CGSizeZero)) return;
    for (WZMCaptionModel *model in self.noteModels) {
        if (model.textMaxW == 0 && model.textMaxH == 0) {
            model.textMaxW = self.maxWidth;
            model.textMaxH = self.maxHeight;
            CGRect textFrame = [model textFrameWithTextColumns:nil];
            CGFloat textX = (self.playView.bounds.size.width-textFrame.size.width)/2;
            CGFloat textY = self.playView.bounds.size.height-textFrame.size.height;
            if (textY > 10) {
                textY -= 10;
            }
            model.textPosition = CGPointMake(textX, textY);
        }
    }
}

//预览字幕出现
- (void)showCaptionAnimation:(NSInteger)index {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    noteModel.showing = YES;
    
    //字幕编辑框view
    WZMCaptionView *captionView = noteModel.captionView;
    if (captionView == nil) {
        captionView = [[WZMCaptionView alloc] initWithFrame:CGRectZero];
        captionView.delegate = self;
        captionView.index = index;
        CATransform3D transform3D = CATransform3DIdentity;
        captionView.layer.transform = CATransform3DConcat(transform3D, CATransform3DMakeRotation(noteModel.angle*M_PI/180.0, 0, 0, 1));
        [self.playView addSubview:captionView];
        noteModel.captionView = captionView;
    }
    CGFloat maxWidth = self.maxWidth;
    if (maxWidth < noteModel.textMaxW) {
        noteModel.textMaxW = maxWidth;
    }
    //创建layer
    [noteModel.contentLayer1 removeFromSuperlayer];
    CALayer *layer = [self animationTextLayerWithFrame:[noteModel textFrameWithTextColumns:nil] preview:YES index:index];
    noteModel.contentLayer1 = layer;
    //设置相关参数
    captionView.minWidth = (noteModel.textFontSize+5);
    captionView.frame = layer.frame;
    captionView.hidden = NO;
    [self.playView.layer addSublayer:layer];
}

//预览字幕消失
- (void)dismissCaptionAnimation:(NSInteger)index {
    CABasicAnimation *fadeOutAnimation = [self fadeOutAnimation];
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    noteModel.showing = NO;
    [noteModel.contentLayer1 addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    WZMCaptionView *captionView = noteModel.captionView;
    captionView.hidden = YES;
}

- (void)exportVideoWithNoteAnimationCompletion:(void(^)(NSURL *exportURL))completion {
    if (self.exporting) return;
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    self.exporting = YES;
    @wzm_weakify(self);
    [self addWatermarkWithVideoUrl:self.videoUrl completion:^(NSURL *exportURL2) {
        @wzm_strongify(self);
        self.exporting = NO;
        if (completion) completion(exportURL2);
    }];
}

//播放器事件
- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player stop];
}

- (void)seekToTime:(NSInteger)time {
    [self.player seekToTime:time];
    [self changedPlayerCurrentTime:self.player.currentTime];
}

- (void)seekToProgress:(CGFloat)progress {
    [self.player seekToProgress:progress];
}

- (void)checkPlayIfAdjustCaption {
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        @autoreleasepool {
            WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:i];
            if ((self.player.currentTime > noteModel.startTime) && (self.player.currentTime < (noteModel.startTime+noteModel.duration))) {
                [self.player seekToTime:noteModel.startTime];
                [self.player play];
                return;
            }
        }
    }
    [self.player play];
}

- (WZMCaptionModel *)checkHasEditingModel {
    if (self.noteModels == nil || self.noteModels.count == 0) return nil;
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        @autoreleasepool {
            WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:i];
            if ((self.player.currentTime > noteModel.startTime) && (self.player.currentTime < (noteModel.startTime+noteModel.duration))) {
                if (noteModel.editing) {
                    return noteModel;
                }
                //显示编辑框
                [noteModel.captionView captionViewShow:YES];
                //手动调用代理
                [self captionViewShow:noteModel.captionView];
                return noteModel;
            }
        }
    }
    return nil;
}

#pragma mark - 事件代理
///播放器代理
- (void)playerBeginPlaying:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerBeginPlaying:)]) {
        [self.delegate playerBeginPlaying:player];
    }
}

- (void)playerPlaying:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerPlaying:)]) {
        [self.delegate playerPlaying:player];
    }
    [self changedPlayerCurrentTime:player.currentTime];
}

- (void)playerEndPlaying:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerEndPlaying:)]) {
        [self.delegate playerEndPlaying:player];
    }
    [player seekToTime:0];
    [player play];
}

///加载成功
- (void)playerLoadSuccess:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerLoadSuccess:)]) {
        [self.delegate playerLoadSuccess:player];
    }
}
///加载失败
- (void)playerLoadFailed:(WZMPlayer *)player error:(NSString *)error {
    if ([self.delegate respondsToSelector:@selector(playerLoadFailed:error:)]) {
        [self.delegate playerLoadFailed:player error:error];
    }
}
///缓冲进度
- (void)playerLoadProgress:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerLoadProgress:)]) {
        [self.delegate playerLoadProgress:player];
    }
}

///播放状态改变
- (void)playerChangeStatus:(WZMPlayer *)player {
    if ([self.delegate respondsToSelector:@selector(playerChangeStatus:)]) {
        [self.delegate playerChangeStatus:player];
    }
}

- (void)changedPlayerCurrentTime:(CGFloat)currentTime {
    if (self.noteModels == nil || self.noteModels.count == 0) return;
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        @autoreleasepool {
            WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:i];
            if (self.player.isPlaying && noteModel.editing) {
                noteModel.editing = NO;
                [noteModel.captionView captionViewShow:NO];
            }
            if ((currentTime > noteModel.startTime) && (currentTime < (noteModel.startTime+noteModel.duration))) {
                if (noteModel.showing == NO) {
                    [self showCaptionAnimation:i];
                }
                else {
                    if (self.player.playing == NO) {
                        [noteModel.noteLayer removeAnimationForKey:@"noteAnimation"];
                    }
                }
            }
            else {
                if (noteModel.showing) {
                    [self dismissCaptionAnimation:i];
                }
            }
        }
    }
}

///字幕视图代理
- (void)captionViewShow:(WZMCaptionView *)captionView {
    [self.player pause];
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:captionView.index];
    noteModel.editing = YES;
    [noteModel.noteLayer removeAnimationForKey:@"noteAnimation"];
}

- (void)captionViewDismiss:(WZMCaptionView *)captionView {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:captionView.index];
    noteModel.editing = NO;
    [self.player seekToTime:noteModel.startTime];
    [self.player play];
}

- (void)captionViewBeginEditing:(WZMCaptionView *)captionView {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:captionView.index];
    noteModel.text = @"我已经改变了文字";
    [self showCaptionAnimation:captionView.index];
}

- (void)captionView:(WZMCaptionView *)captionView changeFrame:(CGRect)frame {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:captionView.index];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    noteModel.contentLayer1.frame = frame;
    [CATransaction commit];
}

- (void)captionView:(WZMCaptionView *)captionView endChangeFrame:(CGRect)newFrame oldFrame:(CGRect)oldFrame {
    
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:captionView.index];
    noteModel.textPosition = newFrame.origin;
    
    //宽度发生了改变
    if (newFrame.size.width != oldFrame.size.width) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        noteModel.textMaxW = newFrame.size.width;
        NSInteger columns;
        CGRect newRect = [noteModel textFrameWithTextColumns:&columns];
        //当高度达到最大值时,以右边框
        if (newFrame.size.width < newRect.size.width) {
            newRect.origin.x = CGRectGetMaxX(oldFrame)-newRect.size.width;
            noteModel.textPosition = newRect.origin;
        }
        captionView.frame = newRect;
        noteModel.contentLayer1.frame = newRect;
        //单个字的宽和高
        CGFloat singleW = (noteModel.textFontSize+5)*1;
        //音符上下波动间距
        CGFloat dy = (noteModel.showNote ? 30 : 0)*1;
        //音符起始x、y坐标
        CGFloat startX = 0.0, startY = dy;
        for (NSInteger i = 0; i < noteModel.textLayers1.count; i ++) {
            CGRect rect = CGRectMake(startX+i%columns*singleW, startY+i/columns*singleW, singleW, singleW);
            
            CATextLayer *textLayer = [noteModel.textLayers1 objectAtIndex:i];
            textLayer.frame = rect;
            
            CAGradientLayer *gradientLayer = [noteModel.graLayers1 objectAtIndex:i];
            gradientLayer.frame = textLayer.frame;
            gradientLayer.mask = textLayer;
            textLayer.frame = gradientLayer.bounds;
        }
        [CATransaction commit];
    }
}

//键盘代理

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
    CGFloat scale = self.renderSize.width/self.videoFrame.size.width;
    //2、左下角为原点,对水印图片坐标系进行转换
    for (NSInteger i = 0; i < self.noteModels.count; i ++) {
        WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:i];
        CGRect markFrame = [noteModel textFrameWithTextColumns:nil];
        markFrame.origin.x *= scale;
        markFrame.origin.y *= scale;
        markFrame.size.width *= scale;
        markFrame.size.height *= scale;
        markFrame = WZMConvertToLandscapeRect(markFrame, renderSize);
        
        [noteModel.contentLayer2 removeFromSuperlayer];
        CALayer *layer = [self animationTextLayerWithFrame:markFrame preview:NO index:i];
        [parentLayer addSublayer:layer];
        noteModel.contentLayer2 = layer;
    }
    composition.animationTool = [AVVideoCompositionCoreAnimationTool
                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
}

//layer动画
- (CALayer *)animationTextLayerWithFrame:(CGRect)frame preview:(BOOL)preview index:(NSInteger)index {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    CALayer *overlayLayer = [CALayer layer];
    overlayLayer.frame = frame;
    overlayLayer.contentsScale = [UIScreen mainScreen].scale;
    [overlayLayer setMasksToBounds:YES];
    
    CALayer *contentLayer = [self textLayerWithFrame:overlayLayer.bounds preview:preview index:index];
    [overlayLayer addSublayer:contentLayer];
    
    CABasicAnimation *fadeInAnimation = [self fadeInAnimation];
    if (preview) {
        [contentLayer addAnimation:fadeInAnimation forKey:@"fadeIn"];
    }
    else {
        CABasicAnimation *fadeOutAnimation = [self fadeOutAnimation];
        
        fadeInAnimation.beginTime = noteModel.startTime;
        fadeOutAnimation.beginTime = (noteModel.startTime+noteModel.duration);
        [contentLayer addAnimation:fadeInAnimation forKey:@"fadeIn"];
        [overlayLayer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    }
    if (noteModel.angle/360.0 != 0) {
        CGFloat angle = 0.0;
        if (preview) {
            angle = noteModel.angle;
        }
        else {
            angle = 360.0 - noteModel.angle;
        }
        CATransform3D transform3D = CATransform3DIdentity;
        overlayLayer.transform = CATransform3DConcat(transform3D, CATransform3DMakeRotation(angle*M_PI/180.0, 0, 0, 1));
    }
    return overlayLayer;
}

//显示动画
- (CABasicAnimation *)fadeInAnimation {
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = @0.0f;
    fadeInAnimation.toValue = @1.0f;
    fadeInAnimation.additive = NO;
    fadeInAnimation.autoreverses = NO;
    fadeInAnimation.removedOnCompletion = NO;
    fadeInAnimation.fillMode = kCAFillModeBoth;
    fadeInAnimation.duration = 0.1f;
    return fadeInAnimation;
}

//隐藏动画
- (CABasicAnimation *)fadeOutAnimation {
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.fromValue = @1.0f;
    fadeOutAnimation.toValue = @0.0f;
    fadeOutAnimation.additive = NO;
    fadeOutAnimation.autoreverses = NO;
    fadeOutAnimation.removedOnCompletion = NO;
    fadeOutAnimation.fillMode = kCAFillModeBoth;
    fadeOutAnimation.duration = 0.1;
    return fadeOutAnimation;
}

- (CALayer *)textLayerWithFrame:(CGRect)frame preview:(BOOL)preview index:(NSInteger)index {
    CALayer *contentLayer = [CALayer layer];
    contentLayer.contentsScale = [UIScreen mainScreen].scale;
    contentLayer.frame = frame;
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    if (noteModel.text.length <= 0) return contentLayer;
    
    //创建新的layer
    //缩放比例
    NSInteger columns;
    CGRect textRect = [noteModel textFrameWithTextColumns:&columns];
    CGFloat scale = (frame.size.width/textRect.size.width);
    //单个字的宽和高
    CGFloat singleW = (noteModel.textFontSize+5)*scale;
    //音符上下波动间距
    CGFloat dy = (noteModel.showNote ? 30 : 0)*scale;
    //音符起始x、y坐标
    CGFloat startX = 0.0, startY = dy;
    
    NSMutableArray *words = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *textLayers = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *graLayers = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSInteger i = 0; i < noteModel.text.length; i ++) {
        @autoreleasepool {
            //创建字符layer
            NSString *word = [noteModel.text substringWithRange:NSMakeRange(i, 1)];
            [words addObject:word];
            CGRect rect = CGRectMake(startX+i%columns*singleW, startY+i/columns*singleW, singleW, singleW);
            if (preview == NO) {
                rect = WZMConvertToLandscapeRect(rect, frame.size);
            }
            
            WZMTextLayer *textLayer = [WZMTextLayer layer];
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
            
            NSArray *values;
            if (noteModel.textType == WZMCaptionModelTypeNormal) {
                //默认
                values = @[(id)noteModel.textColor.CGColor,(id)noteModel.textColor.CGColor];
            }
            else {
                //渐变
                NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:0];
                for (UIColor *color in noteModel.textColors) {
                    [colors addObject:(id)color.CGColor];
                }
                values = [colors copy];
            }
            CAGradientLayer *gradientLayer = [CAGradientLayer layer];
            gradientLayer.frame = textLayer.frame;
            gradientLayer.colors = values;
            gradientLayer.startPoint = CGPointMake(0, 0);
            gradientLayer.endPoint = CGPointMake(1, 1);
            gradientLayer.contentsScale = [UIScreen mainScreen].scale;
            gradientLayer.mask = textLayer;
            textLayer.frame = gradientLayer.bounds;
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
    if (preview) {
        noteModel.textLayers1 = [textLayers copy];
        noteModel.graLayers1 = [graLayers copy];
    }
    else {
        noteModel.textLayers2 = [textLayers copy];
        noteModel.graLayers2 = [graLayers copy];
    }
    noteModel.points = [points copy];
    
    [self showTextAnimationInLayer:contentLayer preview:preview index:index];
    [self showCaptionAnimationInLayer:contentLayer preview:preview index:index];
    return contentLayer;
}

- (void)showTextAnimationInLayer:(CALayer *)contentLayer
                         preview:(BOOL)preview
                           index:(NSInteger)index {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    //单个字的动画时长
    CGFloat singleDuration = (noteModel.duration/noteModel.text.length);
    //缩放比例
    CGFloat scale = (contentLayer.frame.size.width/[noteModel textFrameWithTextColumns:nil].size.width);
    
    NSArray *tLayers = preview ? noteModel.textLayers1 : noteModel.textLayers2;
    NSArray *gLayers = preview ? noteModel.graLayers1 : noteModel.graLayers2;
    for (NSInteger i = 0; i < tLayers.count; i ++) {
        CATextLayer *textLayer = [tLayers objectAtIndex:i];
        CAGradientLayer *gradientLayer = [gLayers objectAtIndex:i];
        
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
        NSArray *fromValue2, *toValue2;
        if (noteModel.textType == WZMCaptionModelTypeNormal) {
            //默认
            fromValue2 = @[(id)noteModel.textColor.CGColor,(id)noteModel.textColor.CGColor];
            toValue2 = @[(id)noteModel.highTextColor.CGColor,(id)noteModel.highTextColor.CGColor];
        }
        else {
            //渐变
            NSMutableArray *colors1 = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *colors2 = [[NSMutableArray alloc] initWithCapacity:0];
            for (UIColor *color in noteModel.textColors) {
                [colors1 addObject:(id)color.CGColor];
            }
            for (UIColor *color in noteModel.highTextColors) {
                [colors2 addObject:(id)color.CGColor];
            }
            fromValue2 = [colors1 copy];
            toValue2 = [colors2 copy];
        }
        if (noteModel.textAnimationType == WZMCaptionTextAnimationTypeSingle) {
            //单字高亮
            animation2.fromValue = toValue2;
            animation2.toValue = fromValue2;
        }
        else {
            //逐字高亮
            animation2.fromValue = fromValue2;
            animation2.toValue = toValue2;
        }
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
        if (preview) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(singleDuration*i*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //处于编辑状态时不添加动画
                if (noteModel.editing == NO && self.player.isPlaying) {
                    if (noteModel.showNote) {
                        [textLayer addAnimation:group forKey:@"sharkAnimation"];
                    }
                    [gradientLayer addAnimation:animation2 forKey:@"colorAnimation"];
                }
            });
        }
        else {
            if (noteModel.showNote) {
                group.beginTime = singleStartTime;
                [textLayer addAnimation:group forKey:@"sharkAnimation"];
            }
            animation2.beginTime = singleStartTime;
            [gradientLayer addAnimation:animation2 forKey:@"colorAnimation"];
        }
    }
}

/// 音符动画
/// @param contentLayer 父layer
/// @param preview      是否是预览
/// @param index        字幕索引
- (void)showCaptionAnimationInLayer:(CALayer *)contentLayer
                         preview:(BOOL)preview
                           index:(NSInteger)index {
    WZMCaptionModel *noteModel = [self.noteModels objectAtIndex:index];
    if (noteModel.showNote == NO) return;
    //缩放比例
    CGFloat scale = (contentLayer.frame.size.width/[noteModel textFrameWithTextColumns:nil].size.width);
    CGRect noteRect = CGRectMake(-10, -10, 10, 10);
    if (preview == NO) {
        noteRect.origin.x *= scale;
        noteRect.origin.y *= scale;
        noteRect.size.width *= scale;
        noteRect.size.height *= scale;
        noteRect = WZMConvertToLandscapeRect(noteRect, contentLayer.frame.size);
    }
    //音符layer
    [noteModel.noteLayer removeFromSuperlayer];
    CALayer *noteLayer = [CALayer layer];
    noteLayer.frame = noteRect;
    noteLayer.contentsGravity = kCAGravityResize;
    noteLayer.contents = (__bridge id)(noteModel.noteImage.CGImage);
    noteLayer.contentsScale = [UIScreen mainScreen].scale;
    [contentLayer addSublayer:noteLayer];
    noteModel.noteLayer = noteLayer;
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
    //
    if (preview) {
        if (noteModel.editing || (self.player.isPlaying == NO)) return;
    }
    else {
        animation.beginTime = noteModel.startTime;
    }
    // 将动画对象添加到视图的layer上
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

- (CGFloat)maxWidth {
    return self.playView.wzm_width-CAP_MENU_WIDTH*2;
}

- (CGFloat)maxHeight {
    return self.playView.wzm_height-CAP_MENU_WIDTH*2;
}

@end
