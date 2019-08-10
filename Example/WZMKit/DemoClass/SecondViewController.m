//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMAlbumBrowserController.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMPlayerDelegate,WZMClipTimeViewDelegate> {
    WZMPlayer *player;
}

@property (nonatomic, strong) WZMDownloader *downloader;

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
    WZMAlbumBrowserController *vc = [[WZMAlbumBrowserController alloc] init];
    vc.albumFrame = CGRectMake(0, WZM_NAVBAR_HEIGHT, WZM_SCREEN_WIDTH, WZM_SCREEN_HEIGHT-WZM_NAVBAR_HEIGHT-WZM_TABBAR_HEIGHT);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
