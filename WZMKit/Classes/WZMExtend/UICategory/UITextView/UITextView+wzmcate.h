//
//  UITextView+wzmcate.h
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/7/5.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface UITextView (wzmcate)

- (void)setWzm_performActionType:(LLPerformActionType)wzm_performActionType;
- (LLPerformActionType)wzm_performActionType;

- (BOOL)wzm_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limitNums:(NSInteger)limitNums;
- (BOOL)wzm_shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text pointNums:(NSInteger)pointNums;
- (void)wzm_limitTextFieldLength:(NSInteger)length;
- (void)wzm_selectAllText;
- (void)wzm_setSelectedRange:(NSRange)range;

///工具框样式
- (void)wzm_inputAccessoryViewWithType:(LLInputAccessoryType)type message:(NSString *)message;

///添加完成按钮
- (void)wzm_inputAccessoryViewWithDoneTitle:(NSString *)title message:(NSString *)message;

@end
