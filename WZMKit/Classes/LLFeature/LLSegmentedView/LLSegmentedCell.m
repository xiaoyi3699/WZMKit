//
//  LLSegmentedCell.m
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/15.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "LLSegmentedCell.h"
#import "UIView+LLAddPart.h"

@implementation LLSegmentedCell {
    UILabel *_titleLabel;
    UIView *_lineView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect rect = self.bounds;
        rect.size.height -= 2;
        
        _titleLabel = [[UILabel alloc] initWithFrame:rect];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_titleLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _titleLabel.maxY, self.LLWidth, 2)];
        _lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)setConfigWithTitle:(NSString *)title
                titleColor:(UIColor *)titleColor
                 titleFont:(UIFont *)titleFont
                 lineColor:(UIColor *)lineColor {
    
    _titleLabel.text = title;
    _titleLabel.font = titleFont;
    _titleLabel.textColor = titleColor;
    _lineView.backgroundColor = lineColor;
}

@end
