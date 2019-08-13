//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMAlbumController.h"
#import "WZMAlbumNavigationController.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate> {
    WZMPlayer *player;
}

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
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.allowPreview = NO;
    config.maxCount = 1;
    
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
//    WZMAlbumController *vc = [[WZMAlbumController alloc] initWithConfig:config];
//    vc.pickerDelegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

- (void)albumController:(WZMAlbumController *)albumController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

@end
