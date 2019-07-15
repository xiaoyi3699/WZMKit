//
//  UIButton+LLAddPart.m
//  LLFoundation
//
//  Created by WangZhaomeng on 2017/8/31.
//  Copyright © 2017年 MaoChao Network Co. Ltd. All rights reserved.
//

#import "UIButton+LLAddPart.h"

@implementation UIButton (LLAddPart)

#pragma mark - 初始化快捷方式

+ (instancetype)buttonWithFrame:(CGRect)frame
                        bgImage:(UIImage*)bgImage
{
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                        bgImage:(UIImage*)image
                          title:(NSString*)title
                     titleColor:(UIColor*)titleColor
                           font:(UIFont*)font
{
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    
    return button;
}

+ (instancetype)buttonWithFrame:(CGRect)frame
                          image:(UIImage*)image
                          title:(NSString*)title
                     titleColor:(UIColor*)titleColor
                           font:(UIFont*)font
{
    UIButton* button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        button.titleLabel.font = font;
    }
    
    return button;
}

#pragma mark - 附加方法

- (void)setTitle:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font
{
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
    }
    if (titleColor) {
        [self setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (font) {
        self.titleLabel.font = font;
    }
}

@end
