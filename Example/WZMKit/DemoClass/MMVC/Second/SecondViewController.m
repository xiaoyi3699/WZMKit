//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"
#import "WTRotateView.h"

@interface SecondViewController ()
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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 355.0)];
    imageView.image = [UIImage imageNamed:@"meinv"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    WTRotateView *rotateView = [[WTRotateView alloc] initWithFrame:CGRectMake(315.0, 315.0, 40.0, 40.0)];
    [imageView addSubview:rotateView];
    
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
