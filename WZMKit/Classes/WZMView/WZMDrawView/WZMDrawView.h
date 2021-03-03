//
//  WZMDrawView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/3.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMDrawView : UIView

@property (nonatomic, assign) BOOL lineDotted;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat imageSpacing;
@property (nonatomic, strong, nullable) NSArray *images;
@property (nonatomic, strong, nullable) UIColor *imageColor;
@property (nonatomic, strong, readonly) NSMutableArray *lines;

- (void)recover;
- (void)backforward;

@end

NS_ASSUME_NONNULL_END
