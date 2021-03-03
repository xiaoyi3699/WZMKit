//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    WZMMosaicView *_mskView;
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
    self.view.backgroundColor = [UIColor grayColor];
    
    WZMMosaicView *mskView = [[WZMMosaicView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 500.0)];
    mskView.image = [UIImage imageNamed:@"meinv"];
    [self.view addSubview:mskView];
    _mskView = mskView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 100.0, 50.0, 40.0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"撤销" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)btn {
    [_mskView backforward];
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
