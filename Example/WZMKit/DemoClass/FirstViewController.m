//
//  FirstViewController.m
//  WZMKit
//
//  Created by wangzhaomeng on 07/15/2019.
//  Copyright (c) 2019 wangzhaomeng. All rights reserved.
//

/**********************************************************************************/
/* ↓ WZMNetWorking(网络请求)、WZMRefresh(下拉/上拉控件)、WZMJSONParse(JSON解析)的使用 ↓ */
/**********************************************************************************/

#import "FirstViewController.h"
#import "WZMVideoKeyView.h"
#import "WZMVideoKeyView2.h"

@interface FirstViewController ()<WZMPlayerDelegate>

@end

@implementation FirstViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"第一页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"qnyn_juqing" ofType:@"mp4"];
    WZMVideoKeyView2 *view = [[WZMVideoKeyView2 alloc] initWithFrame:CGRectMake(10, 70, 355, 60)];
    view.videoUrl = [NSURL fileURLWithPath:path];
    view.radius = 10;
    [self.view addSubview:view];
    
    //段落样式
//    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    //行间距
//    style.lineSpacing = 10;
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"床前明月光疑是地上霜床前明月光疑是地上霜床前明月光疑是地上霜床前明月光疑是地上霜"];
//    [attStr addAttributes:@{NSParagraphStyleAttributeName:[style copy]} range:NSMakeRange(0, attStr.length)];
//
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 355, 60)];
//    textView.attributedText = [attStr copy];
//    textView.userInteractionEnabled = NO;
//    textView.backgroundColor = [UIColor grayColor];
//    textView.font = [UIFont systemFontOfSize:17];
//    [self.view addSubview:textView];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 8, 40, 20)];
//    label.text = @"置顶";
//    label.font = [UIFont systemFontOfSize:13];
//    label.textColor = [UIColor whiteColor];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor redColor];
//    [textView addSubview:label];
//
//    UIBezierPath *path = [UIBezierPath bezierPathWithRect:label.frame];
//    textView.textContainer.exclusionPaths = @[path];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

@end
