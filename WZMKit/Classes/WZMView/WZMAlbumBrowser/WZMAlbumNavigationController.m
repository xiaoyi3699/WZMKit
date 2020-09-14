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
#import "WZMDefined.h"

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
#if WZM_APP
    self.statusStyle = [UIApplication sharedApplication].statusBarStyle;
    self.statusHidden = [UIApplication sharedApplication].statusBarHidden;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#if WZM_APP
    [UIApplication sharedApplication].statusBarHidden = self.statusHidden;
    [UIApplication sharedApplication].statusBarStyle = self.statusStyle;
#endif
}

@end
