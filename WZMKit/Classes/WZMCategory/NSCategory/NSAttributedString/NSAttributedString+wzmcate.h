//
//  NSMutableAttributedString+wzmcate.h
//  test
//
//  Created by wangzhaomeng on 16/8/5.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COLOR_NAME(_color_)   NSForegroundColorAttributeName:_color_
#define FONT_NAME(_font_)     NSFontAttributeName:_font_
#define STYLE_NAME(_style_)   NSParagraphStyleAttributeName:_style_

@interface NSAttributedString (wzmcate)

/**
 获取富文本的路径
 */
- (UIBezierPath *)wzm_getBezierPath;

@end


@interface NSMutableAttributedString (wzmcate)

/**
 给富文本添加图片
 */
- (void)wzm_setImage:(UIImage *)image rect:(CGRect)rect range:(NSRange)range;

/**
 给富文本添加图片
 */
- (void)wzm_insertImage:(UIImage *)image rect:(CGRect)rect index:(NSInteger)index;

/**
 给富文本添加段落样式
 */
- (void)wzm_addParagraphStyle:(NSParagraphStyle *)style;

/**
 给富文本添加链接
 */
- (void)wzm_addLink:(NSString *)link range:(NSRange)range;

/**
 给富文本添加文字颜色
 */
- (void)wzm_addForegroundColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加字体
 */
- (void)wzm_addFont:(UIFont *)font range:(NSRange)range;

/**
 给富文本添加删除线
 */
- (void)wzm_addSingleDeletelineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加单下划线
 */
- (void)wzm_addSingleUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加双下划线
 */
- (void)wzm_addDoubleUnderlineColor:(UIColor *)color range:(NSRange)range;

/**
 给富文本添加空心字
 */
- (void)wzm_addStrokeWidth:(CGFloat)width range:(NSRange)range;

/**
 凸版印刷效果
 */
- (void)wzm_addTextEffectWithRange:(NSRange)range;

@end
