//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "ScannerViewController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMPlayerDelegate> {
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
    self.view.backgroundColor = [UIColor whiteColor];
    
    WZMPlayerView *view = [[WZMPlayerView alloc] initWithFrame:CGRectMake(0, 64, WZM_SCREEN_WIDTH, 400)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    player = [[WZMPlayer alloc] init];
    player.delegate = self;
    player.playerView = view;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [player playWithURL:[NSURL URLWithString:@"http://sqb.gudaomoni.com/kdtest.mp4"]];
}

- (void)playerLoadProgress:(WZMPlayer *)player {
    NSLog(@"===%@",@(player.loadProgress));
}

@end
