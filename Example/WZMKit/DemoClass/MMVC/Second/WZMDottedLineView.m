//
//  WZMDottedLineView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/1/6.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMDottedLineView.h"

@implementation WZMDottedLineView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lineWidth = 1;
        self.lineColor = [UIColor redColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGFloat dashPattern[]= {5.0, 3};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineDash(context, 0.0, dashPattern, 2);
    CGContextAddRect(context, self.bounds);
    CGContextStrokePath(context);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
