//
//  WZMCaptionView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/11.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMCaptionView.h"

@interface WZMCaptionView ()

@property (nonatomic, assign) BOOL editing;

@end

@implementation WZMCaptionView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captionTap:)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(captionPan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)captionTap:(UITapGestureRecognizer *)recognizer {
    self.editing = !self.editing;
    if (self.editing) {
        self.wzm_borderWidth = 0.5;
        self.wzm_borderColor = [UIColor redColor];
        if ([self.delegate respondsToSelector:@selector(captionViewBeginEdit:)]) {
            [self.delegate captionViewBeginEdit:self];
        }
    }
    else {
        self.wzm_borderWidth = 0;
        self.wzm_borderColor = [UIColor clearColor];
        if ([self.delegate respondsToSelector:@selector(captionViewEndEdit:)]) {
            [self.delegate captionViewEndEdit:self];
        }
    }
}

- (void)captionPan:(UIPanGestureRecognizer *)recognizer {
    if (self.editing == NO) return;
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:tapView];
    
    static CGRect rect;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        rect = tapView.frame;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = rect.origin.x+point_0.x;
        CGFloat y = rect.origin.y+point_0.y;
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

@end
