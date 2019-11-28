//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WZMVideoEditView.h"
//http://www.vasueyun.cn/resource/wzm_snow.mp3
//http://www.vasueyun.cn/resource/wzm_qnyh.mp4

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMAlbumNavigationControllerDelegate>

@end

@implementation SecondViewController {
    NSInteger _time;
    WZMVideoEditView *editView;
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
    
    editView = [[WZMVideoEditView alloc] initWithFrame:CGRectMake(20, 100, WZM_SCREEN_WIDTH-40, 200)];
    [self.view addSubview:editView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//
//    return;
//    NSString *str1 = @"重庆";
//    NSString *str = @"%u91CD%u5E86";
//    NSLog(@"%@==%@",[str wzm_getURLDecoded],[str1 wzm_getURLEncoded2]);
//    return;
    
    WZMAlbumConfig *config = [WZMAlbumConfig new];
    config.originalVideo = YES;
    config.originalImage = YES;
    config.allowShowGIF = YES;
    config.maxCount = 20;
    config.allowPreview = YES;
    config.allowDragSelect = NO;
    WZMAlbumNavigationController *vc = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    vc.pickerDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
    NSURL *videoUrl;
    AVAsset *asset = [AVAsset assetWithURL:videoUrl];
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize renderSize = CGSizeMake(track.naturalSize.width, track.naturalSize.height);
    
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    NSLog(@"===%@===%@===%@",originals,thumbnails,assets);
//    [self addWatermark:originals.firstObject start:0 end:3 complete:nil];
    
    editView.videoUrl = originals.firstObject;
    
    UIView *markView = [[UIView alloc] initWithFrame:CGRectMake(2, 2, 20, 20)];
    markView.backgroundColor = [UIColor grayColor];
    [editView addWatermark:markView];
    
    [WZMViewHandle wzm_showProgressMessage:nil];
    [editView exportVideoCompletion:^(NSURL *exportURL) {
        [WZMViewHandle wzm_dismiss];
        if (exportURL) {
            [WZMAlbumHelper wzm_saveVideo:exportURL.path];
        }
    }];
}

@end
