//
//  UILabel+wzmcate.h
//  WZMFoundation
//
//  Created by Mr.Wang on 16/12/21.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"

@interface UILabel (wzmcate)

///文字渐变
- (void)wzm_textGradientColors:(NSArray *)colors gradientType:(WZMGradientType)type;

///文字渐变
- (void)wzm_textGradientColorWithGradientType:(WZMGradientType)type;

@end
