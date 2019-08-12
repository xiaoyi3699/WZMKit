//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMAlbumNavigationController.h"

#import "WZMAlbumHelper.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumNavigationControllerDelegate> {
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
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] init];
    vc.pickerDelegate = self;
    vc.minCount = 5;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

@end
