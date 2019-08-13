//
//  WZMAlbumNavigationController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMAlbumNavigationController.h"
#import "WZMAlbumController.h"

@interface WZMAlbumNavigationController ()

@property (nonatomic, strong) WZMAlbumConfig *config;

@end

@implementation WZMAlbumNavigationController

- (instancetype)initWithConfig:(WZMAlbumConfig *)config {
    WZMAlbumController *album = [[WZMAlbumController alloc] initWithConfig:config];
    self = [super initWithRootViewController:album];
    if (self) {
        self.config = config;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)dealloc {
    WZMLog(@"%@释放了",NSStringFromClass(self.class));
}

@end
