//
//  WZMMoreEditView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/1.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import "WZMMoreEditView.h"
#import "UIView+wzmcate.h"

@interface WZMMoreEditView ()

@property (nonatomic, assign) BOOL dotted;
@property (nonatomic, assign) BOOL addRote;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) CGFloat maxScale;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, strong) UIView *item0;
@property (nonatomic, strong) UIView *item1;
@property (nonatomic, strong) UIView *item2;
@property (nonatomic, strong) UIView *item3;
@property (nonatomic, assign) CGFloat itemSize;
@property (nonatomic, assign) CGFloat deltaAngle;
@property (nonatomic, assign) CGAffineTransform scaleTransform;
@property (nonatomic, assign) CGAffineTransform rotateTransform;

@end

@implementation WZMMoreEditView

- (instancetype)initWithFrame:(CGRect)frame {
    CGFloat itemSize = 30.0;
    CGRect rect = frame;
    rect.origin.x -= itemSize/2.0;
    rect.origin.y -= itemSize/2.0;
    rect.size.width += itemSize;
    rect.size.height += itemSize;
    self = [super initWithFrame:rect];
    if (self) {
        self.dotted = YES;
        self.itemSize = itemSize;
        self.minScale = 0.5;
        self.maxScale = 2.0;
        self.scaleTransform = CGAffineTransformIdentity;
        self.rotateTransform = CGAffineTransformIdentity;
        self.backgroundColor = [UIColor clearColor];
        UIImage *image0 = [self getImage0];
        if (image0) {
            self.item0 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.itemSize, self.itemSize)];
            self.item0.tag = 0;
            self.item0.wzm_cornerRadius = self.itemSize/2.0;
            [self addSubview:self.item0];
            
            CGRect rect = self.item0.bounds;
            rect.origin = CGPointMake((rect.size.width-20.0)/2.0, (rect.size.height-20.0)/2.0);
            rect.size = CGSizeMake(20.0, 20.0);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = image0;
            [self.item0 addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
            [self.item0 addGestureRecognizer:tapGesture];
        }
        
        UIImage *image1 = [self getImage1];
        if (image1) {
            self.item1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.itemSize, self.itemSize)];
            self.item1.tag = 1;
            self.item1.wzm_cornerRadius = self.itemSize/2.0;
            [self addSubview:self.item1];
            
            CGRect rect = self.item1.bounds;
            rect.origin = CGPointMake((rect.size.width-20.0)/2.0, (rect.size.height-20.0)/2.0);
            rect.size = CGSizeMake(20.0, 20.0);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = image1;
            [self.item1 addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
            [self.item1 addGestureRecognizer:tapGesture];
        }
        
        UIImage *image2 = [self getImage2];
        if (image2) {
            self.item2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.itemSize, self.itemSize)];
            self.item2.tag = 2;
            self.item2.wzm_cornerRadius = self.itemSize/2.0;
            [self addSubview:self.item2];
            
            CGRect rect = self.item2.bounds;
            rect.origin = CGPointMake((rect.size.width-20.0)/2.0, (rect.size.height-20.0)/2.0);
            rect.size = CGSizeMake(20.0, 20.0);
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = image2;
            [self.item2 addSubview:imageView];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
            [self.item2 addGestureRecognizer:tapGesture];
        }
        
        UIImage *image3 = [self getImage3];
        if (image3) {
            self.item3 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.itemSize, self.itemSize)];
            self.item3.tag = 3;
            self.item3.wzm_cornerRadius = self.itemSize/2.0;
            [self addSubview:self.item3];
            
            CGRect rect = self.item3.bounds;
            rect.origin = CGPointMake((rect.size.width-20.0)/2.0, (rect.size.height-20.0)/2.0);
            rect.size = CGSizeMake(20.0, 20.0);
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.image = image3;
            [self.item3 addSubview:imageView];
            
            if ([self allowRotate]) {
                UIPanGestureRecognizer *rotateGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rotateGesture:)];
                [self.item3 addGestureRecognizer:rotateGesture];
                
                self.deltaAngle = atan2(self.frame.origin.y+self.frame.size.height-self.center.y,
                                        self.frame.origin.x+self.frame.size.width-self.center.x);
            }
            else {
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapGesture:)];
                [self.item3 addGestureRecognizer:tapGesture];
            }
        }
        [self setNeedsToEdit:YES];
        [self layoutSubItemViews];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tapGesture];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self addGestureRecognizer:panGesture];
        
        if ([self allowZoom]) {
            UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
            [self addGestureRecognizer:pinchGesture];
        }
    }
    return self;
}

