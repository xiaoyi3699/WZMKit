//
//  WZMViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMViewController.h"
#import <WZMKit/WZMKit.h>

@interface WZMViewController ()<WZMAudioPlayerDelegate,UITableViewDelegate,UITableViewDataSource> {
    WZMAudioPlayer *player;
    UITableView *tableView;
}

@end

@implementation WZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    tableView.delegate = self;
    tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:tableView];
    
    tableView.wzm_header = [WZMRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(header)];
    tableView.wzm_footer = [WZMRefreshFooterView footerWithRefreshingTarget:self refreshingAction:@selector(footer)];
    
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    view.backgroundColor = [UIColor redColor];
//    [self.view addSubview:view];
//
//    player = [[WZMAudioPlayer alloc] init];
//    player.delegate = self;
//    WZMDispatch_after(1, ^{
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
//        NSURL *url = [NSURL fileURLWithPath:path];
//        [player playWithURL:url];
//    });
//
//    @wzm_weakify(player);
//    [self.view wzm_executeGesture:^(UIView *view_, WZMGestureRecognizerType gesture_) {
//        @wzm_strongify(player);
//        if (gesture_ == WZMGestureRecognizerTypeSingle) {
//            [player seekToProgress:0.9];
//        }
//        else {
//            [player play];
//        }
//    }];
}

- (void)header {
    WZMDispatch_after(1, ^{
        [tableView.wzm_header endRefresh];
        [tableView.wzm_footer endRefresh];
    });
}

- (void)footer {
    WZMDispatch_after(1, ^{
        [tableView.wzm_header endRefresh];
        [tableView.wzm_footer endRefresh];
    });
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self presentViewController:[WZMViewController new] animated:YES completion:nil];
    
    WZMDispatch_after(5, ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    return cell;
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
