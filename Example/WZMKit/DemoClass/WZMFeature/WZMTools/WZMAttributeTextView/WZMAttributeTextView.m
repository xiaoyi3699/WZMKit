//
//  LLImageTextView.m
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "WZMAttributeTextView.h"
#import "WZMTextStorage.h"

@interface WZMAttributeTextView ()
@end

@implementation WZMAttributeTextView

- (id)initWithFrame:(CGRect)frame {
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(frame.size.width, CGFLOAT_MAX)];
    [layoutManager addTextContainer:textContainer];
    WZMTextStorage *textStore = [[WZMTextStorage alloc] init];
    NSAttributedString *attStr = [[NSAttributedString alloc] init];
    [textStore setAttributedString:attStr];
    [textStore addLayoutManager:layoutManager];
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        self.font = [UIFont systemFontOfSize:15];
        UIMenuItem *item1 = [[UIMenuItem alloc] initWithTitle:@"自定义1" action:@selector(item1Click:)];
        UIMenuItem *item2 = [[UIMenuItem alloc] initWithTitle:@"自定义2" action:@selector(item2Click:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[item1,item2]];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
    }
    return self;
}

- (void)setFontStyle:(WZMFontStyle)fontStyle{
    _fontStyle = fontStyle;
    if (_fontStyle == WZMFontStyleSystems) {//监听系统字体变化
        self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(preferredContentSizeChanged:)
                                                     name:UIContentSizeCategoryDidChangeNotification
                                                   object:nil];
    }
}

//设置文字垂直居中显示
- (void)setVerticalCenter:(BOOL)verticalCenter {
    _verticalCenter = verticalCenter;
    CGFloat topCorrect = ([self bounds].size.height - [self contentSize].height);
    if (topCorrect > 0) {
        if (_verticalCenter) {
            [self setContentOffset:CGPointMake(0, -topCorrect/2)];
        }
        else{
            [self setContentOffset:CGPointMake(0, 0)];
        }
    }
}

//重设偏移量，使文字垂直居中显示
- (void)setContentOffset:(CGPoint)contentOffset{
    if (self.isVerticalCenter) {
        CGFloat topCorrect = ([self bounds].size.height - [self contentSize].height);
        if (topCorrect > 0) {
            [super setContentOffset:CGPointMake(0, -topCorrect/2)];
            return;
        }
    }
    [super setContentOffset:contentOffset];
}

- (void)preferredContentSizeChanged:(NSNotification *)notification{
    self.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}

//自定义UIMenuItem
- (void)item1Click:(id)sender{
    self.text = @"有时候，你不努力，你不尝试，你就不知道，什么叫绝望！";
}

- (void)item2Click:(id)sender{
    self.text = @"#人类已经阻止不了我了#";
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(item1Click:))  return YES;
    if (action == @selector(item2Click:)) return YES;
    return [super canPerformAction:action withSender:sender];
}

#pragma mark - 添加链接
- (void)addLink:(NSString *)link range:(NSRange)range{
    NSMutableAttributedString * mutStr = [self.attributedText mutableCopy];
    NSURL *url = [NSURL URLWithString:link];
    NSUnderlineStyle style = NSUnderlineStyleSingle;
    [mutStr addAttributes:@{NSLinkAttributeName:url,
                            NSForegroundColorAttributeName:[UIColor blueColor],
                            NSUnderlineStyleAttributeName:@(style),
                            NSUnderlineColorAttributeName:[UIColor blueColor]}
                    range:range];
    self.attributedText = [mutStr copy];
}

#pragma mark - 设置文字环绕的rect
- (void)setSurroundRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    self.textContainer.exclusionPaths = @[path];
}

#pragma mark - 设置文字环绕的path
- (void)setSurroundPath:(UIBezierPath *)path{
    self.textContainer.exclusionPaths = @[path];
}

#pragma mark - 设置文字环绕的paths
- (void)setSurroundPaths:(NSArray<UIBezierPath *> *)paths{
    self.textContainer.exclusionPaths = paths;
}

- (void)dealloc{
    if (_fontStyle == WZMFontStyleSystems) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

@end
