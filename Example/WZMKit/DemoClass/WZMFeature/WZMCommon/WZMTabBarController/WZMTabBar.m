//
//  WZMTabBar.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/29.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMTabBar.h"

@implementation WZMTabBar {
    BOOL _layouted;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat tabBarButtonW = WZM_SCREEN_WIDTH / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 重新设置frame
            if (child.tag == 0) {
                if (_layouted) {
                    child.tag = (self.index+1);
                }
                else {
                    child.tag = (tabBarButtonIndex+1);
                }
            }
            CGRect frame = CGRectMake((child.tag-1) * tabBarButtonW, 0, tabBarButtonW, 49);
            child.frame = frame;
            NSLog(@"child=%@=child.tag=%ld",child,child.tag);
            // 增加索引
            if (tabBarButtonIndex == 1) {
                tabBarButtonIndex++;
            }
            tabBarButtonIndex++;
        }
    }
    _layouted = YES;
}

@end
