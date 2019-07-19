//
//  InputView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "InputView.h"
#import "WZMChatBtn.h"

@interface InputView ()<UITextViewDelegate>

@end

@implementation InputView {
    UIView *_toolView;
    NSArray *_keyboards;
}

//子类设置toolView和keyboards
- (UIView *)toolViewOfInputView {
    if (_toolView == nil) {
        CGFloat toolW = self.bounds.size.width;
        UIView *toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolW, 50)];
        toolView.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
        [self addSubview:toolView];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 7, toolW-120, 35)];
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor darkTextColor];
        textView.returnKeyType = UIReturnKeySend;
        textView.delegate = self;
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 2;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [toolView addSubview:textView];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *images = @[@"wzm_chat_voice",@"wzm_chat_emotion",@"wzm_chat_more"];//ll_chat_board
        UIImage *keyboardImg = [UIImage imageNamed:@"wzm_chat_board"];
        for (NSInteger i = 0; i < 3; i ++) {
            WZMChatBtn *btn = [WZMChatBtn chatButtonWithType:WZMChatButtonTypeInput];
            if (i == 0) {
                btn.frame = CGRectMake(0, 4.5, 40, 40);
            }
            else if (i == 1) {
                btn.frame = CGRectMake(toolW-80, 4.5, 40, 40);
            }
            else {
                btn.frame = CGRectMake(toolW-40, 4.5, 40, 40);
            }
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:keyboardImg forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [toolView addSubview:btn];
            [array addObject:btn];
        }
        _toolView = toolView;
    }
    return _toolView;
}

- (NSArray<UIView *> *)keyboardsOfInputView {
    if (_keyboards == nil) {
        NSMutableArray *keyboards = [[NSMutableArray alloc] initWithCapacity:0];
        UIView *keyboard1 = [[UIView alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.bounds.size.width, 200)];
        keyboard1.backgroundColor = [UIColor blueColor];
        
        UIView *keyboard2 = [[UIView alloc] initWithFrame:CGRectMake(0, _toolView.bounds.size.height, self.bounds.size.width, 150)];
        keyboard2.backgroundColor = [UIColor redColor];
        
        [keyboards addObject:keyboard1];
        [keyboards addObject:keyboard2];
        
        _keyboards = [keyboards copy];
    }
    return _keyboards;
}

//tool按钮交互
- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 0) {
        if (self.isEditing) {
            [self resignFirstResponder];
        }
        else {
            [self showSystemKeyboard];
        }
    }
    else if (btn.tag == 1) {
        [self showKeyboardAtIndex:0 duration:0.3];
    }
    else {
        [self showKeyboardAtIndex:1 duration:0.3];
    }
}

@end
