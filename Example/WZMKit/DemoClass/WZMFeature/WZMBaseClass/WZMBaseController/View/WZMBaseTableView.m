//
//  WZMBaseTableView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/27.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMBaseTableView.h"

@implementation WZMBaseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setConfig];
    }
    return self;
}

- (void)setConfig {
    self.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:DARK_COLOR];
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}

@end
