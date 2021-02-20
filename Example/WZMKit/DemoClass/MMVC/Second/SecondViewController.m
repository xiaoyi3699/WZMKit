//
//  SecondViewController.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController {
    WZMDrawView *_v;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第二页";
    }
    return self;
}

- (void)rot {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(100.0, 200.0, 200.0, 200.0)];
    testView.backgroundColor = [UIColor redColor];
    [self.view addSubview:testView];
    
    WZMSingleRotationGestureRecognizer *ges = [[WZMSingleRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rot)];
    ges.activeRect = CGRectMake(160.0, 160.0, 40.0, 40.0);
    [testView addGestureRecognizer:ges];
    
//    WZMDrawView *drawView = [[WZMDrawView alloc] initWithFrame:self.contentView.bounds];
//    drawView.contentMode = UIViewContentModeScaleAspectFill;
//    drawView.hbImages = @[[UIImage imageNamed:@"tabbar_icon_on"],@"tabbar_icon"];
//    [self.contentView addSubview:drawView];
    
    return;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 100.0, 355.0, 200.0)];
    imageView.image = [UIImage imageNamed:@"bgcolors"];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
    label.text = @"d神打哇多哇多哇多无dawa达瓦多哇dwadada打到我w🙂weaeawe 带娃大无";
    label.numberOfLines = 0;
//    label.backgroundColor = [UIColor redColor];
    
//    imageView.wzm_hollow = YES;
    imageView.wzm_maskView = label;
    
//    UIImageView *imageView2 = [[UIImageView alloc] initWithFrame:imageView.bounds];
//    imageView2.image = [UIImage imageNamed:@"pikaqiu"];
//
//    imageView.wzm_hollow = YES;
//    imageView.wzm_maskView = imageView2;
    
    return;
    CALayer *imageLayer = [[CALayer alloc] init];
    imageLayer.frame = CGRectMake(10.0, 100.0, 255.0, 50.0);
    imageLayer.contents = (__bridge id)([UIImage imageNamed:@"meinv"].CGImage);
    [self.view.layer addSublayer:imageLayer];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 5.0;
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSString *text = @"床前明月光";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30.0], NSParagraphStyleAttributeName:style} range:NSMakeRange(0, attStr.length)];
    
    UIBezierPath *path = [attStr wzm_getBezierPath];
    CAShapeLayer *shaperLayer = [[CAShapeLayer alloc] init];
    shaperLayer.path = path.CGPath;
    shaperLayer.frame = imageLayer.bounds;
    shaperLayer.fillRule = kCAFillRuleEvenOdd;
    
    imageLayer.mask = shaperLayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 100;
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
