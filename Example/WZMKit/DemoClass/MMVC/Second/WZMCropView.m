//
//  WZMCropView.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/15.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import "WZMCropView.h"

typedef NS_ENUM(NSInteger, WZMCropMoveType) {
    WZMCropMoveTypeNone = 0,
    WZMCropMoveTypeOther,
    WZMCropMoveTypeLeftTop,
    WZMCropMoveTypeRightTop,
    WZMCropMoveTypeLeftDowm,
    WZMCropMoveTypeRightDown
};

@interface WZMCropView ()

@property (nonatomic, assign) CGRect startFrame;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat cornerLenght;
@property (nonatomic, assign) WZMCropMoveType moveType;

@end

@implementation WZMCropView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.showCorner = YES;
        self.cornerWidth = 5.0;
        self.cornerColor = [UIColor greenColor];
        
        self.showEdge = YES;
        self.edgeWidth = 0.5;
        self.edgeColor = [UIColor redColor];
        
        self.showSeparate = YES;
        self.separateWidth = 0.5;
        self.separateColor = [UIColor redColor];
        
        self.cornerLenght = 40.0;
        self.cropFrame = self.bounds;
        self.moveType = WZMCropMoveTypeNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //绘制边缘线
    if (self.isShowEdge) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.edgeColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, self.edgeWidth);
        //边缘线
        CGRect cropFrame = self.cropFrame;
        cropFrame.origin.x += self.edgeWidth;
        cropFrame.origin.y += self.edgeWidth;
        cropFrame.size.width -= self.edgeWidth*2;
        cropFrame.size.height -= self.edgeWidth*2;
        CGContextAddRect(context, cropFrame);
        CGContextStrokePath(context);
    }
    //绘制分割线
    if (self.isShowSeparate) {
        CGFloat w = self.cropFrame.size.width;
        CGFloat h = self.cropFrame.size.height;
        CGFloat minX = CGRectGetMinX(self.cropFrame);
        CGFloat minY = CGRectGetMinY(self.cropFrame);
        //分割线设置为虚线
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat lengths2[]= {6.0, 4.0};
        CGContextSetStrokeColorWithColor(context, self.separateColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, self.separateWidth);
        CGContextSetLineDash(context, 0.0, lengths2, 2);
        //横向分割线
        CGContextMoveToPoint(context, minX, minY+h/3.0);
        CGContextAddLineToPoint(context, minX+w, minY+h/3.0);
        CGContextMoveToPoint(context, minX, minY+h*2.0/3.0);
        CGContextAddLineToPoint(context, minX+w, minY+h*2.0/3.0);
        //纵向分割线
        CGContextMoveToPoint(context, minX+w/3.0, minY);
        CGContextAddLineToPoint(context, minX+w/3.0, minY+h);
        CGContextMoveToPoint(context, minX+w*2.0/3.0, minY);
        CGContextAddLineToPoint(context, minX+w*2.0/3.0, minY+h);
        CGContextStrokePath(context);
    }
    //绘制顶点线
    if (self.isShowCorner) {
        CGFloat w = self.cropFrame.size.width;
        CGFloat h = self.cropFrame.size.height;
        CGFloat minX = CGRectGetMinX(self.cropFrame);
        CGFloat minY = CGRectGetMinY(self.cropFrame);
        //顶点配置取消虚线
        CGFloat lengths3[]= {};
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.cornerColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, self.cornerWidth);
        CGContextSetLineDash(context, 0.0, lengths3, 0);
        //左上
        CGContextMoveToPoint(context, minX+self.cornerWidth/2.0, minY+self.cornerLenght);
        CGContextAddLineToPoint(context, minX+self.cornerWidth/2.0, minY+self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+self.cornerLenght, minY+self.cornerWidth/2.0);
        //右上
        CGContextMoveToPoint(context, minX+w-self.cornerLenght, minY+self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+w-self.cornerWidth/2.0, minY+self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+w-self.cornerWidth/2.0, minY+self.cornerLenght);
        //左下
        CGContextMoveToPoint(context, minX+self.cornerWidth/2.0, minY+h-self.cornerLenght);
        CGContextAddLineToPoint(context, minX+self.cornerWidth/2.0, minY+h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+self.cornerLenght, minY+h-self.cornerWidth/2.0);
        //右下
        CGContextMoveToPoint(context, minX+w-self.cornerLenght, minY+h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+w-self.cornerWidth/2.0, minY+h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, minX+w-self.cornerWidth/2.0, minY+h-self.cornerLenght);
        CGContextStrokePath(context);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.cropFrame, point)) {
        self.startPoint = point;
        self.startFrame = self.cropFrame;
        CGFloat minX = CGRectGetMinX(self.cropFrame);
        CGFloat minY = CGRectGetMinY(self.cropFrame);
        if (CGRectContainsPoint(CGRectMake(minX, minY, 40.0, 40.0), point)) {
            //左上
            self.moveType = WZMCropMoveTypeLeftTop;
        }
        else if (CGRectContainsPoint(CGRectMake(minX+self.cropFrame.size.width-40, minY, 40.0, 40.0), point)) {
            //右上
            self.moveType = WZMCropMoveTypeRightTop;
        }
        else if (CGRectContainsPoint(CGRectMake(minX, minY+self.cropFrame.size.height-40, 40.0, 40.0), point)) {
            //左下
            self.moveType = WZMCropMoveTypeLeftDowm;
        }
        else if (CGRectContainsPoint(CGRectMake(minX+self.cropFrame.size.width-40, minY+self.cropFrame.size.height-40, 40.0, 40.0), point)) {
            //右下
            self.moveType = WZMCropMoveTypeRightDown;
        }
        else {
            //其余
            self.moveType = WZMCropMoveTypeOther;
        }
    }
    else {
        self.moveType = WZMCropMoveTypeNone;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.moveType == WZMCropMoveTypeNone) return;
    UITouch *touch = touches.anyObject;
    CGPoint movePoint = [touch locationInView:self];
    CGFloat dx = movePoint.x - self.startPoint.x;
    CGFloat dy = movePoint.y - self.startPoint.y;
    NSLog(@"x====%@==y====%@",@(dx),@(dy));
    CGRect cropFrame = self.startFrame;
    if (self.moveType == WZMCropMoveTypeLeftTop) {
        //左上
        if (cropFrame.origin.x + dx <= 0.0) {
            dx = 0.0;
        }
        if (cropFrame.origin.y + dy <= 0.0) {
            dy = 0.0;
        }
        cropFrame.origin.x += dx;
        cropFrame.origin.y += dy;
        cropFrame.size.width -= dx;
        cropFrame.size.height -= dy;
        self.cropFrame = cropFrame;
        [self setNeedsDisplay];
    }
    else if (self.moveType == WZMCropMoveTypeRightTop) {
        //右上
    }
    else if (self.moveType == WZMCropMoveTypeLeftDowm) {
        //左下
    }
    else if (self.moveType == WZMCropMoveTypeRightDown) {
        //右下
    }
    else {
        //其余
    }
}

@end
