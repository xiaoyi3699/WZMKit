//
//  WZMMenuView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/9.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMMenuView.h"
#import "WZMButton.h"
#import "UIView+wzmcate.h"
#import "WZMMacro.h"
#import "UIColor+wzmcate.h"

@implementation WZMMenuView {
    NSMutableArray *_itemBtns;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _itemBtns = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    for (UIButton *itemBtn in _itemBtns) {
        [itemBtn removeFromSuperview];
    }
    CGFloat menuH = self.wzm_height;
    CGFloat startMinX = 5.0, startMinY = 5.0;
    CGFloat maxW = self.bounds.size.width-startMinX*2.0;
    CGFloat minX = startMinX, minY = startMinY, itemH = 30.0;
    CGFloat hSpacing = 10.0, vSpacing = 10.0;
    UIFont *font = [UIFont systemFontOfSize:13.0];
    for (NSInteger i = 0; i < titles.count; i ++) {
        NSString *title = [titles objectAtIndex:i];
        CGFloat itemW = MIN(MAX(ceil([title sizeWithAttributes:@{NSFontAttributeName:font}].width)+20.0, 60), maxW);
        if (minX + itemW > maxW) {
            minX = startMinX;
            minY = minY + itemH + vSpacing;
        }
        WZMButton *btn = [[WZMButton alloc] initWithFrame:CGRectMake(minX, minY, itemW, itemH)];
        btn.tag = i;
        btn.titleLabel.font = font;
        btn.backgroundColor = [UIColor wzm_getDynamicColorByLightColor:WZM_R_G_B(233.0, 233.0, 233.0) darkColor:WZM_R_G_B(44.0, 44.0, 44.0)];
        btn.wzm_cornerRadius = itemH/2.0;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor wzm_getDynamicColorByLightColor:[UIColor darkTextColor] darkColor:[UIColor lightTextColor]] forState:UIControlStateNormal];
        btn.titleFrame = CGRectMake(5.0, 0.0, itemW-10.0, itemH);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [btn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        minX = minX + itemW + hSpacing;
        if (i == titles.count - 1) {
            menuH = btn.wzm_maxY + startMinY;
        }
        [_itemBtns addObject:btn];
    }
    self.wzm_height = menuH;
}

- (void)itemBtnClick:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(menuView:didSelectedText:)]) {
        [self.delegate menuView:self didSelectedText:[self.titles objectAtIndex:btn.tag]];
    }
}

@end
