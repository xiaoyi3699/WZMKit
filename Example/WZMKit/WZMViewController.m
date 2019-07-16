//
//  WZMViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMViewController.h"
#import <WZMKit/WZMKit.h>

@interface WZMViewController ()

@end

@implementation WZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_qnyn" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    WZMVideoPlayerViewController *vc = [[WZMVideoPlayerViewController alloc] initWithVideoUrl:url];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
