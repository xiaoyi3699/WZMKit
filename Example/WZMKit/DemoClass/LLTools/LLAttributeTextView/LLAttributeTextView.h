//
//  LLImageTextView.h
//  LLFoundation
//
//  Created by wangzhaomeng on 16/11/10.
//  Copyright © 2016年 MaoChao Network Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    LLFontStyleCustom,     //用户自定义字体
    LLFontStyleSystems     //系统默认字体,会跟随系统设置改变字体大小,一般不使用
    
} LLFontStyle;

@interface LLAttributeTextView : UITextView

@property (nonatomic, assign) LLFontStyle fontStyle; //字体样式
@property (nonatomic, assign, getter=isVerticalCenter) BOOL verticalCenter; //文字是否垂直居中

///唯一初始化方式
- (id)initWithFrame:(CGRect)frame;

/**
 添加链接
 */
- (void)addLink:(NSString *)link range:(NSRange)range;

/**
 设置文字环绕的rect
 */
- (void)setSurroundRect:(CGRect)rect;

/**
 设置文字环绕的path
 */
- (void)setSurroundPath:(UIBezierPath *)path;

/**
 设置文字环绕的paths
 */
- (void)setSurroundPaths:(NSArray<UIBezierPath *> *)paths;

/* textView点击链接的代理
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSLog(@"=============%@",URL);
    return NO;
}
*/
@end
