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
    
    WZMFontView *fontView = [[WZMFontView alloc] initWithFrame:WZMRectMiddleArea()];
    [self.view addSubview:fontView];
    
    
//    UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
//        [self.view addSubview:lbl];
//        lbl.textColor = [UIColor blackColor];
//        lbl.text = @"12:13";
//        lbl.font = [UIFont fontWithName:@"DBLCDTempBlack" size:20];
//    [self.view addSubview:lbl];
    
//    WZMMosaicView *mskView = [[WZMMosaicView alloc] initWithFrame:WZMRectMiddleArea()];
//    mskView.image = [UIImage imageNamed:@"meinv"];
//    mskView.type = 0;
//    [self.view addSubview:mskView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
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
