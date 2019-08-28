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

@interface SecondViewController ()<WZMAlbumControllerDelegate>

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WZMAlbumConfig *config = [WZMAlbumConfig new];
    config.originalImage = NO;
    config.imageSize = CGSizeMake(200, 220);
    config.originalVideo = NO;
    config.allowShowGIF = NO;
    WZMAlbumController *vc = [[WZMAlbumController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumController:(WZMAlbumController *)albumController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

@end
