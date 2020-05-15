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
        CGRect rect2 = self.bounds;
        rect2.origin.x = self.edgeWidth;
        rect2.origin.y = self.edgeWidth;
        rect2.size.width -= self.edgeWidth*2;
        rect2.size.height -= self.edgeWidth*2;
        CGContextAddRect(context, rect2);
        CGContextStrokePath(context);
    }
    //绘制分割线
    if (self.isShowSeparate) {
        CGFloat w = rect.size.width;
        CGFloat h = rect.size.height;
        //分割线设置为虚线
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat lengths2[]= {6.0, 4.0};
        CGContextSetStrokeColorWithColor(context, self.separateColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, self.separateWidth);
        CGContextSetLineDash(context, 0.0, lengths2, 2);
        //横向分割线
        CGContextMoveToPoint(context, 0.0, w/3.0);
        CGContextAddLineToPoint(context, w, w/3.0);
        CGContextMoveToPoint(context, 0.0, w*2.0/3.0);
        CGContextAddLineToPoint(context, w, w*2.0/3.0);
        //纵向分割线
        CGContextMoveToPoint(context, h/3.0, 0.0);
        CGContextAddLineToPoint(context, h/3.0, w);
        CGContextMoveToPoint(context, h*2.0/3.0, 0.0);
        CGContextAddLineToPoint(context, h*2.0/3.0, w);
        CGContextStrokePath(context);
    }
    //绘制顶点线
    if (self.isShowCorner) {
        CGFloat w = rect.size.width;
        CGFloat h = rect.size.height;
        //顶点配置取消虚线
        CGFloat lengths3[]= {};
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, self.cornerColor.CGColor);
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        CGContextSetLineWidth(context, self.cornerWidth);
        CGContextSetLineDash(context, 0.0, lengths3, 0);
        //左上
        CGContextMoveToPoint(context, self.cornerWidth/2.0, self.cornerLenght);
        CGContextAddLineToPoint(context, self.cornerWidth/2.0, self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, self.cornerLenght, self.cornerWidth/2.0);
        //右上
        CGContextMoveToPoint(context, w-self.cornerLenght, self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, w-self.cornerWidth/2.0, self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, w-self.cornerWidth/2.0, self.cornerLenght);
        //左下
        CGContextMoveToPoint(context, self.cornerWidth/2.0, h-self.cornerLenght);
        CGContextAddLineToPoint(context, self.cornerWidth/2.0, h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, self.cornerLenght, h-self.cornerWidth/2.0);
        //右下
        CGContextMoveToPoint(context, w-self.cornerLenght, h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, w-self.cornerWidth/2.0, h-self.cornerWidth/2.0);
        CGContextAddLineToPoint(context, w-self.cornerWidth/2.0, h-self.cornerLenght);
        CGContextStrokePath(context);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(self.cropFrame, point)) {
        if (CGRectContainsPoint(CGRectMake(0.0, 0.0, 40.0, 40.0), point)) {
            //左上
            self.moveType = WZMCropMoveTypeLeftTop;
        }
        else if (CGRectContainsPoint(CGRectMake(self.cropFrame.size.width-40, 0.0, 40.0, 40.0), point)) {
            //右上
            self.moveType = WZMCropMoveTypeRightTop;
        }
        else if (CGRectContainsPoint(CGRectMake(0.0, self.cropFrame.size.height-40, 40.0, 40.0), point)) {
            //左下
            self.moveType = WZMCropMoveTypeLeftDowm;
        }
        else if (CGRectContainsPoint(CGRectMake(self.cropFrame.size.width-40, self.cropFrame.size.height-40, 40.0, 40.0), point)) {
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
    if (self.moveType == WZMCropMoveTypeLeftTop) {
        //左上
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
