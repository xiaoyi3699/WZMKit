//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WTRotateView.h"
#import "WZMImageDrawView.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    UIScrollView *_bgView;
    UIImageView *_imageView2;
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100.0, 150.0, 150.0, 300.0)];
    view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:view];
    
    WTRotateView *rv = [[WTRotateView alloc] initWithFrame:CGRectMake(120.0, 270.0, 30.0, 30.0)];
    rv.backgroundColor = [UIColor redColor];
    [view addSubview:rv];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
