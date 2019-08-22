//
//  WZMNavigationController.m
//  LLFeature
//
//  Created by WangZhaomeng on 2017/9/21.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import "WZMNavigationController.h"
#import "WZMTabBarController.h"
#import "UIWindow+WZMTransformAnimation.h"

@interface WZMNavigationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray<UIImage *> *childVCImages; //保存截屏的数组

@end

#define LL_CUSTOM_POP 0
#define LL_Screen_ShotView [WZMTabBarController tabBarController].screenShotView
@implementation WZMNavigationController {
    UIWindow *_window;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //系统的返回手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    
    //自定义的滑动返回手势
//    self.interactivePopGestureRecognizer.enabled = NO;
//    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging_0:)];
//    popRecognizer.delegate = self;
//    [self.view addGestureRecognizer:popRecognizer];
}

#pragma mark - 滑动返回手势
- (void)dragging_0:(UIPanGestureRecognizer *)recognizer{
    //如果只有1个子控制器,停止拖拽
    if (self.viewControllers.count <= 1) return;
    //如果页面滑动返回被关闭,停止拖拽
    if ([self.topViewController respondsToSelector:@selector(ll_navigationShouldDrag)]) {
        if ([self.topViewController ll_navigationShouldDrag] == NO) {
            return;
        }
    }
    //在x方向上移动的距离
    CGFloat tx = [recognizer translationInView:self.view].x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        //添加截图到最后面
        LL_Screen_ShotView.hidden = NO;
        LL_Screen_ShotView.maskView.alpha = 0.5;
        LL_Screen_ShotView.imageView.image = [self.childVCImages lastObject];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged){
        //移动view
        if (tx>10) {
            //在x方向上移动的距离除以屏幕的宽度
            CGFloat width_scale = (tx-10)/self.view.bounds.size.width;
            self.view.transform = CGAffineTransformMakeTranslation(tx-10, 0);
            LL_Screen_ShotView.maskView.alpha = 0.5-width_scale*0.5;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //决定pop还是还原
        if (tx >= 100) {
            [UIView animateWithDuration:0.25 animations:^{
                LL_Screen_ShotView.maskView.alpha = 0;
                self.view.transform = CGAffineTransformMakeTranslation(self.view.bounds.size.width, 0);
            } completion:^(BOOL finished) {
                [self popViewControllerAnimated:NO];
                LL_Screen_ShotView.hidden = YES;
                self.view.transform = CGAffineTransformIdentity;
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.transform = CGAffineTransformIdentity;
                LL_Screen_ShotView.maskView.alpha = 0.5;
            } completion:^(BOOL finished) {
                LL_Screen_ShotView.hidden = YES;
            }];
        }
    }
}

