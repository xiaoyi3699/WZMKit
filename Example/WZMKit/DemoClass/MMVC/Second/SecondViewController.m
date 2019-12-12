//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "ZMCaptionViewController.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumNavigationControllerDelegate>

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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 100, 60)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"导入视频" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
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
