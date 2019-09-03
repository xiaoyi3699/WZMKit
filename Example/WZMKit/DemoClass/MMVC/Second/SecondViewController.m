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

@interface SecondViewController ()<WZMAlbumControllerDelegate,WZMPhotoBrowserDelegate>

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
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        NSInteger i = 0;
//        while (i < 60) {
//            NSLog(@"====%@",@(i));
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//            i ++;
//        }
//    });
//    NSString *r = @"http://www.vasueyun.cn/resource/wzm_qnyh.mp4";
//    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"xmhzma" ofType:@"MP4"];
//    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"jingcai" ofType:@"gif"];
//    UIImage *image = [UIImage imageNamed:@"tabbar_icon_on"];
//
//    WZMPhotoBrowser *photoBrowser = [[WZMPhotoBrowser alloc] init];
//    photoBrowser.delegate = self;
//    photoBrowser.images = @[videoPath,gifPath,image,videoPath,gifPath,image,r];
//    [self presentViewController:photoBrowser animated:YES completion:nil];
    
    WZMAlbumController *vc = [[WZMAlbumController alloc] initWithConfig:[WZMAlbumConfig new]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)
photoBrowser:(WZMPhotoBrowser *)photoBrowser clickAtIndex:(NSInteger)index contentType:(WZMAlbumPhotoType)contentType gestureType:(WZMGestureRecognizerType)gestureType {
    NSLog(@"%@-==%@",@(index),@(contentType));
    if (gestureType == WZMGestureRecognizerTypeSingle) {
        NSLog(@"单击");
    }
    else if (gestureType == WZMGestureRecognizerTypeDouble) {
        NSLog(@"单击2");
    }
    else {
        NSLog(@"单击3");
    }
}

@end
