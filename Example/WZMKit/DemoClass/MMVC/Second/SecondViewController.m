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
    
    self.view.backgroundColor = [UIColor grayColor];
    
    WZMMosaicView *v = [[WZMMosaicView alloc] initWithFrame:CGRectMake(10.0, 100.0, 200.0, 200.0)];
    v.image = [UIImage imageNamed:@"meinv"];
    v.type = WZMMosaicViewTypeCodeMosaic;
    [self.view addSubview:v];
}

@end
