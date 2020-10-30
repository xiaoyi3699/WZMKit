//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMMosaicView.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMVideoEditerDelegate,WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) WZMVideoEditer *videoEditer;
@property (nonatomic, strong) WZMMosaicView *mscView;

@end

@implementation SecondViewController {
    UIView *_bgView;
    NSMutableArray *_drawViews;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0+i*100.0, 500, 100.0, 50.0)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:@"hhaah" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    UIImage *image = [UIImage imageNamed:@"meinv"];
    WZMMosaicView *mscView = [[WZMMosaicView alloc] initWithFrame:CGRectMake(0.0, 64.0, 375.0, 375.0)];
    mscView.image = image;
    mscView.type = WZMMosaicViewTypeMosaic;
    [self.view addSubview:mscView];
    self.mscView = mscView;
    
    WZMDispatch_after(3.0, ^{
        mscView.type = WZMMosaicViewTypeBlur;
    });
    
    WZMDispatch_after(6.0, ^{
        mscView.type = WZMMosaicViewTypeSepia;
    });
    
//    UIImage *image = [UIImage imageNamed:@"meinv"];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 64.0, 375.0, 375.0)];
//    imageView.image = image;
//    [self.view addSubview:imageView];
//
//    //生成马赛克
//    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
//    CIFilter *filter = [CIFilter filterWithName:@"CIPixellate"];
//    [filter setValue:ciImage  forKey:kCIInputImageKey];
//    //马赛克像素大小
//    [filter setValue:@(30) forKey:kCIInputScaleKey];
//    CIImage *outImage = [filter valueForKey:kCIOutputImageKey];
//
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef cgImage = [context createCGImage:outImage fromRect:[outImage extent]];
//    UIImage *showImage = [UIImage imageWithCGImage:cgImage];
//    CGImageRelease(cgImage);
//
//    imageView.image = showImage;
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        [self.mscView backforward];
    }
    else {
        [self.mscView recover];
    }
}

@end
