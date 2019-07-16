//
//  UITextField+wzmcate.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/7/5.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface UITextField (wzmcate)

- (void)setWzm_performActionType:(LLPerformActionType)wzm_performActionType;
- (LLPerformActionType)wzm_performActionType;

/**
 修改placeholder的字体颜色、大小
 */
- (void)wzm_setPlaceholderColor:(UIColor *)color font:(UIFont *)font;

///设置文本框内容区边距
-(void)wzm_contentMargin:(CGFloat)value;

/**
 输入错误，文本框摇一摇
 */
- (void)wzm_inputErrorForShake;

/**
 限制文本长度
 */
- (BOOL)wzm_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitNums:(NSInteger)limitNums;

/**
 限制小数点位数
 */
- (BOOL)wzm_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string pointNums:(NSInteger)pointNums;

/**
 限制输入文本长度
 */
- (void)wzm_limitTextFieldLength:(NSInteger)length;

- (void)wzm_selectAllText;

- (void)wzm_setSelectedRange:(NSRange)range;

///工具框样式
- (void)wzm_inputAccessoryViewWithType:(LLInputAccessoryType)type message:(NSString *)message;

///添加完成按钮
- (void)wzm_inputAccessoryViewWithDoneTitle:(NSString *)title message:(NSString *)message;

@end
