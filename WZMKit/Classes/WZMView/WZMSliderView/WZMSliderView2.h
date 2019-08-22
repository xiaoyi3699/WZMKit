//
//  WZMSliderView2.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMSliderView2 : UIView

///进度
@property (nonatomic, assign) CGFloat strokeStart;
@property (nonatomic, assign) CGFloat strokeEnd;
///线条宽
@property (nonatomic, assign) CGFloat lineWidth;
///半径
@property (nonatomic, assign) CGFloat radius;
///填充色
@property (nonatomic, strong) UIColor *fillColor;
///线条颜色
@property (nonatomic, strong) UIColor *strokeColor;
///背景色
@property (nonatomic, strong) UIColor *bgColor;
///是否有弹性动画, 默认NO
@property (nonatomic, assign, getter=isAnimation) BOOL animation;

@end
