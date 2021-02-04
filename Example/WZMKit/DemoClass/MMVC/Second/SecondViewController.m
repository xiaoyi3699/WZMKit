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
    WZMDrawView *_v;
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
    
    WZMDrawView *v = [[WZMDrawView alloc] initWithFrame:self.view.bounds];
    v.color = [UIColor redColor];
    [self.view addSubview:v];
    _v = v;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 100.0, 50.0, 50.0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"橡皮" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200.0, 100.0, 50.0, 50.0)];
    btn2.tag = 1;
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 setTitle:@"撤销" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        _v.lineWidth = arc4random()%10 + 5;
        _v.eraser = !_v.isEraser;
    }
    else {
        [_v backforward];
    }
}

@end
