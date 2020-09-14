//
//  WZMAlbumScaleView.m
//  ThirdApp
//
//  Created by Zhaomeng Wang on 2020/8/20.
//  Copyright © 2020 富秋. All rights reserved.
//

#import "WZMAlbumScaleView.h"
#import "UIView+wzmcate.h"
#import "WZMButton.h"
#import "WZMPublic.h"

@interface WZMAlbumScaleView ()
@property (nonatomic, strong) UIButton *selectedBtn;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSArray *scales;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@end

@implementation WZMAlbumScaleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.normalColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0];
        self.selectedColor = [UIColor colorWithRed:120.0/255.0 green:120.0/255.0 blue:120.0/255.0 alpha:1.0];
        self.btns = [[NSMutableArray alloc] init];
        self.scales = @[@(0.0),@(1.0),@(3.0/4.0),@(4.0/3.0),@(9.0/16.0),@(16.0/9.0)];
        NSArray *titles = @[@"自由",@"1:1",@"3:4",@"4:3",@"9:16",@"16:9"];
        CGFloat w = 40.0;
        CGFloat spacing = (self.wzm_width-40.0-w*self.scales.count)/(self.scales.count-1);
        for (NSInteger i = 0; i < titles.count; i ++) {
            WZMButton *btn = [[WZMButton alloc] init];
            btn.tag = i;
            btn.frame = CGRectMake(20.0+i*(w+spacing), 10.0, w, w);
            btn.wzm_cornerRadius = 2.0;
            btn.wzm_borderWidth = 0.5;
            btn.wzm_borderColor = self.normalColor;
            btn.titleLabel.font = [UIFont systemFontOfSize:10.0];
            [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
            [btn setTitleColor:self.selectedColor forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.btns addObject:btn];
            if (i == 0) {
                btn.selected = YES;
                self.selectedBtn = btn;
                btn.wzm_borderColor = self.selectedColor;
            }
        }
    }
    return self;
}

- (void)btnClick:(UIButton *)btn {
    self.selectedBtn.selected = NO;
    self.selectedBtn.wzm_borderColor = self.normalColor;
    btn.selected = YES;
    self.selectedBtn = btn;
    self.selectedBtn.wzm_borderColor = self.selectedColor;
    CGFloat scale = [[self.scales objectAtIndex:btn.tag] floatValue];
    if ([self.delegate respondsToSelector:@selector(scaleView:didChangeScale:)]) {
        [self.delegate scaleView:self didChangeScale:scale];
    }
}

@end
