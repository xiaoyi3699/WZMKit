//
//  WZMDottedView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/1/6.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMDottedView.h"

@implementation WZMDottedView

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
    CGFloat lengths[]= {6.0, 4.0};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineDash(context, 0.0, lengths, 2);
    CGRect rect2 = self.bounds;
    rect2.origin.x = self.lineWidth;
    rect2.origin.y = self.lineWidth;
    rect2.size.width -= self.lineWidth*2;
    rect2.size.height -= self.lineWidth*2;
    CGContextAddRect(context, rect2);
    CGContextStrokePath(context);
}

@end
