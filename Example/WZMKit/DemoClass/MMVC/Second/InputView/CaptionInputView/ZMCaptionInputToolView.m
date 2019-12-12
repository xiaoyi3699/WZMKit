//
//  ZMCaptionInputToolView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ZMCaptionInputToolView.h"

@implementation ZMCaptionInputToolView {
    UIButton *_okBtn;
    NSArray *_toolBtns;
    UIButton *_selectedBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat toolW = self.bounds.size.width;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, toolW, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0];
        [self addSubview:lineView];
        
        WZMAttributeTextView *textView = [[WZMAttributeTextView alloc] initWithFrame:CGRectMake(10, 5, toolW-20, 60)];
        textView.font = [UIFont systemFontOfSize:17];
        textView.textColor = [UIColor darkTextColor];
        textView.returnKeyType = UIReturnKeyDone;
        textView.layer.masksToBounds = YES;
        [self addSubview:textView];
        
        UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, textView.wzm_maxY, self.wzm_width, 40)];
        [self addSubview:menuView];
        
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *titles = @[@"键盘",@"颜色",@"样式",@"字体"];
        for (NSInteger i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*70, 0, 70, 40);
            btn.tag = i;
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [menuView addSubview:btn];
            [array addObject:btn];
            
            if (i == 0) {
                btn.selected = YES;
                _selectedBtn = btn;
            }
        }
        _toolBtns = [array copy];
        
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.frame = CGRectMake(menuView.wzm_width-70, 5, 60, 30);
        _okBtn.tag = titles.count;
        _okBtn.backgroundColor = [UIColor blueColor];
        _okBtn.wzm_cornerRadius = -1;
        [_okBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:_okBtn];
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(captionInputToolView:didSelectedWithType:)]) {
        [self.delegate captionInputToolView:self didSelectedWithType:(btn.tag-1)];
    }
}

@end
