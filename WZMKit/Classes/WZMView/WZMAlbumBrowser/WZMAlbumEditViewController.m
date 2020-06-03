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

@interface WZMAlbumEditViewController ()

@property (nonatomic, assign) CGFloat navBarH;
@property (nonatomic, strong) NSArray *originals;
@property (nonatomic, strong) NSArray *thumbnails;
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) WZMCropView *cropView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WZMAlbumEditViewController

- (instancetype)initWithOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    self = [super init];
    if (self) {
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
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (self.navBarH == 0) {
        self.navBarH = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if (self.navBarH == 0) return;
        CGRect rect = self.view.bounds;
        rect.origin.x = 10.0;
        rect.origin.y = (self.navBarH + 10.0);
        rect.size.height -= (self.navBarH + 20.0);
        rect.size.width -= 20.0;
        self.contentView.frame = rect;
        CGSize size = WZMSizeRatioToMaxSize(self.image.size, rect.size);
        rect.origin.x = (rect.size.width-size.width)/2.0;
        rect.origin.y = (rect.size.height-size.height)/2.0;
        rect.size = size;
        
        self.imageView.frame = rect;
        self.cropView.frame = rect;
    }
}

@end
