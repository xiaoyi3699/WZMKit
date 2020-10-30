//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMMosaicView.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMVideoEditerDelegate,WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) WZMVideoEditer *videoEditer;

@end

@implementation SecondViewController {
    UIView *_bgView;
    NSMutableArray *_drawViews;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    for (NSInteger i = 0; i < 2; i ++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0+i*100.0, 64, 100.0, 50.0)];
//        btn.tag = i;
//        btn.titleLabel.font = [UIFont systemFontOfSize:15];
//        [btn setTitle:@"hhaah" forState:UIControlStateNormal];
//        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:btn];
//    }
    
    UIImage *image = [UIImage imageNamed:@"meinv"];
    WZMMosaicView *mscView = [[WZMMosaicView alloc] initWithFrame:CGRectMake(0.0, 64.0, 375.0, 375.0)];
    mscView.image = image;
    mscView.type = WZMMosaicViewTypeBlur;
    [self.view addSubview:mscView];
}

- (void)btnClick:(UIButton *)btn {
    
}

@end
