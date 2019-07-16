//
//  LLSelectedView.m
//  LLRoundedImage
//
//  Created by WangZhaomeng on 2017/7/10.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "LLSelectedView.h"

@implementation LLSelectedView {
    NSMutableArray *_btns;
    NSMutableArray *_lineWidths;
    UIView         *_selectedLineView;
    UIView         *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles titleFont:(UIFont *)font index:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (index < 0 || index >= titles.count) {
            index = 0;
        }
        _selectedIndex      = index;
        _titleColor         = [UIColor darkTextColor];
        _selectedTitleColor = [UIColor redColor];
        _selectedLineColor  = [UIColor redColor];
        _lineColor          = [UIColor colorWithRed:200/255. green:200/255. blue:200/255. alpha:1.0];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        _lineView.backgroundColor = _lineColor;
        [self addSubview:_lineView];
        
        _selectedLineView = [[UIView alloc] init];
        _selectedLineView.backgroundColor = _selectedLineColor;
        [self addSubview:_selectedLineView];
        
        _lineWidths = [NSMutableArray arrayWithCapacity:titles.count];
        _btns = [NSMutableArray arrayWithCapacity:titles.count];
        CGFloat btnWidth = frame.size.width/titles.count;
        for (NSInteger i = 0; i < titles.count; i ++) {
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(i%titles.count*btnWidth, 0, btnWidth, frame.size.height-2);
            btn.titleLabel.font = font;
            [btn setTitle:titles[i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [_btns addObject:btn];
            
            //CGFloat lineWidth = [titles[i] sizeWithAttributes:@{NSFontAttributeName:font}].width;
            CGFloat lineWidth = btnWidth;
            [_lineWidths addObject:@(lineWidth)];
            
            if (i == index) {
                _selectedBtn = btn;
                _selectedLineView.frame = CGRectMake(btn.frame.origin.x+MAX(0, (btnWidth-lineWidth)/2.0), frame.size.height-2, lineWidth, 2);
                [btn setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
            }
            else {
                [btn setTitleColor:_titleColor forState:UIControlStateNormal];
            }
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    if (_selectedBtn == btn) {
        return;
    }
    [self animationWithIndex:btn.tag];
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (_titleColor == titleColor) {
        return;
    }
    _titleColor = titleColor;
    
    for (UIButton *btn in _btns) {
        if (btn.tag != _selectedIndex) {
            [btn setTitleColor:_titleColor forState:UIControlStateNormal];
        }
    }
}

- (void)setselectedTitleColor:(UIColor *)selectedTitleColor {
    if (_selectedTitleColor == selectedTitleColor) {
        return;
    }
    _selectedTitleColor = selectedTitleColor;
    
    [_selectedBtn setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
}

- (void)setselectedLineColor:(UIColor *)selectedLineColor {
    if (_selectedLineColor == selectedLineColor) {
        return;
    }
    _selectedLineColor = selectedLineColor;
    _selectedLineView.backgroundColor = _selectedLineColor;
}

- (void)setlineColor:(UIColor *)lineColor {
    if (_lineColor == lineColor) {
        return;
    }
    _lineColor = lineColor;
    _lineView.backgroundColor = _lineColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex == selectedIndex) {
        return;
    }
    [self animationWithIndex:selectedIndex];
}

- (void)setSelectedBtn:(UIButton *)selectedBtn {
    if (_selectedBtn == selectedBtn) {
        return;
    }
    [self animationWithIndex:selectedBtn.tag];
}

- (void)animationWithIndex:(NSInteger)index {
    
    if (index < 0 || index >= _btns.count) {
        return;
    }
    
    [_selectedBtn setTitleColor:_titleColor forState:UIControlStateNormal];
    _selectedBtn = _btns[index];
    _selectedIndex = index;
    [UIView animateWithDuration:.2 animations:^{
        CGFloat lineWidth = [_lineWidths[index] floatValue];
        _selectedLineView.frame = CGRectMake(_selectedBtn.frame.origin.x+MAX(0, (_selectedBtn.bounds.size.width-lineWidth)/2.0), self.frame.size.height-2, lineWidth, 2);
        [_selectedBtn setTitleColor:_selectedTitleColor forState:UIControlStateNormal];
    }];
    if ([self.delegate respondsToSelector:@selector(selectedView:selectedAtIndex:)]) {
        [self.delegate selectedView:self selectedAtIndex:index];
    }
}

@end
