//
//  WZMAlertView.m
//  WZMFoundation
//
//  Created by lhy on 16/8/17.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMAlertView.h"
#import "WZMMacro.h"
#import "UIView+wzmcate.h"
#import "NSString+wzmcate.h"
#import "UIColor+wzmcate.h"
#import "UIImage+wzmcate.h"
#import "WZMDefined.h"

@interface WZMAlertView()<UITextViewDelegate> {
    wzm_doBlock1 _OKBlock;
    wzm_doBlock  _cannelBlock;
    NSString *_OKButtonTitle;
    NSString *_cancelButtonTitle;
    UIView   *_alertView;
    NSArray  *_btns;
    UITextView *_placeholderView;
}
@property (nonatomic, strong) UITextView *textView;
@end

#define WZM_THEME_COLOR_UP [UIColor redColor]
@implementation WZMAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message OKButtonTitle:(NSString *)OKButtonTitle cancelButtonTitle:(NSString *)cancelButtonTitle type:(WZMAlertViewType)type {
    self = [super init];
    if (self) {
        CGRect rect           = [UIScreen mainScreen].bounds;
        CGSize size           = rect.size;
        
        self.frame            = rect;
        self.backgroundColor  = WZM_ALERT_BG_COLOR;
        
        /** 根据屏幕尺寸，需要变化的值 */
        CGFloat btnHeight,titleFont,messageFont,titleHeight,leftEdge = 0.0;
        UIColor *titleColor, *messageColor;
        
        if (WZM_IS_iPhone) {
            if (size.height <= 480){//4/4S
                titleHeight   = 40;
                btnHeight     = 40;
                titleFont     = 15;
                if (type == WZMAlertViewTypeUpdate) {
                    messageFont   = 13;
                }
                else {
                    messageFont   = 15;
                }
                leftEdge      = 40;
            }
            else if (size.height <= 568){//5/5C/5S/SE
                titleHeight   = 40;
                btnHeight     = 40;
                titleFont     = 15;
                leftEdge      = 40;
                if (type == WZMAlertViewTypeUpdate) {
                    messageFont   = 13;
                }
                else {
                    messageFont   = 15;
                }
            }
            else if (size.height <= 667){//6/6S/7
                titleHeight   = 50;
                btnHeight     = 45;
                titleFont     = 17;
                leftEdge      = 60;
                if (type == WZMAlertViewTypeUpdate) {
                    messageFont   = 14;
                }
                else {
                    messageFont   = 16;
                }
            }
            else{//6P/6SP/7P
                titleHeight   = 55;
                btnHeight     = 50;
                titleFont     = 17;
                leftEdge      = 70;
                if (type == WZMAlertViewTypeUpdate) {
                    messageFont   = 14;
                }
                else {
                    messageFont   = 16;
                }
            }
        }
        else {
            titleHeight   = 55;
            btnHeight     = 50;
            titleFont     = 20;
            leftEdge      = (size.width-200)/2;
            if (type == WZMAlertViewTypeUpdate) {
                messageFont   = 16;
            }
            else {
                messageFont   = 18;
            }
        }
        
        if (title.length == 0) {
            titleHeight = 20;
        }
        
        CGFloat width         = size.width-leftEdge*2;
        CGFloat messageHeight;
        if (type == WZMAlertViewTypeTextView) {
            messageHeight = 100.0;
        }
        else {
            messageHeight = [NSString wzm_heightWithStr:message width:(width-20) font:[UIFont systemFontOfSize:messageFont]];
        }
        CGFloat height        = titleHeight+messageHeight+16+btnHeight;
        CGFloat x             = (size.width-width)/2.0f;
        CGFloat y             = (size.height-height)/2.0f;
        
        if (type == WZMAlertViewTypeUpdate) {
            titleColor   = WZM_THEME_COLOR_UP;
            messageColor = [UIColor darkGrayColor];
        }
        else {
            if (type == WZMAlertViewTypeTextView) {
                y -= height/2.0;
            }
            titleColor   = [UIColor wzm_getDynamicColorByLightColor:[UIColor blackColor] darkColor:[UIColor whiteColor]];
            messageColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B(55, 55, 55) darkColor:WZM_R_G_B(200, 200, 200)];
        }
        
        /** 1、白色背景view */
        _alertView        = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius  = 10;
        _alertView.backgroundColor     = [UIColor wzm_getDynamicColorByLightColor:[UIColor whiteColor] darkColor:WZM_R_G_B(33, 33, 33)];
        [self addSubview:_alertView];
        
        /** 2、标题label */
        UILabel *titleLabel            = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_alertView.frame), titleHeight)];
        titleLabel.text                = title;
        titleLabel.textColor           = titleColor;
        titleLabel.font                = [UIFont systemFontOfSize:titleFont];
        titleLabel.textAlignment       = NSTextAlignmentCenter;
        [_alertView addSubview:titleLabel];
        
        /** 3、提示信息label */
        CGFloat messageMaxY;
        if (type == WZMAlertViewTypeTextView) {
            UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(_alertView.frame)-20, messageHeight)];
            borderView.layer.borderColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B_A(222, 222, 222, 0.5) darkColor:WZM_R_G_B_A(66, 66, 66, 0.5)].CGColor;
            borderView.layer.borderWidth = 0.5;
            borderView.layer.masksToBounds = YES;
            borderView.layer.cornerRadius = 5.0;
            [_alertView addSubview:borderView];
            messageMaxY = CGRectGetMaxY(borderView.frame);
            
            CGRect textRect = borderView.bounds;
            textRect.origin.x += 5.0;
            textRect.size.width -= 10.0;
            UITextView *messageTextView    = [[UITextView alloc] initWithFrame:textRect];
            messageTextView.delegate       = self;
            messageTextView.textColor      = messageColor;
            messageTextView.font           = [UIFont systemFontOfSize:messageFont];
            [borderView addSubview:messageTextView];
            messageTextView.backgroundColor = [UIColor clearColor];
            self.textView = messageTextView;
            
            _placeholderView = [[UITextView alloc] initWithFrame:textRect];
            _placeholderView.text = message;
            _placeholderView.textColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B_A(180, 180, 180, 1.0) darkColor:WZM_R_G_B_A(75, 75, 75, 1.0)];
            _placeholderView.font = [UIFont systemFontOfSize:messageFont];
            _placeholderView.userInteractionEnabled = NO;
            _placeholderView.backgroundColor = [UIColor clearColor];
            [borderView addSubview:_placeholderView];
        }
        else {
            UILabel *messageLabel          = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(_alertView.frame)-20, messageHeight)];
            messageLabel.text              = message;
            messageLabel.textColor         = messageColor;
            messageLabel.font              = [UIFont systemFontOfSize:messageFont];
            messageLabel.textAlignment     = NSTextAlignmentCenter;
            messageLabel.numberOfLines     = 0;
            [_alertView addSubview:messageLabel];
            messageMaxY = CGRectGetMaxY(messageLabel.frame);
        }
        
        /** 4、提示信息label下的横线 */
        UIView *horizontalLine        = [[UIView alloc] initWithFrame:CGRectMake(0, messageMaxY+15.5, CGRectGetWidth(_alertView.frame), 0.5)];
        horizontalLine.backgroundColor= [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B_A(222, 222, 222, 0.5) darkColor:WZM_R_G_B_A(66, 66, 66, 0.5)];
        [_alertView addSubview:horizontalLine];
        
        NSMutableArray *btnTitles     = [[NSMutableArray alloc] initWithCapacity:2];
        if (cancelButtonTitle.length == 0 && OKButtonTitle.length == 0) {
            [btnTitles addObject:@"确定"];
            _cancelButtonTitle = @"确定";
        }
        else {
            if (cancelButtonTitle.length) {
                [btnTitles addObject:cancelButtonTitle];
                _cancelButtonTitle = cancelButtonTitle;
            }
            if (OKButtonTitle.length) {
                [btnTitles addObject:OKButtonTitle];
                _OKButtonTitle = OKButtonTitle;
            }
        }
        /** 5、计算按钮的宽和y坐标，for循环创建btn */
        CGFloat btnWidth               = (CGRectGetWidth(_alertView.frame)-0.5)/2.0f;
        if (btnTitles.count == 1) {
            btnWidth                   = CGRectGetWidth(_alertView.frame);
        }
        CGFloat btnY                   = CGRectGetMaxY(horizontalLine.frame);
        NSMutableArray *btns = [NSMutableArray arrayWithCapacity:btnTitles.count];
        for (NSInteger i = 0; i < btnTitles.count; i ++) {
            UIButton *btn              = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame                  = CGRectMake(i%2*(btnWidth+1), btnY, btnWidth, btnHeight);
            btn.titleLabel.font        = [UIFont systemFontOfSize:titleFont];
            [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage wzm_getImageByColor:[UIColor colorWithWhite:.8 alpha:.5]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_alertView addSubview:btn];
            if (type == WZMAlertViewTypeUpdate) {
                if (i == 0) {
                    [btn setTitleColor:WZM_THEME_COLOR_UP forState:UIControlStateNormal];
                }
                else {
                    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
            }
            else {
                [btn setTitleColor:[UIColor colorWithRed:25/255. green:120/255. blue:230/255. alpha:1] forState:UIControlStateNormal];
            }
            [btns addObject:btn];
        }
        _btns = [btns copy];
        /** 6、两个按钮中间的竖线 */
        if (btnTitles.count == 2) {
            UIView *verticalLine         = [[UIView alloc] initWithFrame:CGRectMake(btnWidth, btnY, 0.5, btnHeight)];
            verticalLine.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B_A(222, 222, 222, 0.5) darkColor:WZM_R_G_B_A(66, 66, 66, 0.5)];
            [_alertView addSubview:verticalLine];
        }
    }
    return self;
}

