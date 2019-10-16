//
//  WZMAlbumNavigationController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumNavigationController.h"
#import "WZMAlbumController.h"
#import "WZMLogPrinter.h"

@interface WZMAlbumNavigationController ()

@property (nonatomic, strong) WZMAlbumConfig *config;
@property (nonatomic, assign) BOOL statusHidden;
@property (nonatomic, assign) UIStatusBarStyle statusStyle;

@end

@implementation WZMAlbumNavigationController

- (instancetype)initWithConfig:(WZMAlbumConfig *)config {
    WZMAlbumController *album = [[WZMAlbumController alloc] initWithConfig:config];
    self = [super initWithRootViewController:album];
    if (self) {
        self.config = config;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.statusStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusHidden = [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = self.statusHidden;
    [UIApplication sharedApplication].statusBarStyle = self.statusStyle;
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
