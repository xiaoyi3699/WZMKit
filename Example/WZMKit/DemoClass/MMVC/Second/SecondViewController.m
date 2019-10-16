//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate>

@end

@implementation SecondViewController {
    NSInteger _time;
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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    WZMActionSheet *sheet = [[WZMActionSheet alloc] initWithMessage:@"提示" titles:@[@"刘德华",@"哈哈哈哈哈哈",@"的话刘而非",@"挖的大多"]];
    [sheet showCompletion:nil];
    
    return;
    
    WZMAlbumConfig *config = [WZMAlbumConfig new];
    config.originalVideo = YES;
    config.originalImage = YES;
    config.allowShowGIF = YES;
    config.maxCount = 20;
    config.allowPreview = YES;
    config.allowDragSelect = NO;
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
//    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:^{
        NSLog(@"%@==%@=2",NSStringFromCGRect(vc.view.frame),NSStringFromCGRect(vc.navigationBar.frame));
    }];
    NSLog(@"%@==%@=2",NSStringFromCGRect(vc.view.frame),NSStringFromCGRect(vc.navigationBar.frame));
//    vc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    NSLog(@"===%@===%@===%@",originals,thumbnails,assets);
}

@end
