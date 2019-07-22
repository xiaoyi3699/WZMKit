//
//  WZMInputView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMInputView.h"
#import "WZMInputHelper.h"
#import "WZMToolView.h"
#import "WZMEmojisKeyboard.h"
#import "WZMMoreKeyboard.h"

@interface WZMInputView ()<WZMToolViewDelegate,WZMEmojisKeyboardDelegate,WZMMoreKeyboardDelegate>

@property (nonatomic, strong) WZMToolView *inputToolView;
@property (nonatomic, strong) WZMMoreKeyboard *moreKeyboard;
@property (nonatomic, strong) WZMEmojisKeyboard *emojisKeyboard;

@end

@implementation WZMInputView {
    UIView *_toolView;
    NSArray *_keyboards;
}

#pragma mark - 实现以下三个数据源方法, 供父类调用
///视图的初始y值
- (CGFloat)startYOfInputView {
    return [UIScreen mainScreen].bounds.size.height-50-49;
}

//设置toolView和keyboards
- (UIView *)toolViewOfInputView {
    if (_toolView == nil) {
        _toolView = self.inputToolView;
    }
    return _toolView;
}

- (NSArray<UIView *> *)keyboardsOfInputView {
    if (_keyboards == nil) {
        _keyboards = @[self.emojisKeyboard,self.moreKeyboard];
    }
    return _keyboards;
}

#pragma mark - 代理事件
//toolView
- (void)toolView:(WZMToolView *)toolView didSelectAtIndex:(NSInteger)index {
    
}

- (void)toolView:(WZMToolView *)toolView showKeyboardType:(WZMKeyboardType)type {
    if (type == WZMKeyboardTypeSystem) {
        [self showSystemKeyboard];
    }
    else if (type == WZMKeyboardTypeEmoticon) {
        [self showKeyboardAtIndex:0 duration:0.3];
    }
    else if (type == WZMKeyboardTypeMore) {
        [self showKeyboardAtIndex:1 duration:0.3];
    }
    else {
        [self dismissKeyboard];
    }
}

//表情键盘
- (void)emojisKeyboardDidSelectSend:(WZMEmojisKeyboard *)emojisKeyboard {
    
}

- (void)emojisKeyboardDidSelectDelete:(WZMEmojisKeyboard *)emojisKeyboard {
    [self deleteSelectedText];
}

- (void)emojisKeyboard:(WZMEmojisKeyboard *)emojisKeyboard didSelectText:(NSString *)text {
    [self replaceSelectedTextWithText:text];
}

//more键盘
- (void)moreKeyboard:(WZMMoreKeyboard *)moreKeyboard didSelectedWithType:(WZMChatMoreType)type {
    
}

#pragma mark - 回调事件
///开始编辑
- (void)didBeginEditing:(BOOL)systemKeyboard {
    NSLog(@"开始编辑");
    if (systemKeyboard) {
        [self.inputToolView resetStatus];
    }
}

///结束编辑
- (void)didEndEditing {
    NSLog(@"结束编辑");
}

///输入框值改变
- (void)valueDidChange {
    NSLog(@"输入框值改变：%@",self.text);
}

///视图frameb改变
- (void)willChangeFrameWithDuration:(CGFloat)duration {
    
}

#pragma mark - getter
- (WZMToolView *)inputToolView {
    if (_inputToolView == nil) {
        _inputToolView = [[WZMToolView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
        _inputToolView.delegate = self;
        _inputToolView.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    }
    return _inputToolView;
}

- (WZMEmojisKeyboard *)emojisKeyboard {
    if (_emojisKeyboard == nil) {
        _emojisKeyboard = [[WZMEmojisKeyboard alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.bounds.size.width, 200+[WZMInputHelper helper].iPhoneXBottomH)];
        _emojisKeyboard.delegate = self;
        _emojisKeyboard.hidden = YES;
        _emojisKeyboard.backgroundColor = [UIColor whiteColor];
    }
    return _emojisKeyboard;
}

- (WZMMoreKeyboard *)moreKeyboard {
    if (_moreKeyboard == nil) {
        _moreKeyboard = [[WZMMoreKeyboard alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.bounds.size.width, 200+[WZMInputHelper helper].iPhoneXBottomH)];
        _moreKeyboard.delegate = self;
        _moreKeyboard.hidden = YES;
        _moreKeyboard.backgroundColor = [UIColor whiteColor];
    }
    return _moreKeyboard;
}

@end
