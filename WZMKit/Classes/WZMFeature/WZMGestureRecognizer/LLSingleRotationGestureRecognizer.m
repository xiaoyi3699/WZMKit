#import "LLSingleRotationGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
/*
 单手实现视图的旋转功能。
 apple提供了UIRotationGestureRecognizer可供用户实现双手旋转视图的效果，这里利用toch
 */
@implementation LLSingleRotationGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.activeRect = CGRectNull;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 判断手势数目
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        [self setState:UIGestureRecognizerStateFailed];
    }
    else {
        if (CGRectIsNull(self.activeRect)) {
            self.activeRect = self.view.bounds;
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    if (CGRectContainsPoint(self.activeRect, currentPoint)) {
        if (self.state == UIGestureRecognizerStatePossible) {
            [self setState:UIGestureRecognizerStateBegan];
        }
        else {
            [self setState:UIGestureRecognizerStateChanged];
        }
        // 获取手势作用视图的中心点
        CGPoint center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
        // 获取之前手势作用位置
        CGPoint previousPoint = [touch previousLocationInView:self.view];
        
        // 计算x和y差,然后利用tan反函数计算当前角度和手势作用之前角度
        CGFloat currentRotation = atan2f((currentPoint.y - center.y), (currentPoint.x - center.x));
        CGFloat previousRotation = atan2f((previousPoint.y - center.y), (previousPoint.x - center.x));
        
        // 得出前后手势作用旋转角度
        CGFloat rotation = (currentRotation - previousRotation);
        self.view.transform = CGAffineTransformRotate(self.view.transform, rotation);
        
        CGFloat radian = acosf(self.view.transform.a);
        // 旋转180度后，需要处理弧度的变化
        if (self.view.transform.b < 0) {
            radian = M_PI-radian;
        }
        self.rotation = radian;
    }
    else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.state == UIGestureRecognizerStateChanged) {
        [self setState:UIGestureRecognizerStateEnded];
    }
    else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self setState:UIGestureRecognizerStateFailed];
}

@end
