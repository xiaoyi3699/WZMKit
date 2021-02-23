//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WTRotateView.h"
#import "WZMImageDrawView.h"

@interface SecondViewController ()<WZMVideoEditerDelegate,WZMAlbumNavigationControllerDelegate>
@property (nonatomic, strong) WZMVideoEditer *editer;
@property (nonatomic, strong) UIImageView *bigImageView;
@end

@implementation SecondViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.editer = [[WZMVideoEditer alloc] init];
    self.editer.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    WZMAlbumConfig *config = [[WZMAlbumConfig alloc] init];
    config.allowShowImage = NO;
    config.allowShowGIF = NO;
    config.maxCount = 1.0;
    WZMAlbumNavigationController *nav = [[WZMAlbumNavigationController alloc] initWithConfig:config];
    nav.pickerDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)albumNavigationController:(WZMAlbumNavigationController *)albumNavigationController didSelectedOriginals:(NSArray *)originals thumbnails:(NSArray *)thumbnails assets:(NSArray *)assets {
    NSString *path = [originals.firstObject path];
    [self.editer handleVideoWithPath:path];
}

///视频导出中,进度 = videoEditer.progress
- (void)videoEditerExporting:(WZMVideoEditer *)videoEditer {
    NSLog(@"%@",@(videoEditer.progress));
}

///视频导出结束,videoEditer.exportPath不为空,则成功,反之失败
- (void)videoEditerDidExported:(WZMVideoEditer *)videoEditer {
    if (videoEditer.exportPath) {
        [WZMAlbumHelper wzm_saveVideoWithPath:videoEditer.exportPath completion:^(NSError *error) {
            NSLog(@"成功");
        }];
    }
    else {
        NSLog(@"失败");
    }
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
//    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 100;
//}

@end
