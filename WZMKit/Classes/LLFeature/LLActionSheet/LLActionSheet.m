//
//  LLActionSheet.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/7/11.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLActionSheet.h"
#import "LLMacro.h"
#import "UIView+LLAddPart.h"

@implementation LLActionSheet {
    UIView *_messageView;
}

- (instancetype)initWithMessage:(NSString *)message titles:(NSArray *)titles {
    self = [super initWithFrame:LL_SCREEN_BOUNDS];
    if (self) {
        self.backgroundColor = CUSTOM_ALERT_BG_COLOR;
        
        _messageView = [[UIView alloc] init];
        _messageView.backgroundColor = [UIColor whiteColor];
        
        UIColor *lineColor = R_G_B_A(200, 200, 200, .5);
        CGFloat btnBeginY = 0;
        if (message.length > 0) {
            _messageView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, (titles.count+2)*44+LL_BOTTOM_HEIGHT);
            
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 43.5)];
            messageLabel.text = message;
            messageLabel.textColor = R_G_B(100, 100, 100);
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont systemFontOfSize:13];
            [_messageView addSubview:messageLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, messageLabel.maxY, self.bounds.size.width, 0.5)];
            lineView.backgroundColor = lineColor;
            [_messageView addSubview:lineView];
            
            btnBeginY = lineView.maxY;
        }
        else {
            _messageView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, (titles.count+1)*44+LL_BOTTOM_HEIGHT);
        }
        [self addSubview:_messageView];
        
        for (NSInteger i = 0; i < titles.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(0, btnBeginY+i%titles.count*44, self.bounds.size.width, 43.5);
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn setTitleColor:R_G_B(50, 50, 50) forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_messageView addSubview:btn];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, btn.maxY, self.bounds.size.width, 0.5)];
            lineView.backgroundColor = lineColor;
            [_messageView addSubview:lineView];
        }
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.tag = -1;
        cancelBtn.frame = CGRectMake(0, _messageView.bounds.size.height-44-LL_BOTTOM_HEIGHT, self.bounds.size.width, 44);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_messageView addSubview:cancelBtn];
    }
    return self;
}

#pragma mark - 交互事件
- (void)btnClick:(UIButton *)btn {
    [self dismiss];
    if ([self.delegete respondsToSelector:@selector(actionSheet:didSelectedAtIndex:)]) {
        [self.delegete actionSheet:self didSelectedAtIndex:btn.tag];
    }
}

#pragma mark - public method
- (void)dismiss {
    [UIView animateWithDuration:.15 animations:^{
        _messageView.minY = self.bounds.size.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)showCompletion:(doBlock)completion {
    [self showAnimationInView:LL_WINDOW completion:completion];
}

- (void)showInView:(UIView *)aView completion:(doBlock)completion{
    [self showAnimationInView:aView completion:completion];
}

#pragma mark - private method
- (void)showAnimationInView:(UIView *)aView completion:(doBlock)completion{
    [aView addSubview:self];
    if(!CGRectEqualToRect(aView.bounds, self.bounds)) {
        self.frame = aView.bounds;
        _messageView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, _messageView.LLHeight);
    }
    [UIView animateWithDuration:.3 animations:^{
        _messageView.minY = self.bounds.size.height - _messageView.LLHeight;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - super method
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    if (touch.view == self) {
        [self dismiss];
    }
}

@end

