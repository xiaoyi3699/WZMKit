//
//  WZMViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMViewController.h"
#import <WZMKit/WZMKit.h>

@interface WZMViewController ()<WZMPlayerDelegate> {
    WZMPlayer *player;
    WZMPlayerView *playerView;
}

@end

@implementation WZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    playerView = [[WZMPlayerView alloc] initWithFrame:CGRectMake(0, 100, WZM_SCREEN_WIDTH, 300)];
    playerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:playerView];
    
    player = [[WZMPlayer alloc] init];
    player.delegate = self;
//    player.playerView = playerView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
//    NSURL *url = [NSURL fileURLWithPath:path];
//    [player playWithURL:url];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_qnyn" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [player playWithURL:url];
    
//    WZMVideoPlayerViewController *vc = [[WZMVideoPlayerViewController alloc] initWithVideoUrl:url];
//    [self presentViewController:vc animated:YES completion:nil];
}

- (void)playerLoadSuccess:(WZMPlayer *)player {
    NSLog(@"音频加载成功");
}
- (void)playerLoadFailed:(WZMPlayer *)player error:(NSString *)error {
    NSLog(@"音频加载失败");
}
- (void)playerLoadProgress:(WZMPlayer *)player {
    NSLog(@"音频加载进度:%@",@(player.loadProgress));
}
- (void)playerBeginPlaying:(WZMPlayer *)player {
    NSLog(@"音频开始播放总时间:%@",@(player.duration));
}
- (void)playerPlaying:(WZMPlayer *)player {
    NSLog(@"音频播放进度:%@,当前时间:%@",@(player.playProgress),@(player.currentTime));
}
- (void)playerEndPlaying:(WZMPlayer *)player {
    NSLog(@"音频结束播放");
}
- (void)playerChangeStatus:(WZMPlayer *)player {
    NSLog(@"音频播放状态改变:%@",(player.isPlaying ? @"播放" : @"暂停"));
}

//NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
//NSURL *url = [NSURL fileURLWithPath:path];
//[player playWithURL:url];

@end
