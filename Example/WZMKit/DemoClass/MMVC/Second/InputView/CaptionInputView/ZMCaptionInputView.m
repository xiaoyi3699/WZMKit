//
//  ZMCaptionInputView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ZMCaptionInputView.h"
#import "ZMCaptionInputToolView.h"
#import "ZMCaptionFontView.h"
#import "ZMCaptionStyleView.h"
#import "ZMCaptionColorView.h"

@interface ZMCaptionInputView ()<ZMCaptionInputToolViewDelegate>

@property (nonatomic, strong) ZMCaptionColorView *colorView;
@property (nonatomic, strong) ZMCaptionStyleView *styleView;
@property (nonatomic, strong) ZMCaptionFontView *fontView;
@property (nonatomic, strong) ZMCaptionInputToolView *inputToolView;

@end

@implementation ZMCaptionInputView {
    UIView *_toolView;
    NSArray *_keyboards;
}

#pragma mark - 实现以下三个数据源方法, 供父类调用
//设置toolView和keyboards
- (UIView *)toolViewOfInputView {
    if (_toolView == nil) {
        _toolView = self.inputToolView;
    }
    return _toolView;
}

- (NSArray<UIView *> *)keyboardsOfInputView {
    if (_keyboards == nil) {
        _keyboards = @[self.colorView,self.styleView,self.fontView];
    }
    return _keyboards;
}

///视图的初始y值, 一般放在屏幕的最下方
- (CGFloat)startYOfInputView {
    return WZM_SCREEN_HEIGHT;
}

#pragma mark - 父类回调事件
//点击return键
- (BOOL)shouldReturn {
    [self chatResignFirstResponder];
    return NO;
}

///开始编辑
- (void)didBeginEditing {
    
}

///输入框值改变
- (void)valueDidChange {
    
}

///还原视图
- (void)willResetConfig {
    
}

///视图frameb改变
- (void)willChangeFrameWithDuration:(CGFloat)duration {
    
}

#pragma mark - 代理
- (void)captionInputToolView:(ZMCaptionInputToolView *)captionInputToolView didSelectedWithType:(ZMCaptionInputToolViewType)type {
    if (type == ZMCaptionInputToolViewTypeOK) {
        //确定
    }
    else if (type == ZMCaptionInputToolViewTypeSystem) {
        //系统键盘
        [self showSystemKeyboard];
    }
    else {
        [self showKeyboardAtIndex:type duration:0.2];
    }
}

#pragma mark - getter
- (ZMCaptionInputToolView *)inputToolView {
    if (_inputToolView == nil) {
        _inputToolView = [[ZMCaptionInputToolView alloc] initWithFrame:CGRectMake(0, 0, self.wzm_width, 105)];
        _inputToolView.delegate = self;
        _inputToolView.backgroundColor = [UIColor colorWithRed:250/255. green:250/255. blue:250/255. alpha:1];
    }
    return _inputToolView;
}

- (ZMCaptionColorView *)colorView {
    if (_colorView == nil) {
        _colorView = [[ZMCaptionColorView alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.wzm_width, 200)];
        _colorView.hidden = YES;
        _colorView.backgroundColor = [UIColor whiteColor];
    }
    return _colorView;
}

- (ZMCaptionStyleView *)styleView {
    if (_styleView == nil) {
        _styleView = [[ZMCaptionStyleView alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.wzm_width, 200)];
        _styleView.hidden = YES;
        _styleView.backgroundColor = [UIColor redColor];
    }
    return _styleView;
}

- (ZMCaptionFontView *)fontView {
    if (_fontView == nil) {
        _fontView = [[ZMCaptionFontView alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.wzm_width, 200)];
        _fontView.hidden = YES;
        _fontView.backgroundColor = [UIColor greenColor];
    }
    return _fontView;
}

@end
