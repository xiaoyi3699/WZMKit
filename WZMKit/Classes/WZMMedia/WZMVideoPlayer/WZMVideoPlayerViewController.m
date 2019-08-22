//
//  WZMVideoPlayerViewController.m
//  WZMFoundation
//
//  Created by zhaomengWang on 2017/4/14.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMVideoPlayerViewController.h"
#import "WZMVideoPlayerView.h"

@interface WZMVideoPlayerViewController (){
    NSURL          *_videoUrl;
    WZMVideoPlayerView *_playerView;
}

@end

@implementation WZMVideoPlayerViewController

- (instancetype)initWithVideoUrl:(NSURL *)videoUrl {
    self = [super init];
    if (self) {
        _videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _playerView = [[WZMVideoPlayerView alloc] initWithFrame:self.view.bounds];
    [_playerView playWithUrl:_videoUrl];
    [self.view addSubview:_playerView];
}

- (UIInterfaceOrientationMask)wzm_supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait|
    UIInterfaceOrientationMaskLandscapeLeft|
    UIInterfaceOrientationMaskLandscapeRight;
}

//隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
