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


@property (nonatomic, strong) WZMPasterView *stageView;

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
    
    self.stageView = [[WZMPasterView alloc] init];
    self.stageView.frame = CGRectMake((375-220)/2, 150, 220, 260);
    [self.view addSubview:self.stageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.stageView addPasterWithImg:[UIImage imageNamed:@"tabbar_icon_on"]];
}
@end
