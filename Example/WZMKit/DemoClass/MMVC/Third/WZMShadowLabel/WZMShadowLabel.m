//
//  WZMShadowView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/10.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMShadowLabel.h"

@interface WZMShadowLabel ()
@property (nonatomic, assign) BOOL allowDraw;
@end

@implementation WZMShadowLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.allowDraw = YES;
        self.strokeWidth = 0.0;
        self.strokeColor = nil;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    if (self.allowDraw == NO) return;
    self.allowDraw = NO;
    if (self.strokeWidth > 0.0 && self.strokeColor != nil) {
        CGSize shadowOffset = self.shadowOffset;
        UIColor *textColor = self.textColor;
        CGContextRef c = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(c, self.strokeWidth);
        CGContextSetLineJoin(c, kCGLineJoinRound);
        
        //画外边
        if (self.textAlignment == NSTextAlignmentRight) {
            CGContextTranslateCTM(c, -self.strokeWidth/2.0, 0.0);
        }
        else {
            if (self.textAlignment != NSTextAlignmentCenter) {
                CGContextTranslateCTM(c, self.strokeWidth/2.0, 0.0);
            }
        }
        CGContextSetTextDrawingMode(c, kCGTextStroke);
        self.textColor = self.strokeColor;
        [super drawTextInRect:rect];
        
        //画内文字
        CGContextSetTextDrawingMode(c, kCGTextFill);
        self.textColor = textColor;
        self.shadowOffset = CGSizeMake(0, 0);
        [super drawTextInRect:rect];
        self.shadowOffset = shadowOffset;
    }
    else {
        [super drawTextInRect:rect];
    }
    self.allowDraw = YES;
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    if (_strokeWidth == strokeWidth) return;
    _strokeWidth = strokeWidth;
    if (self.superview) {
        [self setNeedsDisplay];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor {
    _strokeColor = strokeColor;
    if (self.superview) {
        [self setNeedsDisplay];
    }
}

@end
