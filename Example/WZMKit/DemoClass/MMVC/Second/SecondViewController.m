//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMCropView.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()

@property (nonatomic, strong) UIImageView *imageView;

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
    
    WZMCropView *cropView = [[WZMCropView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 355.0)];
    //cropView.WHScale = 0.5;
    cropView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:cropView];
    
    WZMDispatch_after(0.5, ^{
        cropView.WHScale = 1.0;
    });
}

@end
