//
//  WZMToolView.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/22.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMToolView.h"
#import "WZMInputBtn.h"

@interface WZMToolView ()

@end

@implementation WZMToolView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat toolW = self.bounds.size.width;
        CGFloat toolH = self.bounds.size.height;
        
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(40, (toolH-35)/2, toolW-120, 35)];
        textView.font = [UIFont systemFontOfSize:13];
        textView.textColor = [UIColor darkTextColor];
        textView.returnKeyType = UIReturnKeySend;
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 2;
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1].CGColor;
        [self addSubview:textView];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *images = @[@"wzm_chat_voice",@"wzm_chat_emotion",@"wzm_chat_more"];//ll_chat_board
        UIImage *keyboardImg = [UIImage imageNamed:@"wzm_chat_board"];
        for (NSInteger i = 0; i < 3; i ++) {
            WZMInputBtn *btn = [WZMInputBtn chatButtonWithType:WZMInputBtnTypeTool];
            if (i == 0) {
                btn.frame = CGRectMake(0, (toolH-40)/2, 40, 40);
            }
            else if (i == 1) {
                btn.frame = CGRectMake(toolW-80, (toolH-40)/2, 40, 40);
            }
            else {
                btn.frame = CGRectMake(toolW-40, (toolH-40)/2, 40, 40);
            }
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
            [btn setImage:keyboardImg forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [array addObject:btn];
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(inputToolView:DidSelectAtIndex:)]) {
        [self.delegate inputToolView:self DidSelectAtIndex:btn.tag];
    }
}

@end
