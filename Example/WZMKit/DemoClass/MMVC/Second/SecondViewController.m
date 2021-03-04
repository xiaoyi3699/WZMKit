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
    
    WZMMoreEditView *mskView = [[WZMMoreEditView alloc] initWithFrame:CGRectMake(10.0, 100.0, 370.0, 500.0)];
    mskView.contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:mskView];
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
