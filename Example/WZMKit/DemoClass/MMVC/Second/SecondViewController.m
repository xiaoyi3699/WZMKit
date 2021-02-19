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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WZMDrawView *drawView = [[WZMDrawView alloc] initWithFrame:self.contentView.bounds];
    drawView.contentMode = UIViewContentModeScaleAspectFill;
//    drawView.hbImages = @[[UIImage imageNamed:@"tabbar_icon_on"],@"tabbar_icon"];
    [self.contentView addSubview:drawView];
    
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

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        
    }
    else {
        
    }
}

- (WZMContentType)contentType {
    return WZMContentTypeTopBar|WZMContentTypeBottomBar;
}

@end
