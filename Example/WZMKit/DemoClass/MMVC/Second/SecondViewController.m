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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xmhzma" ofType:@"MP4"];
    WZMVideoPlayerViewController *vc = [[WZMVideoPlayerViewController alloc] initWithVideoUrl:[NSURL fileURLWithPath:path]];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
