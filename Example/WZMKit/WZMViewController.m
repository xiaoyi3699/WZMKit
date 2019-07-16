//
//  WZMViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

#import "WZMViewController.h"
#import <WZMKit/WZMKit.h>

@interface WZMViewController () {
    WZMAudioPlayer *player;
}

@end

@implementation WZMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
    player = [[WZMAudioPlayer alloc] init];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"wzm_snow" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [player playWithURL:url];
}

@end
