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
    
    for (NSInteger i = 0; i < 2; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0+i*100.0, 64, 100.0, 50.0)];
        btn.tag = i;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitle:@"hhaah" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    _drawViews = [[NSMutableArray alloc] init];
    CGRect rect = CGRectMake(10.0, 100.0, WZM_SCREEN_WIDTH-20.0, 355.0);
    _bgView = [[UIView alloc] initWithFrame:rect];
    _bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_bgView];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        static BOOL huabi = YES;
        if (huabi) {
            WZMDrawView *drawView = [[WZMDrawView alloc] initWithFrame:_bgView.bounds];
            [_bgView addSubview:drawView];
            [_drawViews addObject:drawView];
        }
        else {
            WZMPasterView *pasterView = [[WZMPasterView alloc] initWithFrame:_bgView.bounds];
            [_bgView addSubview:pasterView];
            [_drawViews addObject:pasterView];
        }
        huabi = !huabi;
    }
    else {
        
    }
}

@end
