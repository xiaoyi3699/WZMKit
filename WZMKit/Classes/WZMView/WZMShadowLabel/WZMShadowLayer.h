//
//  WZMShadowLayer.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2020/9/10.
//  Copyright © 2020 wangzhaomeng. All rights reserved.
//  外描边

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMShadowLayer : CATextLayer

///外描边颜色
@property (strong, nonatomic, nullable) UIColor *strokeColor;
///外描边宽度
@property (assign, nonatomic) CGFloat strokeWidth;

@end

NS_ASSUME_NONNULL_END
