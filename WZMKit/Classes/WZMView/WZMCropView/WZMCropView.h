//
//  WZMCropView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/5/15.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMCropView : UIView

///剪裁框
@property (nonatomic, assign) CGRect cropFrame;
///顶点线
@property (nonatomic, assign) CGFloat cornerWidth;
@property (nonatomic, strong) UIColor *cornerColor;
@property (nonatomic, assign, getter=isShowCorner) BOOL showCorner;
///边缘线
@property (nonatomic, assign) CGFloat edgeWidth;
@property (nonatomic, strong) UIColor *edgeColor;
@property (nonatomic, assign, getter=isShowEdge) BOOL showEdge;
///分割线
@property (nonatomic, assign) CGFloat separateWidth;
@property (nonatomic, strong) UIColor *separateColor;
@property (nonatomic, assign, getter=isShowSeparate) BOOL showSeparate;
///宽高比,默认0.0,自由剪裁 最大值默认10.0 最小值默认0.1
@property (nonatomic, assign) CGFloat WHScale;
@property (nonatomic, assign) CGFloat MinWHScale;
@property (nonatomic, assign) CGFloat MaxWHScale;

@end

NS_ASSUME_NONNULL_END
