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

@interface FirstViewController ()<WZMPlayerDelegate>

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    WZMAlbumController *al = [[WZMAlbumController alloc] initWithConfig:[WZMAlbumConfig new]];
    [self.navigationController pushViewController:al animated:YES];
}

@end
