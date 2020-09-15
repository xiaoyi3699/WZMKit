//
//  WZMAlbumEditViewController.m
//  WZMKit
//
//  Created by Zhaomeng Wang on 2020/6/3.
//

#import "WZMAlbumEditViewController.h"
#import "UIColor+wzmcate.h"
#import "WZMCropView.h"
#import "WZMInline.h"
#import "WZMMacro.h"
#import "WZMAlbumScaleView.h"
#import "UIView+wzmcate.h"
#import "UIImage+wzmcate.h"
#import "WZMClipTimeView.h"
#import "WZMPlayer.h"
#import "WZMVideoEditer.h"
#import "WZMViewHandle.h"
#import <Photos/Photos.h>
#import "WZMAlbumHelper.h"

@interface WZMAlbumEditViewController ()<WZMAlbumScaleViewDelegate,WZMClipTimeViewDelegate,WZMVideoEditerDelegate,WZMPlayerDelegate>

@property (nonatomic, assign) BOOL loadVideo;
@property (nonatomic, assign) CGFloat navBarH;
@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, strong) NSArray *thumbnails;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) WZMCropView *cropView;
@property (nonatomic, strong) WZMAlbumScaleView *scaleView;
//图片
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
//视频
@property (nonatomic, strong) NSURL *videoUrl;
@property (nonatomic, strong) WZMPlayer *player;
@property (nonatomic, strong) WZMPlayerView *playerView;
@property (nonatomic, strong) WZMClipTimeView *clipTimeView;
@property (nonatomic, strong) WZMVideoEditer *editer;
//type 0图片 1图片
@property (nonatomic, assign) NSInteger type;

@end

