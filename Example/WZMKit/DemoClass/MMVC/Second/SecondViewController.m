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

@interface SecondViewController ()

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xmhzma" ofType:@"MP4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    WZMVideoKeyView *keyView = [[WZMVideoKeyView alloc] initWithFrame:CGRectMake(0.0, 100.0, 375.0, 60.0)];
    keyView.videoUrl = url;
    [self.view addSubview:keyView];
}

@end
