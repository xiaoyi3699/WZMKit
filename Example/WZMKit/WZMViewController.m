//
//  WZMViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMViewController.h"
#import <WZMKit/WZMKit.h>

@interface WZMViewController ()<WZMAudioPlayerDelegate> {
    WZMAudioPlayer *player;
}

@end

@implementation WZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
	
    player = [[WZMAudioPlayer alloc] init];
    player.delegate = self;
    WZMDispatch_after(1, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
        NSURL *url = [NSURL fileURLWithPath:path];
        [player playWithURL:url];
    });
    
    @wzm_weakify(player);
    [self.view wzm_executeGesture:^(UIView *view_, WZMGestureRecognizerType gesture_) {
        @wzm_strongify(player);
        if (gesture_ == WZMGestureRecognizerTypeSingle) {
            [player seekToProgress:0.9];
        }
        else {
            [player play];
        }
    }];
}

- (void)audioPlayerLoadSuccess:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频加载成功");
}
- (void)audioPlayerLoadFailed:(WZMAudioPlayer *)audioPlayer error:(NSString *)error {
    NSLog(@"音频加载失败");
}
- (void)audioPlayerLoadProgress:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频加载进度:%@",@(audioPlayer.loadProgress));
}
- (void)audioPlayerBeginPlaying:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频开始播放总时间:%@",@(audioPlayer.duration));
}
- (void)audioPlayerPlaying:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频播放进度:%@,当前时间:%@",@(audioPlayer.playProgress),@(audioPlayer.currentTime));
}
- (void)audioPlayerEndPlaying:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频结束播放");
}
- (void)audioPlayerChangeStatus:(WZMAudioPlayer *)audioPlayer {
    NSLog(@"音频播放状态改变:%@",(audioPlayer.isPlaying ? @"播放" : @"暂停"));
}

//NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_qnyn" ofType:@"mp4"];
//NSURL *url = [NSURL fileURLWithPath:path];
//WZMVideoPlayerViewController *vc = [[WZMVideoPlayerViewController alloc] initWithVideoUrl:url];
//[self presentViewController:vc animated:YES completion:nil];

//NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
//NSURL *url = [NSURL fileURLWithPath:path];
//[player playWithURL:url];

@end
