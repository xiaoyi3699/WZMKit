//
//  WZMClipTimeView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/7.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMClipTimeViewDelegate;

typedef enum : NSInteger {
    WZMClipTimeStateWillChanged = 0,
    WZMClipTimeStateDidChanged,
    WZMClipTimeStateEndChanged,
} WZMClipTimeState;

@interface WZMClipTimeView : UIView

///取值0~1, 默认值0
@property (nonatomic, readonly, assign) CGFloat startValue;
///取值0~1, 默认值1
@property (nonatomic, readonly, assign) CGFloat endValue;
///前景色
@property (nonatomic, strong) UIColor *foregroundBorderColor;
///背景色
@property (nonatomic, strong) UIColor *backgroundBorderColor;
///代理
@property (nonatomic, weak) id<WZMClipTimeViewDelegate> delegate;

@end

@protocol WZMClipTimeViewDelegate <NSObject>

@optional
- (void)clipView:(WZMClipTimeView *)clipView valueState:(WZMClipTimeState)state;

@end
