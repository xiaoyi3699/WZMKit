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

@interface SecondViewController ()<WZMAlbumControllerDelegate>

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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    scrollView.contentSize = CGSizeMake(500, 1000);
    [self.view addSubview:scrollView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];

    WZMGifImageView *gifView = [[WZMGifImageView alloc] initWithFrame:CGRectMake(10, 100, 355, 200)];
    gifView.gifData = [NSData dataWithContentsOfFile:path];
    [scrollView addSubview:gifView];
    [gifView startGif];
}

/**
 runloop嵌套测试，
 */
- (void)nestTest {
    _time = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSTimer *tickTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.1 target:self selector:@selector(timerHandle1) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:tickTimer forMode:NSDefaultRunLoopMode];
        NSInteger i = 0;
        while (_time < 60) {
            i ++;
            NSLog(@"====%@",@(i));
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    });
}

- (void)timerHandle1 {
    _time ++;
//    NSLog(@"%@",@(_time));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self nestTest];
//    WZMAlbumConfig *config = [WZMAlbumConfig new];
//    config.originalImage = NO;
//    config.imageSize = CGSizeMake(200, 220);
//    config.originalVideo = NO;
//    config.allowShowGIF = NO;
//    WZMAlbumController *vc = [[WZMAlbumController alloc] initWithConfig:config];
//    vc.pickerDelegate = self;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumController:(WZMAlbumController *)albumController didSelectedPhotos:(NSArray *)photos {
    NSLog(@"%@",photos);
}

@end
