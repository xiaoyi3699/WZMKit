//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMDrawView2.h"

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
    self.view.backgroundColor = [UIColor grayColor];
    
    WZMDrawView2 *drawView = [[WZMDrawView2 alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 500.0)];
    drawView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:drawView];
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
