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

@interface SecondViewController ()<WZMVideoEditerDelegate>
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
    
    WZMImageDrawView *drawView = [[WZMImageDrawView alloc] initWithFrame:self.contentView.bounds];
    drawView.width = 20.0;
    drawView.image = [UIImage imageNamed:@"maobi"];
    [self.contentView addSubview:drawView];
    
    self.editer = [[WZMVideoEditer alloc] init];
    self.editer.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dalll.mp4" ofType:nil];
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
