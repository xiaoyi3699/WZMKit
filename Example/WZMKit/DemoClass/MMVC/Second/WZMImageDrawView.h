//
//  WZMImageDrawView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2021/2/22.
//  Copyright © 2021 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMImageDrawView : UIView

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong, readonly) NSMutableArray *lines;

- (void)recover;
- (void)backforward;

@end

NS_ASSUME_NONNULL_END
