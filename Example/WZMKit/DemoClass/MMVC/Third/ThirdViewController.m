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
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 200.0, 100.0, 50.0)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitle:@"hhaah" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick:(UIButton *)btn {
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.maxCount = 1;
    config.allowEdit = YES;
    config.allowPreview = NO;
//    config.originalVideo = NO;
    WZMAlbumNavigationController *albumNav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    albumNav.pickerDelegate = self;
    [self presentViewController:albumNav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    id obj = [originals firstObject];
    if ([obj isKindOfClass:[UIImage class]]) {
        [WZMAlbumHelper wzm_saveImage:obj completion:^(NSError *error) {
            NSLog(@"===%@",error);
        }];
    }
    else if ([obj isKindOfClass:[NSURL class]]){
        [WZMAlbumHelper wzm_saveVideoWithPath:[obj path] completion:^(NSError *error) {
            NSLog(@"===%@",error);
        }];
    }
    
    
}

@end
