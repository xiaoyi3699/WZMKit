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
    
    WZMImageDrawView *drawView = [[WZMImageDrawView alloc] initWithFrame:self.contentView.bounds];
    drawView.width = 20.0;
    drawView.image = [UIImage imageNamed:@"maobi"];
    [self.contentView addSubview:drawView];
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
