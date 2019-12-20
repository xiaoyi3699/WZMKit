//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "ZMCaptionViewController.h"
#import "WZMTextLayer.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumNavigationControllerDelegate,WZMVideoKeyView2Delegate>

@end

@implementation SecondViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"床前明月光";
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor redColor];
    shadow.shadowOffset = CGSizeMake(1, 1);
    shadow.shadowBlurRadius = 1.0;

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20]} range:NSMakeRange(0, str.length)];
    
    WZMTextLayer *textLayer = [WZMTextLayer layer];
    textLayer.string = attStr;
    textLayer.font = (__bridge CFTypeRef _Nullable)([UIFont systemFontOfSize:20]);
    textLayer.fontSize = 20;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.frame = CGRectMake(10, 100, 150, 30);
    textLayer.foregroundColor = [UIColor blueColor].CGColor;
    textLayer.backgroundColor = [UIColor clearColor].CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.wrapped = YES;
    [self.view.layer addSublayer:textLayer];
    
    NSArray *values = @[(id)[UIColor blueColor].CGColor,(id)[UIColor blueColor].CGColor];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = textLayer.frame;
    gradientLayer.colors = values;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.contentsScale = [UIScreen mainScreen].scale;
    gradientLayer.mask = textLayer;
    textLayer.frame = gradientLayer.bounds;
    [self.view.layer addSublayer:gradientLayer];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"导入视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"xmhzma" ofType:@"MP4"];
    WZMVideoKeyView2 *keyView = [[WZMVideoKeyView2 alloc] initWithFrame:CGRectMake(10, 200, 330, 60)];
    keyView.delegate = self;
    keyView.videoUrl = [NSURL fileURLWithPath:file];
    keyView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:keyView];
}

- (void)videoKeyView2:(WZMVideoKeyView2 *)videoKeyView2 changeType:(WZMCommonState)type {
    if (type == WZMCommonStateBegan) {
        NSLog(@"000000000");
    }
    else if (type == WZMCommonStateChanged) {
        NSLog(@"111111111");
    }
    else {
        NSLog(@"222222222");
    }
    NSLog(@"====%@",@(videoKeyView2.value));
}

- (void)btnClick:(UIButton *)btn {
    WZMAlbumConfig *config = [WZMAlbumConfig new];
    config.originalVideo = YES;
    config.originalImage = YES;
    config.allowShowGIF = YES;
    config.maxCount = 1;
    config.allowPreview = YES;
    config.allowDragSelect = NO;
    config.allowShowImage = NO;
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    NSURL *videoUrl = originals.firstObject;;
    if ([videoUrl isKindOfClass:[NSURL class]] == NO) return;
    ZMCaptionViewController *captionVC = [[ZMCaptionViewController alloc] initWithVideoUrl:videoUrl];
    captionVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:captionVC animated:YES];
}

@end
