//
//  ViewController.m
//  Image
//
//  Created by aasjdi dau on 2019/3/27.
//  Copyright © 2019 aasjdi dau. All rights reserved.
//

#import "WZMImageresizerViewController.h"
#import "WZMImageresizerView.h"
#import "WZMAlbumScaleView.h"
#import "WZMMacro.h"

@interface WZMImageresizerViewController ()<WZMAlbumScaleViewDelegate>

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) WZMAlbumScaleView *scaleView;

@property (nonatomic, strong) WZMImageresizerConfigure *configure;
@property (nonatomic, strong) WZMImageresizerView *imageresizerView;

@property (nonatomic, strong) UIImage *resizeImage;
@property (nonatomic, copy) LVImageBlock completionBlock;

@end

#define SC_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SC_HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation WZMImageresizerViewController {
    
}

- (instancetype)initWithImage:(UIImage *)image completion:(LVImageBlock)completion {
    self = [super init];
    if (self) {
        _resizeImage = image;
        _completionBlock = completion;
        self.title = @"图片编辑";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColor:[UIColor whiteColor]];
    if (self.navItemColor == nil) {
        self.navItemColor = [UIColor wzm_getDynamicColor:[UIColor darkTextColor]];
    }
    if (self.themeItemColor == nil) {
        self.themeItemColor = [UIColor colorWithRed:36.0/255.0 green:189.0/255.0 blue:72.0/255.0 alpha:1.0];
    }
    // 注意：iOS11以下的系统，所在的controller最好设置automaticallyAdjustsScrollViewInsets为NO，不然就会随导航栏或状态栏的变化产生偏移
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    CGFloat bottomH = 65.0 + (WZM_IS_iPhoneX ? 34.0 : 0.0);
    CGRect viewFrame = self.view.bounds;
    viewFrame.origin.y = WZM_NAVBAR_HEIGHT;
    viewFrame.size.height -= (WZM_NAVBAR_HEIGHT + bottomH);
    WZMImageresizerConfigure *configure = [WZMImageresizerConfigure defaultConfigureWithResizeImage:_resizeImage make:^(WZMImageresizerConfigure *configure) {
        // 到这里已经有了默认参数值，可以在这里另外设置你想要的参数值（使用了链式编程方式）
        configure.jp_viewFrame(viewFrame).
        jp_maskAlpha(0.9).
        jp_resizeWHScale(0.0).
        jp_strokeColor(self.themeItemColor).
        jp_bgColor([self navigatonBarBackgroundColor]).
        jp_frameType(LVClassicFrameType).
        jp_maskType(LVNormalMaskType).
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
    [self.view addSubview:imageresizerView];
    self.imageresizerView = imageresizerView;
    
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0.0, SC_HEIGHT-60.0, SC_WIDTH, 60.0)];
    [self.view addSubview:self.toolView];
    
    self.scaleView = [[WZMAlbumScaleView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.toolView.wzm_width, 60.0)];
    self.scaleView.delegate = self;
    [self.toolView addSubview:self.scaleView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    leftItem.tintColor = self.navItemColor;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
    rightItem.tintColor = self.themeItemColor;
    
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
        if (self.completionBlock) {
            self.completionBlock(resizeImage);
        }
    }];
}

- (void)scaleView:(WZMAlbumScaleView *)scaleView didChangeScale:(CGFloat)scale {
    [self.imageresizerView setResizeWHScale:scale];
}

//导航栏背景色
- (UIColor *)navigatonBarBackgroundColor {
    return [UIColor wzm_getDynamicColorByLightColor:[UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0] darkColor:WZM_DARK_COLOR];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    if (self.navigationController) {
        UIColor *navBGColor = [self navigatonBarBackgroundColor];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage wzm_getImageByColor:navBGColor] forBarMetrics:UIBarMetricsDefault];
    }
    [self.imageresizerView setBgColor:[self navigatonBarBackgroundColor]];
}

@end
