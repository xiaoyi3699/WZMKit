//
//  WZMShadowLayer.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/10.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMShadowLayer.h"

@interface WZMShadowLayer ()
@property (nonatomic, assign) BOOL allowDraw;
@end

@implementation WZMShadowLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowDraw = YES;
        self.strokeWidth = 0.0;
        self.strokeColor = nil;
        self.fontSize = 17.0;
        //self.font = (__bridge CFTypeRef)(@"Helvetica");
        self.contentsScale = [UIScreen mainScreen].scale;
        self.wrapped = YES;
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    if (self.allowDraw == NO) return;
    self.allowDraw = NO;
    if (self.strokeWidth > 0.0 && self.strokeColor != nil) {
        CGContextSetLineWidth(ctx, self.strokeWidth);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        //画外边
        if ([self.alignmentMode isEqualToString:@"right"]) {
            CGContextTranslateCTM(ctx, -self.strokeWidth/2.0, self.strokeWidth/4.0);
        }
        else {
            if ([self.alignmentMode isEqualToString:@"center"] == NO) {
                CGContextTranslateCTM(ctx, self.strokeWidth/2.0, self.strokeWidth/4.0);
            }
        }
        CGContextSetTextDrawingMode(ctx, kCGTextStroke);
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
        [super drawInContext:ctx];
        //垂直翻转画布
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextTranslateCTM(ctx, 0.0, -self.bounds.size.height);
        //画内文字
        CGContextSetTextDrawingMode(ctx, kCGTextFill);
        CGContextSetFillColorWithColor(ctx, self.foregroundColor);
        [super drawInContext:ctx];
    }
    else {
        [super drawInContext:ctx];
    }
    self.allowDraw = YES;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth == strokeWidth) return;
    _strokeWidth = strokeWidth;
    if (self.superlayer) {
        [self setNeedsDisplay];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    if (self.superlayer) {
        [self setNeedsDisplay];
    }
}

@end
