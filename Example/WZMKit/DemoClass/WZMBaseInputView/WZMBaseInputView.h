//
//  WZMBaseInputView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WZMBaseInputViewTypeIdle = 0, //闲置状态
    WZMBaseInputViewTypeSystem,   //系统键盘
    WZMBaseInputViewTypeOther,    //自定义键盘
} WZMBaseInputViewType;

@interface WZMBaseInputView : UIView

///当前键盘类型
@property (nonatomic, assign, readonly) WZMBaseInputViewType type;
///是否处于编辑状态, 自定义键盘模式也认定为编辑状态
@property (nonatomic, assign, readonly, getter=isEditing) BOOL editing;

#pragma mark - 主动调用的方法
///显示系统键盘
- (void)showSystemKeyboard;
///显示自定义键盘
- (void)showKeyboardAtIndex:(NSInteger)index duration:(CGFloat)duration;
///结束编辑
- (void)dismissKeyboard;

#pragma mark - 子类中回调的方法
///创建视图
- (void)createViews NS_REQUIRES_SUPER;
///开始编辑
- (void)willBeginEditing;
///结束编辑
- (void)willEndEditing;
///视图frameb改变
- (void)willChangeFrameWithDuration:(CGFloat)duration;

#pragma mark - 子类中需要实现的数据源
///视图的初始y值
- (CGFloat)startYOfInputView;
///自定义toolView和keyboards
- (UIView *)toolViewOfInputView;
- (NSArray<UIView *> *)keyboardsOfInputView;

@end
