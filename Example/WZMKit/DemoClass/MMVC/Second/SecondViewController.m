//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMIAPManager.h"
#import "WZMMenuView.h"
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
    
    WZMMenuView *menuView = [[WZMMenuView alloc] initWithFrame:CGRectMake(0.0, 100.0, WZM_SCREEN_WIDTH, 300.0)];
    menuView.backgroundColor = [UIColor redColor];
    menuView.titles = @[@"阿迪王大无",@"带娃",@"带娃大无大无大",@"吊袜带哇",@"带娃大无",@"",@"带娃",@"打完大无哇无",@"我打到无",@"打到我",@"吊袜带哇奥无",@"大娃娃大哇多哇",];
    [self.view addSubview:menuView];
}

@end
