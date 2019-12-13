//
//  ZMCaptionColorView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/13.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "ZMCaptionColorView.h"

@interface ZMCaptionColorView ()

@property (nonatomic, strong) UISwitch *switchView1;

@end

@implementation ZMCaptionColorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.switchView1 = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.switchView1.transform = CGAffineTransformMakeScale(0.6, 0.6);
        [self addSubview:self.switchView1];
        
        UILabel *useLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, 34)];
        useLabel.text = @"应用到所有文字";
        useLabel.textColor = [UIColor darkGrayColor];
        useLabel.textAlignment = NSTextAlignmentLeft;
        useLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:useLabel];
        
        //色块的宽度
        NSInteger itemW = 40;
        
        //颜色
        UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 35, self.wzm_width, 70)];
        [self addSubview:view1];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
        label1.text = @"颜色";
        label1.textColor = [UIColor darkGrayColor];
        label1.textAlignment = NSTextAlignmentLeft;
        label1.font = [UIFont systemFontOfSize:13];
        [view1 addSubview:label1];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 10; i ++) {
            UIColor *color = WZM_R_G_B(arc4random()%255, arc4random()%255, arc4random()%255);
            [array1 addObject:color];
        }
        NSInteger count1 = array1.count;
        UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(10, label1.wzm_maxY, view1.wzm_width-20, view1.wzm_height-label1.wzm_maxY)];
        scrollView1.contentSize = CGSizeMake(MAX(scrollView1.wzm_width, count1*itemW+(count1-1)*10), scrollView1.wzm_height);
        scrollView1.showsHorizontalScrollIndicator = NO;
        [view1 addSubview:scrollView1];
        for (NSInteger i = 0; i < count1; i ++) {
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(i*(itemW+10), 0, itemW, itemW)];
            colorView.backgroundColor = [array1 objectAtIndex:i];
            colorView.wzm_cornerRadius = 5;
            [scrollView1 addSubview:colorView];
        }
        
        //渐变色
        UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, view1.wzm_maxY, self.wzm_width, 70)];
        [self addSubview:view2];
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
        label2.text = @"渐变色";
        label2.textColor = [UIColor darkGrayColor];
        label2.textAlignment = NSTextAlignmentLeft;
        label2.font = [UIFont systemFontOfSize:13];
        [view2 addSubview:label2];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 10; i ++) {
            UIColor *color = WZM_R_G_B(arc4random()%255, arc4random()%255, arc4random()%255);
            [array2 addObject:color];
        }
        NSInteger count2 = array2.count;
        UIScrollView *scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(10, label2.wzm_maxY, view2.wzm_width-20, view2.wzm_height-label2.wzm_maxY)];
        scrollView2.contentSize = CGSizeMake(MAX(scrollView2.wzm_width, count2*itemW+(count2-1)*10), scrollView2.wzm_height);
        scrollView2.showsHorizontalScrollIndicator = NO;
        [view2 addSubview:scrollView2];
        for (NSInteger i = 0; i < count2; i ++) {
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(i*(itemW+10), 0, itemW, itemW)];
            colorView.backgroundColor = [array2 objectAtIndex:i];
            colorView.wzm_cornerRadius = 5;
            [scrollView2 addSubview:colorView];
        }
        
        //炫彩
        UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(0, view2.wzm_maxY, self.wzm_width, 70)];
        [self addSubview:view3];
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 60, 20)];
        label3.text = @"炫彩";
        label3.textColor = [UIColor darkGrayColor];
        label3.textAlignment = NSTextAlignmentLeft;
        label3.font = [UIFont systemFontOfSize:13];
        [view3 addSubview:label3];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 10; i ++) {
            UIColor *color = WZM_R_G_B(arc4random()%255, arc4random()%255, arc4random()%255);
            [array3 addObject:color];
        }
        NSInteger count3 = array3.count;
        UIScrollView *scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(10, label3.wzm_maxY, view3.wzm_width-20, view3.wzm_height-label3.wzm_maxY)];
        scrollView3.contentSize = CGSizeMake(MAX(scrollView3.wzm_width, count3*itemW+(count3-1)*10), scrollView3.wzm_height);
        scrollView3.showsHorizontalScrollIndicator = NO;
        [view3 addSubview:scrollView3];
        for (NSInteger i = 0; i < count3; i ++) {
            UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(i*(itemW+10), 0, itemW, itemW)];
            colorView.backgroundColor = [array3 objectAtIndex:i];
            colorView.wzm_cornerRadius = 5;
            [scrollView3 addSubview:colorView];
        }
    }
    return self;
}

@end
