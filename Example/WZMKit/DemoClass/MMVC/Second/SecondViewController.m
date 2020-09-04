//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMVideoEditer.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMVideoEditerDelegate,WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) WZMVideoEditer *videoEditer;

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
    
    self.videoEditer = [[WZMVideoEditer alloc] init];
    self.videoEditer.loop2 = YES;
    self.videoEditer.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    [self.videoEditer handleVideoWithPath:[originals.firstObject path] otherPath:[originals.lastObject path]];
}

- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer {
    NSLog(@"%@",@(videoEditer.progress));
}

- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer {
    if (videoEditer.exportPath) {
        NSURL *url = [NSURL fileURLWithPath:videoEditer.exportPath];
        WZMVideoPlayerViewController *vc = [[WZMVideoPlayerViewController alloc] initWithVideoUrl:url];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