@implementation WZMAlbumEditViewController

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    self = [super init];
    if (self) {
        self.loadVideo = NO;
        self.title = @"图片编辑";
        self.originals = originals;
        self.thumbnails = thumbnails;
        self.assets = assets;
        if ([originals.firstObject isKindOfClass:[UIImage class]]) {
            self.type = 0;
            self.image = originals.firstObject;
        }
        else {
            self.type = 1;
            self.videoUrl = originals.firstObject;
            self.image = thumbnails.firstObject;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:[UIColor blackColor]];
    
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    self.toolView = [[UIView alloc] init];
    [self.contentView addSubview:self.toolView];
    
    if (self.type == 0) {
        self.imageView = [[UIImageView alloc] init];
        self.imageView.image = self.originals.firstObject;
        [self.contentView addSubview:self.imageView];
    }
    else {
        self.playerView = [[WZMPlayerView alloc] init];
        [self.contentView addSubview:self.playerView];
        
        self.player = [[WZMPlayer alloc] init];
        self.player.playerView = self.playerView;
        self.player.delegate = self;
    }
    
    self.cropView = [[WZMCropView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.cropView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
//    leftItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor blueColor] darkColor:[UIColor whiteColor]];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
//    rightItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:WZM_ALBUM_COLOR darkColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.loadVideo) return;
    self.loadVideo = YES;
    [self.player playWithURL:self.videoUrl];
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick {
    //图片缩放比例
    CGFloat scale; CGRect rect;
    if (self.type == 0) {
        scale = self.image.size.width/self.imageView.wzm_width;
        rect = [self.cropView convertRect:self.cropView.cropFrame toView:self.imageView];
    }
    else {
        UIImage *image = [UIImage wzm_getImageByUrl:self.videoUrl progress:0.0 original:YES];
        scale = image.size.width/self.playerView.wzm_width;
        rect = [self.cropView convertRect:self.cropView.cropFrame toView:self.playerView];
    }
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    if (self.type == 0) {
        UIImage *image = [self.image wzm_clipImageWithRect:rect];
        if (image) {
            self.originals = @[image];
        }
        if ([self.delegate respondsToSelector:@selector(albumEditViewController:handleOriginals:thumbnails:assets:)]) {
            [self.delegate albumEditViewController:self handleOriginals:self.originals thumbnails:self.thumbnails assets:self.assets];
        }
    }
    else {
        PHAsset *asset = self.assets.firstObject;
        CGFloat d = asset.duration;
        self.editer = [[WZMVideoEditer alloc] init];
        self.editer.delegate = self;
        self.editer.cropFrame = rect;
        self.editer.start = self.clipTimeView.startValue*d;
        self.editer.duration = (self.clipTimeView.endValue-self.clipTimeView.startValue)*d;
        [self.editer handleVideoWithPath:self.videoUrl.path];
    }
}

//播放器
- (void)playerLoadFailed:(WZMPlayer *)player error:(NSString *)error {
    [WZMViewHandle wzm_showInfoMessage:@"视频加载出错"];
}

- (void)playerPlaying:(WZMPlayer *)player {
    if (player.playing) {
        if (player.playProgress > self.clipTimeView.endValue) {
            [player seekToProgress:self.clipTimeView.startValue];
        }
    }
    self.clipTimeView.value = player.playProgress;
}

- (void)playerEndPlaying:(WZMPlayer *)player {
    [player pause];
    [player seekToProgress:self.clipTimeView.startValue];
    [player play];
}

//导出
- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer {
    NSString *p = [NSString stringWithFormat:@"导出中...%.2f",videoEditer.progress];
    [WZMViewHandle wzm_showProgressMessage:p];
}

- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer {
    if (videoEditer.exportPath) {
        [WZMViewHandle wzm_dismiss];
        NSURL *url = [NSURL fileURLWithPath:videoEditer.exportPath];
        if (url) {
            self.originals = @[url];
            UIImage *image = [UIImage wzm_getImageByUrl:url progress:0.0 original:NO];
            if (image) {
                self.thumbnails = @[image];
            }
        }
        if ([self.delegate respondsToSelector:@selector(albumEditViewController:handleOriginals:thumbnails:assets:)]) {
            [self.delegate albumEditViewController:self handleOriginals:self.originals thumbnails:self.thumbnails assets:self.assets];
        }
    }
    else {
        [WZMViewHandle wzm_showInfoMessage:@"不支持的视频格式"];
    }
}

//改变时间线
- (void)clipView:(WZMClipTimeView *)clipView valueChanged:(WZMCommonState)state {
    if (state == WZMCommonStateBegan) {
        [self.player pause];
    }
    else if (state == WZMCommonStateChanged) {
        [self.player seekToProgress:clipView.value];
    }
    else {
        [self.player play];
    }
    
}

//剪裁尺寸
- (void)scaleView:(WZMAlbumScaleView *)scaleView didChangeScale:(CGFloat)scale {
    self.cropView.WHScale = scale;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.navBarH == 0) {
        self.navBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (self.navBarH == 0) return;
        CGRect rect = self.view.bounds;
        rect.origin.y = (self.navBarH);
        rect.size.height -= (self.navBarH + WZM_BOTTOM_HEIGHT);
        self.contentView.frame = rect;
        CGFloat toolH = 60.0 + (self.type == 0 ? 0.0 : 70.0);
        CGSize size = WZMSizeRatioToMaxSize(self.image.size, CGSizeMake(rect.size.width-10.0, rect.size.height-toolH-10.0));
        CGRect previewRect = CGRectZero;
        previewRect.origin.x = (rect.size.width-size.width)/2.0;
        previewRect.origin.y = (rect.size.height-toolH-size.height)/2.0;
        previewRect.size = size;
        if (self.type == 0) {
            self.imageView.frame = previewRect;
        }
        else {
            self.playerView.frame = previewRect;
        }
        self.cropView.frame = previewRect;
        self.toolView.frame = CGRectMake(0.0, self.contentView.wzm_height-toolH, self.contentView.wzm_width, toolH);
        if (self.scaleView == nil) {
            self.scaleView = [[WZMAlbumScaleView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.contentView.wzm_width, 60.0)];
            self.scaleView.delegate = self;
            [self.toolView addSubview:self.scaleView];
        }
        if (self.type == 1 && self.clipTimeView == nil) {
            self.clipTimeView = [[WZMClipTimeView alloc] initWithFrame:CGRectMake(0.0, self.scaleView.wzm_maxY+5.0, self.contentView.wzm_width, 60.0)];
            self.clipTimeView.delegate = self;
            self.clipTimeView.videoUrl = self.videoUrl;
            self.clipTimeView.foregroundBorderColor = [UIColor brownColor];
            self.clipTimeView.backgroundBorderColor = [UIColor brownColor];
            [self.toolView addSubview:self.clipTimeView];
        }
    }
}

@end
