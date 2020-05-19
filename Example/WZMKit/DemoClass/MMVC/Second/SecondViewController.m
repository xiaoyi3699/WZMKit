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
    
//    WZMCropView *cropView = [[WZMCropView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 355.0)];
//    cropView.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:cropView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100.0, 100.0, 200.0, 200.0)];
    self.imageView.image = [UIImage imageNamed:@"tabbar_icon_on"];
    [self.view addSubview:self.imageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [UIView transitionWithView:self.view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.imageView.image = [UIImage imageNamed:@"tabbar_icon"];
    } completion:^(BOOL finished) {
        
    }];
}

@end
