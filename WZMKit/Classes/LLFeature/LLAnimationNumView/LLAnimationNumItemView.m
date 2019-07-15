//
//  LLAnimationNumItemView.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/2/24.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLAnimationNumItemView.h"
#import "UIView+LLAddPart.h"

@implementation LLAnimationNumItemView {
    UILabel *_label_0;
    UILabel *_label_1;
    BOOL _isAnimation;
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = self.bounds.size.width/2;
        self.layer.masksToBounds = YES;
        
        _label_0 = [[UILabel alloc] initWithFrame:self.bounds];
        _label_0.text = text;
        _label_0.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label_0];
        
        CGRect rect = _label_0.frame;
        rect.origin.y = rect.size.height;
        _label_1 = [[UILabel alloc] initWithFrame:rect];
        _label_1.textAlignment = NSTextAlignmentCenter;
        _label_1.alpha = 0;
        [self addSubview:_label_1];
    }
    return self;
}

#pragma mark - setter
- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    _label_0.textColor = textColor;
    _label_1.textColor = textColor;
    _textColor = textColor;
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return;
    _label_0.font = font;
    _label_1.font = font;
    _font = font;
}

#pragma mark - public method
- (void)refreshText:(NSString *)text {
    
    if (_isAnimation) return;
    
    UILabel *label_0, *label_1;
    if (_label_0.minY == 0) {
        label_0 = _label_0;
        label_1 = _label_1;
    }
    else {
        label_0 = _label_1;
        label_1 = _label_0;
    }
    if (self.isSameAnimetion == NO) {
        if ([label_0.text isEqualToString:text]) return;
    }
    label_1.text = text;
    [UIView animateWithDuration:_duration animations:^{
        label_0.minY = -label_0.LLHeight;
        label_1.minY = 0;
        _isAnimation = YES;
        label_0.alpha = 0;
        label_1.alpha = 1;
    } completion:^(BOOL finished) {
        label_0.minY = label_0.LLHeight;
        _isAnimation = NO;
    }];
}

@end
