//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"
#import "WZMAlertQueue.h"
#import <Photos/Photos.h>
@interface ThirdViewController ()<WZMAlbumNavigationControllerDelegate>

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    WZMAlbumNavigationController *albumNav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    albumNav.pickerDelegate = self;
    [self presentViewController:albumNav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    
}

@end
