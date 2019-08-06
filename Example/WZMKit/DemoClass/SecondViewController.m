//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "ScannerViewController.h"
#import "WZMAlbumBrowserController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMPlayerDelegate> {
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
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    WZMAlbumBrowserController *vc = [[WZMAlbumBrowserController alloc] init];
    vc.albumFrame = WZMRectMiddleArea();
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)playerLoadProgress:(WZMPlayer *)player {
    NSLog(@"===%@",@(player.loadProgress));
}

@end
