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

@interface WZMAlbumEditViewController ()<WZMAlbumScaleViewDelegate>

@property (nonatomic, assign) CGFloat navBarH;
@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, strong) NSArray *thumbnails;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WZMCropView *cropView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WZMAlbumScaleView *scaleView;

@end

@implementation WZMAlbumEditViewController

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    self = [super init];
    if (self) {
        self.title = @"图片编辑";
        self.originals = originals;
        self.thumbnails = thumbnails;
        self.assets = assets;
        self.image = originals.firstObject;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:[UIColor blackColor]];
    
    self.contentView = [[UIView alloc] init];
    [self.view addSubview:self.contentView];
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.image = self.originals.firstObject;
    [self.contentView addSubview:self.imageView];
    
    self.cropView = [[WZMCropView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.cropView];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
//    leftItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor blueColor] darkColor:[UIColor whiteColor]];
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick)];
//    rightItem.tintColor = [UIColor wzm_getDynamicColorByLightColor:WZM_ALBUM_COLOR darkColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)leftItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClick {
    //图片缩放比例
    if (self.image == nil) return;
    CGFloat scale = self.image.size.width/self.imageView.wzm_width;
    CGRect rect = [self.cropView convertRect:self.cropView.cropFrame toView:self.imageView];
    rect.origin.x *= scale;
    rect.origin.y *= scale;
    rect.size.width *= scale;
    rect.size.height *= scale;
    UIImage *image = [self.image wzm_clipImageWithRect:rect];
    if ([self.delegate respondsToSelector:@selector(albumEditViewController:handleOriginals:thumbnails:assets:)]) {
        [self.delegate albumEditViewController:self handleOriginals:@[image] thumbnails:nil assets:nil];
    }
}

- (void)scaleView:(WZMAlbumScaleView *)scaleView didChangeScale:(CGFloat)scale {
    self.cropView.WHScale = scale;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.navBarH == 0) {
        self.navBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (self.navBarH == 0) return;
        CGRect rect = self.view.bounds;
        rect.origin.x = 10.0;
        rect.origin.y = (self.navBarH + 10.0);
        rect.size.height -= (self.navBarH + 20.0 + WZM_BOTTOM_HEIGHT);
        rect.size.width -= 20.0;
        self.contentView.frame = rect;
        CGFloat scaleH = 60.0;
        CGSize size = WZMSizeRatioToMaxSize(self.image.size, CGSizeMake(rect.size.width, rect.size.height-scaleH-10.0));
        CGRect imageRect = CGRectZero;
        imageRect.origin.x = (rect.size.width-size.width)/2.0;
        imageRect.origin.y = (rect.size.height-scaleH-size.height)/2.0;
        imageRect.size = size;
        self.imageView.frame = imageRect;
        self.cropView.frame = imageRect;
        if (self.scaleView == nil) {
            self.scaleView = [[WZMAlbumScaleView alloc] initWithFrame:CGRectMake(0.0, self.contentView.wzm_height-scaleH, self.contentView.wzm_width, scaleH)];
            self.scaleView.delegate = self;
            [self.contentView addSubview:self.scaleView];
        }
    }
}

@end
