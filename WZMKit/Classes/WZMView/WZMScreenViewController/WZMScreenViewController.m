//
//  WZMScreenViewController.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/12.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMScreenViewController.h"

@interface WZMScreenViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WZMScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.imageView.image = self.image;
    [self.view addSubview:self.imageView];
}

- (void)setImage:(UIImage *)image {
    if (self.imageView != nil) {
        self.imageView.image = image;
    }
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
