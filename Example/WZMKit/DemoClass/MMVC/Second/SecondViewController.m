//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMPasterView.h"

//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMPasterViewDelegate>


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
    
    self.stageView = [[WZMPasterView alloc] initWithFrame:CGRectMake((375-220)/2, 150, 220, 260)] ;
    self.stageView.originImage = [UIImage imageNamed:@"tabbar_icon_on"];
    self.stageView.backgroundColor = [UIColor whiteColor];
    self.stageView.delegate = self;
    [self.view addSubview:self.stageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.stageView addPasterWithImg:[UIImage imageNamed:@"tabbar_icon_on"]];
}

#pragma mark -- WZMPasterViewDelegate

- (void)stickerTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.stageView.clipsToBounds = NO;
}
- (void)stickerTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.stageView.clipsToBounds = NO;
}
- (void)stickerTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.stageView.clipsToBounds = YES;
}
- (void)stickerTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)m_filterPaster:(WZMPasterItemView *)m_filterPaster
{
    
}

@end
