//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"
#import "WZMShadowLabel.h"
#import "WZMShadowLayer.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController {
    WZMShadowLabel *_shadowLabel;
    WZMShadowLayer *_shadowLayer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第三页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _shadowLabel = [[WZMShadowLabel alloc] init];
    _shadowLabel.frame = CGRectMake(100, 100, 200, 60);
    _shadowLabel.text = @"挨打的哇大无无无";
    _shadowLabel.strokeWidth = 10.0;
    _shadowLabel.strokeColor = [UIColor redColor];
    _shadowLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_shadowLabel];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSMutableAttributedString *attStr;
    _shadowLabel.strokeColor = [UIColor greenColor];
}

@end
