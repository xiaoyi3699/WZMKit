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

@end

@implementation WZMAlbumNavigationController

- (instancetype)init {
    self = [super initWithRootViewController:[[WZMAlbumController alloc] init]];
    if (self) {
        self.column = 4;
        self.autoDismiss = YES;
        self.allowPreview = NO;
        self.allowShowGIF = NO;
        self.allowShowImage = YES;
        self.allowShowVideo = YES;
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
