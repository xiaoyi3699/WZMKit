//
//  LLAnimationNumView.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/2/26.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLAnimationNumView.h"
#import "LLMacro.h"

@implementation LLAnimationNumView {
    NSArray *_aniViews;
}

- (instancetype)initWithFrame:(CGRect)frame numText:(NSString *)numText spacing:(CGFloat)spacing {
    self = [super initWithFrame:frame];
    if (self) {
        
        _duration = 0.5;
        _foreColor = R_G_B(72, 181, 248);
        _textColor = [UIColor whiteColor];
        _font = [UIFont systemFontOfSize:17];
        _sameAnimetion = NO;
        _placeholder = @"";
        
        NSMutableArray *texts = [NSMutableArray arrayWithCapacity:numText.length];
        for (NSInteger i = 0; i < numText.length; i ++) {
            NSString *subString = [numText substringWithRange:NSMakeRange(i, 1)];
            [texts addObject:subString];
        }
        
        NSInteger count = texts.count;
        CGFloat w = (frame.size.width-(count-1)*spacing)/count;
        CGFloat h = frame.size.height;
        CGFloat itemW = MIN(w, h);
        NSMutableArray *aniViews = [NSMutableArray arrayWithCapacity:count];
        for (NSInteger i = 0; i < count; i ++) {
            LLAnimationNumItemView *itemView = [[LLAnimationNumItemView alloc] initWithFrame:CGRectMake(i%count*(spacing+itemW), 0, itemW, itemW) text:texts[i]];
            [self addSubview:itemView];
            [aniViews addObject:itemView];
        }
        _aniViews = [aniViews copy];
    }
    return self;
}

#pragma mark - setter
- (void)setDuration:(CGFloat)duration {
    if (_duration == duration) return;
    _duration = duration;
    if (self.superview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            itemView.duration = duration;
        }
    }
}

- (void)setFont:(UIFont *)font {
    if (_font == font) return;
    _font = font;
    if (self.superview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            itemView.font = font;
        }
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor == textColor) return;
    _textColor = textColor;
    if (self.superview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            itemView.textColor = textColor;
        }
    }
}

- (void)setForeColor:(UIColor *)foreColor {
    if (_foreColor == foreColor) return;
    _foreColor = foreColor;
    if (self.superview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            itemView.backgroundColor = foreColor;
        }
    }
}

- (void)setSameAnimetion:(BOOL)sameAnimetion {
    if (_sameAnimetion == sameAnimetion) return;
    _sameAnimetion = sameAnimetion;
    if (self.superview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            itemView.sameAnimetion = sameAnimetion;
        }
    }
}

#pragma mark - public method
- (void)refreshNumText:(NSString *)numText {
    
    NSMutableArray *texts = [NSMutableArray arrayWithCapacity:numText.length];
    for (NSInteger i = 0; i < numText.length; i ++) {
        NSString *subString = [numText substringWithRange:NSMakeRange(i, 1)];
        [texts addObject:subString];
    }
    if (_placeholder == nil) {
        _placeholder = @"";
    }
    if (texts.count < _aniViews.count) {
        
        NSInteger dCount = (_aniViews.count-texts.count);
        
        for (NSInteger i = 0; i < dCount; i ++) {
            if (_placeholderType == LLAnimationPlacehloderTypeFront) {
                [texts insertObject:_placeholder atIndex:0];
            }
            else {
                [texts addObject:_placeholder];
            }
        }
    }
    else if (texts.count > _aniViews.count) {
        
        NSInteger dCount = (texts.count-_aniViews.count);
        
        for (NSInteger i = 0; i < dCount; i ++) {
            [texts removeObjectAtIndex:0];
        }
    }
    
    for (NSInteger i = 0; i < _aniViews.count; i ++) {
        LLAnimationNumItemView *itemView = _aniViews[i];
        NSString *text;
        if (i < texts.count) {
            text = texts[i];
        }
        else {
            text = _placeholder;
        }
        [itemView refreshText:text];
    }
}

#pragma mark - super method
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview) {
        for (LLAnimationNumItemView *itemView in _aniViews) {
            _duration = arc4random()%5*1.0/10+0.5;
            itemView.duration = _duration;
            itemView.backgroundColor = _foreColor;
            itemView.textColor = _textColor;
            itemView.font = _font;
            itemView.sameAnimetion = _sameAnimetion;
        }
    }
}

@end
