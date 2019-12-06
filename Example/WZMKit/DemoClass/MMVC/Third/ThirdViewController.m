//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()<UITextFieldDelegate>

@end

@implementation ThirdViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第三页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"666.gif" ofType:nil];
    WZMGifImageView *gifView = [[WZMGifImageView alloc] initWithFrame:CGRectMake(10, 100, 200, 200)];
    gifView.gifData = [[NSData alloc] initWithContentsOfFile:path];
    [self.view addSubview:gifView];
    [gifView startGif];
}

@end
