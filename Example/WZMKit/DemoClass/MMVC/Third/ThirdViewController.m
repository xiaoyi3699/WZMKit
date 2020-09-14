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
    UIImageView *_imageView;
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
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 355.0)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.maxCount = 1;
    config.allowEdit = YES;
    config.allowPreview = NO;
    WZMAlbumNavigationController *albumNav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    albumNav.pickerDelegate = self;
    [self presentViewController:albumNav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    _imageView.image = originals.firstObject;
}

@end
