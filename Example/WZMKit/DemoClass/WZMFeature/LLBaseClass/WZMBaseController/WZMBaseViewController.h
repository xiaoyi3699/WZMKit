//
//  WZMBaseViewController.h
//  LLFeature
//
//  Created by WangZhaomeng on 2017/10/11.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZMBaseViewControllerProtocol <NSObject>
@optional
///返回当前ViewController支持的屏幕方向
- (UIInterfaceOrientationMask)ll_supportedInterfaceOrientations;
@end

@interface UIViewController (WZMBaseViewController) <WZMBaseViewControllerProtocol>

@end

@interface WZMBaseViewController : UIViewController

///设置导航栏左侧item
- (void)setLeftItemImage:(UIImage *)image;

///设置导航栏右侧item
- (void)setRightItemImage:(UIImage *)image;

- (void)leftButtonClick;
- (void)rightButtonClick;

///导航栏背景图片
- (UIImage *)navigatonBarBackgroundImage;

///导航栏是否隐藏线条
- (BOOL)navigatonIsHiddenLine;

///title颜色
- (UIColor *)navigatonBarTitleColor;

///返回按钮颜色
- (UIColor *)backItemColor;

///返回按钮文字
- (NSString *)backItemTitle;

@end
