//
//  WZMTextLayer.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/17.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMTextLayer.h"

@implementation WZMTextLayer

- (void)drawInContext:(CGContextRef)ctx {
//    CGContextSetLineWidth(ctx, 10);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
//    CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetShadowWithColor(ctx, CGSizeMake(1, 1), 2, [UIColor redColor].CGColor);
    [super drawInContext:ctx];
    
    
}

@end
