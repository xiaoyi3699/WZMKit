//
//  UIButton+LLHelper.h
//  LLCommonSDK
//
//  Created by WangZhaomeng on 2017/12/13.
//  Copyright © 2017年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LLHelper)

/**
 *  重新设置按钮图标和标题位置
 *
 *  @param imageFrame 图标位置, 传入CGRectNull表示不改变
 *  @param titieFrame 标题位置, 传入CGRectNull表示不改变
 */
- (void)setImageFrame:(CGRect)imageFrame titleFrame:(CGRect)titieFrame;

@end
