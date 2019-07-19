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

@interface FirstViewController ()

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self.view wzm_executeGesture:^(UIView *view_, WZMGestureRecognizerType gesture_) {
        if (gesture_ == WZMGestureRecognizerTypeSingle) {
            [self.view wzm_3dBackgroundAnimation:YES duration:0.25];
        }
        else {
            [self.view wzm_3dBackgroundAnimation:NO duration:0.25];
        }
    }];
}



@end
