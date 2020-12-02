//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4
#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>
#import <opencv2/highgui.hpp>
#import <opencv2/core/operations.hpp>

#import <opencv2/core/core_c.h>
using namespace cv;
using namespace std;

#endif

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
    self.view.backgroundColor = [UIColor grayColor];
    ///720 × 1080
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WZM_SCREEN_WIDTH-720*0.4)/2.0, WZM_NAVBAR_HEIGHT, 720*0.4, 1080*0.4)];
//    imageView.image = [UIImage imageNamed:@"1"];//[self maskImage:[UIImage imageNamed:@"1"] withMask:[UIImage imageNamed:@"3"]];
//    [self.view addSubview:imageView];
    
    CALayer *bgLayer = [CALayer layer];
    bgLayer.frame = WZMRectMiddleArea();
    bgLayer.contents = (__bridge id)([UIImage imageNamed:@"1"].CGImage);
    [self.view.layer addSublayer:bgLayer];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bgLayer.bounds];
    UIBezierPath *cropPath = [UIBezierPath bezierPathWithRect:bgLayer.bounds];
    [path appendPath:cropPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleNonZero;
    layer.contents = (__bridge id)([UIImage imageNamed:@"2"].CGImage);
    bgLayer.mask = layer;
}

- (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef maskRef = maskImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef sourceImage = [image CGImage];
    CGImageRef imageWithAlpha = sourceImage;
    //add alpha channel for images that don't have one (ie GIF, JPEG, etc...)
    //this however has a computational cost
    if (CGImageGetAlphaInfo(sourceImage) == kCGImageAlphaNone) {
//        imageWithAlpha =CopyImageAndAddAlphaChannel(sourceImage);
    }
    
    CGImageRef masked = CGImageCreateWithMask(imageWithAlpha, mask);

    CGImageRelease(mask);
    
        if (sourceImage != imageWithAlpha) {
            CGImageRelease(imageWithAlpha);
        }
    UIImage* retImage = [UIImage imageWithCGImage:masked];
    CGImageRelease(masked);
    
    return retImage;
}

@end
