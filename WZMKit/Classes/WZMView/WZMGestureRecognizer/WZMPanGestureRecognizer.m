//
//  WZMPanGestureRecognizer.m
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/21.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMPanGestureRecognizer.h"
#import "WZMLogPrinter.h"

int const static WZMDirectionPanThreshold = 5;
@implementation WZMPanGestureRecognizer {
    BOOL _drag;
    int _moveX;
    int _moveY;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (_direction == WZMPanGestureRecognizerDirectionNone) {
        self.state = UIGestureRecognizerStateFailed;
    }
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    _moveX += prevPoint.x - nowPoint.x;
    _moveY += prevPoint.y - nowPoint.y;
    if (_drag == NO) {
        if (abs(_moveX) > WZMDirectionPanThreshold) {
            if (_direction == WZMPanGestureRecognizerDirectionVertical) {
                self.state = UIGestureRecognizerStateFailed;
                return;
            }
            else {
                if (_horizontalDirection == WZMPanGestureRecognizerHorizontalDirectionLeft) {
                    if (_moveX < 0) {
                        self.state = UIGestureRecognizerStateFailed;
                        return;
                    }
                }
                else if (_horizontalDirection == WZMPanGestureRecognizerHorizontalDirectionRight) {
                    if (_moveX > 0) {
                        self.state = UIGestureRecognizerStateFailed;
                        return;
                    }
                }
                _drag = YES;
            }
        }
        else if (abs(_moveY) > WZMDirectionPanThreshold) {
            if (_direction == WZMPanGestureRecognizerDirectionHorizontal) {
                self.state = UIGestureRecognizerStateFailed;
                return;
            }
            else {
                if (_verticalDirection == WZMPanGestureRecognizerVerticalDirectionUp) {
                    if (_moveY < 0) {
                        self.state = UIGestureRecognizerStateFailed;
                        return;
                    }
                }
                else if (_verticalDirection == WZMPanGestureRecognizerVerticalDirectionDown) {
                    if (_moveY > 0) {
                        self.state = UIGestureRecognizerStateFailed;
                        return;
                    }
                }
                _drag = YES;
            }
        }
    }
}

- (void)reset {
    _drag = NO;
    _moveX = 0;
    _moveY = 0;
    [super reset];
}

@end
