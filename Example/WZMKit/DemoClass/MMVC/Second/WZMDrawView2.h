//
//  WZMDrawView2.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/3.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMDrawView2 : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;

- (void)recover;
- (void)backforward;

@end

NS_ASSUME_NONNULL_END
