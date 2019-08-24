//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<UIScrollViewDelegate,WZMVideoKeyView2Delegate>

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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qnyh" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    WZMVideoKeyView *view1 = [[WZMVideoKeyView alloc] initWithFrame:CGRectMake(10, 150, 355, 60)];
    view1.videoUrl = url;
    [self.view addSubview:view1];
    
    WZMVideoKeyView2 *view2 = [[WZMVideoKeyView2 alloc] initWithFrame:CGRectMake(10, 300, 355, 60)];
    view2.videoUrl = url;
    view2.contentWidth = 999;
    view2.delegate = self;
    [self.view addSubview:view2];
}

- (void)videoKeyView2:(WZMVideoKeyView2 *)videoKeyView2 changeType:(WZMCommonState)type {
    NSLog(@"%@==%@",@(videoKeyView2.value),@(type));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    WZMAlbumController *nav = [[WZMAlbumController alloc] initWithConfig:[WZMAlbumConfig new]];
//    [self.navigationController pushViewController:nav animated:YES];
}

@end
