//
//  UIImageView+wzmcate.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/7.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (wzmcate)

///添加倒影
- (void)wzm_reflection;

///画水印
- (void)wzm_setImage:(UIImage *)image withWaterMark:(UIImage *)mark inRect:(CGRect)rect;

@end
