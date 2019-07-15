//
//  LLSegmentedView.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/15.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSegmentedCell.h"

@protocol LLSegmentedViewDelegate;

@interface LLSegmentedView : UIView

///字体
@property (nonatomic, strong) UIFont  *font;
///未选中颜色
@property (nonatomic, strong) UIColor *normalColor;
///选中颜色
@property (nonatomic, strong) UIColor *selectedColor;
///选中时的下划线颜色
@property (nonatomic, strong) UIColor *lineColor;
///当前索引值
@property (nonatomic, assign) NSInteger index;
///选项
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, weak) id<LLSegmentedViewDelegate> delegate;

@end

@protocol LLSegmentedViewDelegate <NSObject>

@optional
- (void)segmentedView:(LLSegmentedView *)segmentedView selectedAtIndex:(NSInteger)index;

@end