- (void)itemTapGesture:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(moreEditView:didSelectedIndex:)]) {
        [self.delegate moreEditView:self didSelectedIndex:recognizer.view.tag];
    }
}

//点击
- (void)tapGesture:(UITapGestureRecognizer *)recognizer {
    [self setNeedsToEdit:!self.editing];
}

//移动
- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    UIView *tapView = recognizer.view;
    CGPoint point_0 = [recognizer translationInView:self.superview];
    static CGPoint center;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        center = tapView.center;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat x = center.x+point_0.x;
        CGFloat y = center.y+point_0.y;
        if (x < 0 || x > self.superview.bounds.size.width) {
            return;
        }
        if (y < 0.0 || y > self.superview.bounds.size.height) {
            return;
        }
        tapView.center = CGPointMake(x, y);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
             recognizer.state == UIGestureRecognizerStateCancelled) {
        
    }
}

//捏合
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer {
    static CGAffineTransform transform;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        transform = self.scaleTransform;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGAffineTransform transform2 = CGAffineTransformScale(transform, recognizer.scale, recognizer.scale);
        CGFloat scale =  sqrt(transform2.a * transform2.a + transform2.c * transform2.c);
        if (scale < self.minScale) {
            transform2 = CGAffineTransformMakeScale(self.minScale, self.minScale);
        }
        else if (scale > self.maxScale) {
            transform2 = CGAffineTransformMakeScale(self.maxScale, self.maxScale);
        }
        self.scaleTransform = transform2;
        self.transform = CGAffineTransformConcat(self.rotateTransform, self.scaleTransform);
    }
}

//旋转
- (void)rotateGesture:(UIPanGestureRecognizer *)recognizer {
    static CGAffineTransform transform;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        transform = self.rotateTransform;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat ang = atan2([recognizer locationInView:self.superview].y - self.center.y, [recognizer locationInView:self.superview].x - self.center.x);
        CGFloat angleDiff = self.deltaAngle - ang;
        CGAffineTransform transform2 = CGAffineTransformMakeRotation(-angleDiff);
        self.rotateTransform = transform2;
        self.transform = CGAffineTransformConcat(self.rotateTransform, self.scaleTransform);
    }
}

//编辑状态
- (void)setNeedsToEdit:(BOOL)edit {
    self.dotted = edit;
    self.editing = edit;
    self.item0.hidden = !edit;
    self.item1.hidden = !edit;
    self.item2.hidden = !edit;
    self.item3.hidden = !edit;
}

//布局
- (void)layoutSubItemViews {
    if (self.item0) {
        CGRect rect = self.item0.frame;
        rect.origin = CGPointMake(0.0, 0.0);
        self.item0.frame = rect;
    }
    if (self.item1) {
        CGRect rect = self.item1.frame;
        rect.origin = CGPointMake(self.bounds.size.width-self.itemSize, 0.0);
        self.item1.frame = rect;
    }
    if (self.item2) {
        CGRect rect = self.item2.frame;
        rect.origin = CGPointMake(0.0, self.bounds.size.height-self.itemSize);
        self.item2.frame = rect;
    }
    if (self.item3) {
        CGRect rect = self.item3.frame;
        rect.origin = CGPointMake(self.bounds.size.width-self.itemSize, self.bounds.size.height-self.itemSize);
        self.item3.frame = rect;
    }
}

- (BOOL)allowZoom {
    return YES;
}

- (BOOL)allowRotate {
    return YES;
}

- (UIImage *)getImage0 {
    return nil;
}

- (UIImage *)getImage1 {
    return nil;
}

- (UIImage *)getImage2 {
    return nil;
}

- (UIImage *)getImage3 {
    return nil;
}

- (void)setDotted:(BOOL)dotted {
    if (_dotted == dotted) return;
    _dotted = dotted;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (self.dotted == NO) return;
    CGFloat lineWidth = 1.0;
    CGFloat lengths[]= {6.0, 4.0};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineDash(context, 0.0, lengths, 2);
    CGRect rect2 = self.bounds;
    rect2.origin.x = lineWidth;
    rect2.origin.y = lineWidth;
    rect2.size.width -= lineWidth*2;
    rect2.size.height -= lineWidth*2;
    CGContextAddRect(context, rect2);
    CGContextStrokePath(context);
}

@end
