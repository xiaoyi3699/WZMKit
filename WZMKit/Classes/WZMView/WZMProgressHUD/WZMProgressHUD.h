//
//  WZMProgressHUD.h
//  WZMKit
//
//  Created by WangZhaomeng on 2017/10/26.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMProgressView : UIView

@end

@interface WZMProgressConfig : NSObject

///背景色
@property (nonatomic, strong) UIColor *backgroundColor;
///菊花色
@property (nonatomic, strong) UIColor *progressColor;
///文本色
@property (nonatomic, strong) UIColor *textColor;
///文本字体
@property (nonatomic, strong) UIFont *font;
///是否有毛玻璃效果
@property (nonatomic, assign, getter=isBlur) BOOL blur;
///毛玻璃效果
@property (nonatomic, strong) UIBlurEffect *effect;

+ (instancetype)shareConfig;

@end

@interface WZMProgressHUD : UIView

///是否正在显示
@property (nonatomic, assign, getter=isShow) BOOL show;
///是否允许操作
@property (nonatomic, assign,getter=isUserEnabled) BOOL userEnabled;

+ (instancetype)shareHUD;
+ (void)setProgressConfig:(WZMProgressConfig *)config;
+ (void)showInfoMessage:(NSString *)message;
+ (void)showProgressMessage:(NSString *)message;
+ (void)dismiss;

@end