- (void)showAnimated:(BOOL)animated{
#if WZM_APP
    if (self.textView) {
        [self.textView becomeFirstResponder];
    }
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    if (animated) {
        [_alertView wzm_outFromCenterAnimationWithDuration:.35];
    }
#endif
}

- (void)setCannelBlock:(wzm_doBlock)cannelBlock{
    _cannelBlock = cannelBlock;
}

- (void)setOKBlock:(wzm_doBlock1)OKBlock {
    _OKBlock = OKBlock;
}

- (void)setCancelColor:(UIColor *)color {
    if (color == _cancelColor) return;
    _cancelColor = color;
    for (UIButton *btn in _btns) {
        if ([btn.titleLabel.text isEqualToString:_cancelButtonTitle]) {
            [btn setTitleColor:color forState:UIControlStateNormal];
            return;
        }
    }
}

- (void)setOKColor:(UIColor *)color {
    if (color == _OKColor) return;
    _OKColor = color;
    for (UIButton *btn in _btns) {
        if ([btn.titleLabel.text isEqualToString:_OKButtonTitle]) {
            [btn setTitleColor:color forState:UIControlStateNormal];
            return;
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    _placeholderView.hidden = (textView.text.length > 0);
}

#pragma mark - 私有方法
- (void)btnClick:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:_OKButtonTitle]) {
        if (_OKBlock) {
            _OKBlock(self.textView.text);
        }
    }
    else{
        if (_cannelBlock) {
            _cannelBlock();
        }
    }
    [self dismiss];
}

#pragma mark - 消失动画
- (void)dismiss{
    if (self.textView) {
        [self.textView endEditing:YES];
    }
    [UIView animateWithDuration:.2 animations:^{
        [_alertView wzm_dismissToCenterAnimationWithDuration:.2];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
