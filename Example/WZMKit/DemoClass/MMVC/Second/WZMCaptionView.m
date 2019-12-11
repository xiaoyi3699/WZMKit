//
//  WZMCaptionView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/11.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMCaptionView.h"

@interface WZMCaptionView ()

@property (nonatomic, assign) BOOL showing;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *changeView;

@end

@implementation WZMCaptionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captionTap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionPan:)];
        [self addGestureRecognizer:pan];
        
        self.editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.editView.backgroundColor = [UIColor brownColor];
        [self addSubview:self.editView];
        
        UITapGestureRecognizer *editTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTap:)];
        [self.editView addGestureRecognizer:editTap];
        
        self.changeView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-20, 20, 20)];
        self.changeView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.changeView];
        
        UIPanGestureRecognizer *changePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(changePan:)];
        [self.changeView addGestureRecognizer:changePan];
    }
    return self;
}

//显示字幕view
- (void)captionTap:(UITapGestureRecognizer *)recognizer {
    self.showing = !self.showing;
    if (self.showing) {
        self.wzm_borderWidth = 0.5;
        self.wzm_borderColor = [UIColor redColor];
        if ([self.delegate respondsToSelector:@selector(captionViewShow:)]) {
            [self.delegate captionViewShow:self];
        }
    }
    else {
        self.wzm_borderWidth = 0;
        self.wzm_borderColor = [UIColor clearColor];
        if ([self.delegate respondsToSelector:@selector(captionViewDismiss:)]) {
            [self.delegate captionViewDismiss:self];
        }
    }
}

//移动字幕
- (void)captionPan:(UIPanGestureRecognizer *)recognizer {
    if (self.showing == NO) return;
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:tapView];
    
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = tapView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = rect.origin.x+point_0.x;
        CGFloat y = rect.origin.y+point_0.y;
        
        if (x < 0 || x > self.superview.wzm_width-tapView.frame.size.width) {
            x = tapView.frame.origin.x;
        }
        if (y < 0 || y > self.superview.wzm_height-tapView.frame.size.height) {
            y = tapView.frame.origin.y;
        }
        tapView.frame = CGRectMake(x, y, tapView.frame.size.width, tapView.frame.size.height);
        if ([self.delegate respondsToSelector:@selector(captionView:changeFrame:)]) {
            [self.delegate captionView:self changeFrame:tapView.frame];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        if ([self.delegate respondsToSelector:@selector(captionView:endChangeFrame:oldFrame:)]) {
            [self.delegate captionView:self endChangeFrame:tapView.frame oldFrame:rect];
        }
    }
}

//左上角编辑按钮
- (void)editTap:(UITapGestureRecognizer *)recognizer {
    
}

//左下角调整视图宽度
- (void)changePan:(UIPanGestureRecognizer *)recognizer {
    if (self.showing == NO) return;
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:tapView];
    
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = self.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = rect.origin.x+point_0.x;
        if (self.wzm_maxX - x < self.minWidth) {
            x = self.wzm_maxX - self.minWidth;
        }
        if (x < 0) {
            x = 0;
        }
        self.wzm_mutableMinX = x;
        self.changeView.frame = CGRectMake(0, self.frame.size.height-20, 20, 20);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        //宽度调整结束
        if ([self.delegate respondsToSelector:@selector(captionView:endChangeFrame:oldFrame:)]) {
            [self.delegate captionView:self endChangeFrame:self.frame oldFrame:rect];
            self.changeView.frame = CGRectMake(0, self.frame.size.height-20, 20, 20);
            if (self.wzm_maxY > self.superview.wzm_height) {
                CGRect oldFrame = self.frame;
                //当最下方超出屏幕时,改变frame
                self.wzm_maxY = self.superview.wzm_height;
                CGRect newFrame = self.frame;
                if ([self.delegate respondsToSelector:@selector(captionView:changeFrame:)]) {
                    [self.delegate captionView:self changeFrame:self.frame];
                }
                //改变字幕相关参数
                if ([self.delegate respondsToSelector:@selector(captionView:endChangeFrame:oldFrame:)]) {
                    [self.delegate captionView:self endChangeFrame:newFrame oldFrame:oldFrame];
                }
            }
        }
    }
}

@end
