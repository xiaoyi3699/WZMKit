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

@property (nonatomic, strong) UITextView *textView;

@end

@implementation InputView

- (void)createViews {
    [super createViews];
    
    CGFloat toolW = self.bounds.size.width;
    self.toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolW, 50)];
    self.toolView.backgroundColor = [UIColor colorWithRed:240/255. green:240/255. blue:240/255. alpha:1];
    [self addSubview:self.toolView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(40, 7, toolW-120, 35)];
    self.textView.font = [UIFont systemFontOfSize:13];
    self.textView.textColor = [UIColor darkTextColor];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.delegate = self;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 2;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
    [self.toolView addSubview:self.textView];
    
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
        [self.toolView addSubview:btn];
        [array addObject:btn];
    }
    
    UIView *keyboard1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolView.bounds.size.height, self.bounds.size.width, 200)];
    keyboard1.backgroundColor = [UIColor blueColor];
    keyboard1.hidden = YES;
    [self addSubview:keyboard1];
    
    UIView *keyboard2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.toolView.bounds.size.height, self.bounds.size.width, 150)];
    keyboard2.backgroundColor = [UIColor redColor];
    keyboard2.hidden = YES;
    [self addSubview:keyboard2];
    
    [self.keyboards addObject:keyboard1];
    [self.keyboards addObject:keyboard2];
}

@end
