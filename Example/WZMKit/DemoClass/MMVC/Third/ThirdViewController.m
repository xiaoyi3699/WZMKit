//
//  ThirdViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()<WZMAlbumNavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *selectedModels;

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
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.minCount = 1;
    config.maxCount = 10;
    config.allowShowGIF = NO;
    config.allowShowVideo = NO;
    config.allowShowLocation = NO;
    config.selectedPhotos = self.selectedModels;
    WZMAlbumNavigationController *nav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    nav.pickerDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    self.selectedModels = albumNavigationController.config.selectedPhotos;
    NSLog(@"%@",self.selectedModels);
}

@end
