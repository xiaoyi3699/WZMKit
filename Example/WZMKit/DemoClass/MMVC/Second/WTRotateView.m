//
//  WTRotateView.m
//  WTFunctionApp
//
//  Created by Zhaomeng Wang on 2021/2/22.
//

#import "WTRotateView.h"

@interface WTRotateView () {
    CGFloat deltaAngle;
    CGPoint prevPoint;
    CGFloat pasterSize;
    CGFloat rotateSize;
}

@end

@implementation WTRotateView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        rotateSize = MAX(frame.size.width, frame.size.height);
        UIPanGestureRecognizer *panResizeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTranslate:)];
        [self addGestureRecognizer:panResizeGesture];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (newSuperview) {
        [self setConfig:newSuperview];
    }
}

- (void)setConfig:(UIView *)superview {
    if (self.minWidth == 0.0) {
        self.minWidth = superview.bounds.size.width*0.5;
    }
    if (self.minHeight == 0.0) {
        self.minHeight = superview.bounds.size.height*0.5;
    }
    pasterSize = MAX(superview.bounds.size.width, superview.bounds.size.height);
    deltaAngle = atan2(superview.frame.origin.y+superview.frame.size.height-superview.center.y,
                       superview.frame.origin.x+superview.frame.size.width-superview.center.x);
}

- (void)resizeTranslate:(UIPanGestureRecognizer *)recognizer {
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        prevPoint = [recognizer locationInView:self.superview];
        [self.superview setNeedsDisplay];
    }else if ([recognizer state] == UIGestureRecognizerStateChanged) {
        // preventing from the picture being shrinked too far by resizing
        if (self.superview.bounds.size.width < self.minWidth || self.superview.bounds.size.height < self.minHeight) {
            self.superview.bounds = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.origin.y, self.minWidth + 1, self.minHeight + 1);
            self.frame = CGRectMake(self.superview.bounds.size.width-rotateSize, self.superview.bounds.size.height-rotateSize, rotateSize, rotateSize);
            prevPoint = [recognizer locationInView:self.superview];
        } else {// Resizing
            CGPoint point = [recognizer locationInView:self.superview];
            CGFloat wChange = 0.0, hChange = 0.0;
            wChange = (point.x - prevPoint.x);
            CGFloat wRatioChange = (wChange/(CGFloat)self.superview.bounds.size.width);
            hChange = wRatioChange * self.superview.bounds.size.height;
            if (ABS(wChange) > 50.0f || ABS(hChange) > 50.0f) {
                prevPoint = [recognizer locationInView:self.superview];
                [self.superview setNeedsDisplay];
                return;
            }
            
            CGFloat finalWidth  = self.superview.bounds.size.width + (wChange);
            CGFloat finalHeight = self.superview.bounds.size.height + (wChange);
            if (finalWidth > pasterSize*(1+0.5)) {
                finalWidth = pasterSize*(1+0.5);
            }
            if (finalWidth < pasterSize*(1-0.5)) {
                finalWidth = pasterSize*(1-0.5);
            }
            if (finalHeight > pasterSize*(1+0.5)) {
                finalHeight = pasterSize*(1+0.5);
            }
            if (finalHeight < pasterSize*(1-0.5)) {
                finalHeight = pasterSize*(1-0.5);
            }
            self.superview.bounds = CGRectMake(self.superview.bounds.origin.x, self.superview.bounds.origin.y, finalWidth, finalHeight);
            self.frame = CGRectMake(self.superview.bounds.size.width-rotateSize, self.superview.bounds.size.height-rotateSize, rotateSize, rotateSize);
            prevPoint = [recognizer locationInView:self];
        }
        /* Rotation */
        CGFloat ang = atan2([recognizer locationInView:self.superview.superview].y - self.superview.center.y, [recognizer locationInView:self.superview.superview].x - self.superview.center.x);
        CGFloat angleDiff = deltaAngle - ang;
        self.superview.transform = CGAffineTransformMakeRotation(-angleDiff);
        [self.superview setNeedsDisplay];
    }else if ([recognizer state] == UIGestureRecognizerStateEnded) {
        prevPoint = [recognizer locationInView:self.superview];
        [self.superview setNeedsDisplay];
    }
}

@end
