//
//  UIViewController+wzmcate.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/22.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (wzmcate)

///返回
- (void)wzm_goBack;

///当前正在显示的控制器
- (UIViewController *)wzm_visibleViewController;

///当前vc的view是否处于屏幕上
- (BOOL)wzm_isVisible;

///强制转换屏幕方向
- (void)wzm_interfaceOrientation:(UIInterfaceOrientation)orientation;

@end