- (void)dragging_1:(UIPanGestureRecognizer *)recognizer{
    //如果只有1个子控制器,停止拖拽
    if (self.viewControllers.count <= 1) return;
    //如果页面滑动返回被关闭,停止拖拽
    if ([self.topViewController respondsToSelector:@selector(ll_navigationShouldDrag)]) {
        if ([self.topViewController ll_navigationShouldDrag] == NO) {
            return;
        }
    }
    //在x方向上移动的距离
    CGFloat tx = [recognizer translationInView:self.view].x;
    static CGFloat anchorX = 0.8; //锚点x
    static CGFloat anchorY = 1.0; //锚点y
    static CGFloat angle = 50.0;  //最终角度
    static CGFloat popL  = 100.0; //pop临界点
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        CGRect rect = self.view.frame;
        rect.origin.x += rect.size.width*(anchorX-0.5);
        rect.origin.y += rect.size.height*(anchorY-0.5);
        self.view.frame = rect;
        
        self.view.layer.anchorPoint = CGPointMake(anchorX, anchorY);
        
        //添加截图到最后面
        LL_Screen_ShotView.hidden = NO;
        LL_Screen_ShotView.maskView.alpha = 0.5;
        LL_Screen_ShotView.imageView.image = [self.childVCImages lastObject];
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged){
        //移动view
        if (tx>10) {
            //在x方向上移动的距离除以屏幕的宽度
            CGFloat width_scale = (tx-10)/self.view.bounds.size.width;
            LL_Screen_ShotView.maskView.alpha = 0.5-width_scale*0.5;
            
            CGFloat pop_scale = popL/self.view.bounds.size.width;
            
            if (width_scale > pop_scale) {
                self.view.alpha = (1.0+pop_scale)-width_scale;
            }
            [self.view wzm_transform3DMakeRotationX:0 Y:0 Z:width_scale*angle];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        void(^restoration)(void) = ^{
            LL_Screen_ShotView.hidden = YES;
            self.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [self.view wzm_transform3DMakeRotationX:0 Y:0 Z:0];
            CGRect rect = self.view.frame;
            rect.origin.x -= rect.size.width*(anchorX-0.5);
            rect.origin.y -= rect.size.height*(anchorY-0.5);
            self.view.frame = rect;
        };
        
        //决定pop还是还原
        if (tx >= popL) {
            [UIView animateWithDuration:0.25 animations:^{
                self.view.alpha = 0;
                [self.view wzm_transform3DMakeRotationX:0 Y:0 Z:angle];
                LL_Screen_ShotView.maskView.alpha = 0;
            } completion:^(BOOL finished) {
                self.view.alpha = 1;
                [self popViewControllerAnimated:NO];
                restoration();
            }];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                [self.view wzm_transform3DMakeRotationX:0 Y:0 Z:0];
                LL_Screen_ShotView.maskView.alpha = 0.5;
            } completion:^(BOOL finished) {
                restoration();
            }];
        }
    }
}

#pragma mark - super method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        [self createScreenShot];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    [self.childVCImages removeLastObject];
    return [super popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSArray *viewControllers = [super popToViewController:viewController animated:animated];
    if (self.childVCImages.count >= viewControllers.count){
        for (int i = 0; i < viewControllers.count; i++) {
            [self.childVCImages removeLastObject];
        }
    }
    return viewControllers;
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    [self.childVCImages removeAllObjects];
    return [super popToRootViewControllerAnimated:animated];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForScreenEdgesDeferringSystemGestures {
    return self.topViewController;
}

#pragma mark - UIGestureRecognizerDelegate
//是否响应触摸事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (self.viewControllers.count <= 1) return NO;
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        UIViewController *topVC = self.topViewController;
        if ([topVC respondsToSelector:@selector(ll_navigationShouldDrag)]) {
            return [topVC ll_navigationShouldDrag];
        }
        return YES;
    }
    else {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            CGPoint point = [touch locationInView:gestureRecognizer.view];
            if (point.x <= 100) {//设置手势触发区
                return YES;
            }
        }
        return NO;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        
        UIViewController *topVC = self.topViewController;
        if ([topVC respondsToSelector:@selector(ll_navigationShouldDrag)]) {
            return [topVC ll_navigationShouldDrag];
        }
        return YES;
    }
    else {
        if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
            CGFloat tx = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view].x;
            if (tx < 0) {
                return NO;
            }
        }
        return YES;
    }
}

//是否与其他手势共存，一般使用默认值(默认返回NO：不与任何手势共存)
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    //UIScrollView的滑动冲突
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        
        UIScrollView *scrollow = (UIScrollView *)otherGestureRecognizer.view;
        if (scrollow.bounds.size.width >= scrollow.contentSize.width) {
            return NO;
        }
        if (scrollow.contentOffset.x == 0) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - public method

#pragma mark - private method
- (void)createScreenShot {
    
    if (LL_CUSTOM_POP) {
        if (self.childViewControllers.count == self.childVCImages.count+1) {
            if (_window == nil) {
                _window = [UIApplication sharedApplication].delegate.window;
            }
            UIImage *image;
            if (_window.screenImage) {
                image = _window.screenImage;
                _window.screenImage = nil;
            }
            else {
                UIGraphicsBeginImageContextWithOptions(_window.bounds.size, YES, 0);
                [_window.layer renderInContext:UIGraphicsGetCurrentContext()];
                image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            [self.childVCImages addObject:image];
        }
    }
}

#pragma mark - lazy load
- (NSMutableArray<UIImage *> *)childVCImages {
    if (_childVCImages == nil) {
        _childVCImages = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _childVCImages;
}

@end
