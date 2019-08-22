//
//  FirstViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

/**********************************************************************************/
/* ↓ WZMNetWorking(网络请求)、WZMRefresh(下拉/上拉控件)、WZMJSONParse(JSON解析)的使用 ↓ */
/**********************************************************************************/

#import "FirstViewController.h"
#import "WZMAlbumController.h"
#import "WZMAlbumNavigationController.h"
#import "WZMVideoKeyView.h"
#import "WZMVideoKeyView2.h"

@interface FirstViewController ()<WZMVideoKeyViewDelegate,WZMVideoKeyView2Delegate>

@end

@implementation FirstViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第一页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qnyn_juqing" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    WZMVideoKeyView *view = [[WZMVideoKeyView alloc] initWithFrame:CGRectMake(10, 150, 355, 60)];
    view.delegate = self;
    view.videoUrl = url;
    view.radius = 5;
    [self.view addSubview:view];
    
    WZMVideoKeyView2 *view2 = [[WZMVideoKeyView2 alloc] initWithFrame:CGRectMake(10, 300, 355, 60)];
    view2.delegate = self;
    view2.videoUrl = url;
    view2.radius = 5;
    view2.contentWidth = 1000;
    [self.view addSubview:view2];
}

- (void)videoKeyView:(WZMVideoKeyView *)videoKeyView changeType:(WZMCommonState)type {
    NSLog(@"1==%@====%@",@(type),@(videoKeyView.value));
}

- (void)videoKeyView2:(WZMVideoKeyView2 *)videoKeyView2 changeType:(WZMCommonState)type {
    NSLog(@"2==%@====%@",@(type),@(videoKeyView2.value));
}

@end
