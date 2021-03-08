//
//  WZMArrowView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/3/8.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMArrowLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface WZMArrowView : UIView

@property (nonatomic, assign) WZMArrowViewType type;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectedColor;

- (void)recover;
- (void)backforward;

@end

NS_ASSUME_NONNULL_END
