//
//  WZMArrowLayer.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/8.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WZMArrowViewType) {
    WZMArrowViewTypeArrow = 0,   //单箭头
    WZMArrowViewTypeLine,        //直线
    WZMArrowViewTypeRulerArrow,  //双箭头尺
    WZMArrowViewTypeRulerLine    //双直线尺
};

typedef NS_ENUM(NSUInteger, WZMArrowViewTouchType) {
    WZMArrowViewTouchTypeNone = 0,
    WZMArrowViewTouchTypeStart,
    WZMArrowViewTouchTypeMid,
    WZMArrowViewTouchTypeEnd,
};

@interface WZMArrowLayer : CAShapeLayer

@property (nonatomic, assign) WZMArrowViewType type;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) BOOL allowDrawArrow;

- (WZMArrowViewTouchType)caculateLocationWithPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
