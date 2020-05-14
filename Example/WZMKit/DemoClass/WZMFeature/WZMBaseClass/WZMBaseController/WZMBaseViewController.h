//
//  WZMBaseViewController.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@protocol WZMBaseViewControllerProtocol <NSObject>
@optional
///返回当前ViewController支持的屏幕方向
- (UIInterfaceOrientationMask)wzm_supportedInterfaceOrientations;
@end

@interface UIViewController (WZMBaseViewController) <WZMBaseViewControllerProtocol>

@end

@interface WZMBaseViewController : UIViewController

@property (nonatomic, assign) WZMUserInterfaceStyle userInterfaceStyle;

///设置导航栏左侧item
- (UIImage *)navigatonLeftItemImage;
- (UIView *)navigatonLeftItemView;
- (void)navigatonLeftButtonClick;

///设置导航栏右侧item
- (UIImage *)navigatonRightItemImage;
- (UIView *)navigatonRightItemView;
- (void)navigatonRightButtonClick;

///明亮/暗黑
- (void)userInterfaceStyleDidChange:(WZMUserInterfaceStyle)style;

///导航栏是否隐藏
- (BOOL)navigatonBarIsHidden;

///导航栏是否隐藏线条
- (BOOL)navigatonBarIsHiddenLine;

///导航栏背景颜色
- (UIColor *)navigatonBarBackgroundColor;

///导航栏title颜色
- (UIColor *)navigatonBarTitleColor;

///导航栏返回按钮颜色
- (UIColor *)navigatonBarBackItemColor;

///导航栏返回按钮文字
- (NSString *)navigatonBarBackItemTitle;

@end
