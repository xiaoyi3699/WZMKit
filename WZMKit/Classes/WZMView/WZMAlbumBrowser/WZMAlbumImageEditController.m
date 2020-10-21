//
//  ViewController.m
//  Image
//
//  Created by aasjdi dau on 2019/3/27.
//  Copyright © 2019 aasjdi dau. All rights reserved.
//

#import "WZMAlbumImageEditController.h"
#import "WZMImageresizerView.h"
#import "WZMAlbumScaleView.h"
#import "WZMMacro.h"
#import "UIView+wzmcate.h"
#import "UIColor+wzmcate.h"
#import "UIImage+wzmcate.h"
#import "WZMAlbumConfig.h"

@interface WZMAlbumImageEditController ()<WZMAlbumScaleViewDelegate>

@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, strong) NSArray *thumbnails;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) WZMAlbumConfig *config;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) WZMAlbumScaleView *scaleView;

@property (nonatomic, strong) WZMImageresizerConfigure *configure;
@property (nonatomic, strong) WZMImageresizerView *imageresizerView;

@property (nonatomic, strong) UIImage *resizeImage;

@end

@implementation WZMAlbumImageEditController

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets config:(WZMAlbumConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        self.title = @"图片剪裁";
        self.originals = originals;
        self.thumbnails = thumbnails;
        self.assets = assets;
        self.resizeImage = self.originals.firstObject;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColor:[UIColor whiteColor]];
    
    CGRect rect = self.view.bounds;
    rect.origin.y = WZM_NAVBAR_HEIGHT;
    rect.size.height -= (WZM_NAVBAR_HEIGHT);
    self.contentView = [[UIView alloc] initWithFrame:rect];
    [self.view addSubview:self.contentView];
    
    CGFloat bottomH = 60.0 + (WZM_IS_iPhoneX ? 34.0 : 0.0);
    CGRect viewFrame = self.contentView.bounds;
    viewFrame.size.height -= bottomH;
    
    WZMImageresizerConfigure *configure = [WZMImageresizerConfigure defaultConfigureWithResizeImage:_resizeImage make:^(WZMImageresizerConfigure *configure) {
        // 到这里已经有了默认参数值，可以在这里另外设置你想要的参数值（使用了链式编程方式）
        configure.jp_viewFrame(viewFrame).
        jp_maskAlpha(0.8).
        jp_resizeWHScale(0.0).
        jp_strokeColor(self.config.themeColor).
        jp_bgColor([self navigatonBarBackgroundColor]).
        jp_frameType(WZMClassicFrameType).
        jp_maskType(WZMNormalMaskType).
        jp_contentInsets(UIEdgeInsetsMake(0, 0, 0, 0)).
        jp_isClockwiseRotation(YES).
        jp_animationCurve(WZMAnimationCurveEaseOut);
    }];
    self.configure = configure;
    
    WZMImageresizerView *imageresizerView = [WZMImageresizerView imageresizerViewWithConfigure:self.configure imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        // 可在这里监听到是否可以重置
        // 如果不需要重置（isCanRecovery为NO），可在这里做相应处理，例如将重置按钮设置为不可点或隐藏
        // 具体操作可参照Demo
        // 注意循环引用
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        // 可在这里监听到裁剪区域是否预备缩放至适合范围
        // 如果预备缩放（isPrepareToScale为YES），此时裁剪、旋转、镜像功能不可用，可在这里做相应处理，例如将对应按钮设置为不可点或隐藏
        // 具体操作可参照Demo
        // 注意循环引用
    }];
    imageresizerView.backgroundColor = [self navigatonBarBackgroundColor];
    // 添加到视图上
    self.contentView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:imageresizerView];
    self.imageresizerView = imageresizerView;
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.contentView.wzm_height-bottomH, WZM_SCREEN_WIDTH, bottomH)];
    [self.contentView addSubview:self.toolView];
    
    self.scaleView = [[WZMAlbumScaleView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.toolView.wzm_width, 60.0)];
    self.scaleView.delegate = self;
    [self.toolView addSubview:self.scaleView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = self.config.navItemColor;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = self.config.themeColor;
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick {
    @wzm_weakify(self);
    [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
        @wzm_strongify(self);
        if (resizeImage == nil) {
            resizeImage = self.originals.firstObject;
        }
        UIImage *thumImage = [resizeImage wzm_getScaleImage];
        if ([self.delegate respondsToSelector:@selector(albumImageEditController:handleOriginals:thumbnails:assets:)]) {
            [self.delegate albumImageEditController:self handleOriginals:@[resizeImage] thumbnails:@[thumImage] assets:self.assets];
        }
    }];
}

//改变比例
- (void)scaleView:(WZMAlbumScaleView *)scaleView didChangeScale:(CGFloat)scale {
    [self.imageresizerView setResizeWHScale:scale];
}

//导航栏背景色
- (UIColor *)navigatonBarBackgroundColor {
    return [UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] darkColor:WZM_DARK_COLOR];
}

//暗黑切换
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [self.imageresizerView setBgColor:[self navigatonBarBackgroundColor]];
}

@end
