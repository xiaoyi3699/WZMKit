//
//  LLBezierView.m
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2018/3/21.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "LLBezierView.h"

@implementation LLBezierView

- (void)drawRect:(CGRect)rect {
    
    //设置线条颜色
    [[UIColor blueColor] set];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = 1.0;
    [path moveToPoint:_start];
    [path addLineToPoint:_end];
    //线条拐角
//    path.lineCapStyle = kCGLineCapRound;
    //终点处理
    path.lineJoinStyle = kCGLineJoinRound;
    
    [path stroke];
}

@end
