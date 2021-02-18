//
//  WZMBaseViewController.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface WZMBaseViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign) WZMUserInterfaceStyle userInterfaceStyle;

///设置导航栏左侧item
- (UIImage *)navigatonLeftItemImage;
- (UIView *)navigatonLeftItemView;
- (void)navigatonLeftButtonClick;

///设置导航栏右侧item
- (UIImage *)navigatonRightItemImage;
- (UIView *)navigatonRightItemView;
- (void)navigatonRightButtonClick;

///视图类型
- (WZMContentType)contentType;
///是否接管导航栏
- (BOOL)capturesNavigatonBar;
///导航栏是否隐藏
- (BOOL)navigatonBarIsHidden;
///导航栏是否隐藏线条
- (BOOL)navigatonBarIsHiddenLine;
///导航栏背景颜色
- (UIColor *)navigatonBarBackgroundColor;
///导航栏title颜色
- (UIColor *)navigatonBarTitleColor;
///明亮/暗黑
- (void)userInterfaceStyleDidChange:(WZMUserInterfaceStyle)style;

@end
