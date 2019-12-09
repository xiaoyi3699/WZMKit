//
//  WZMNoteModel.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    WZMNoteModelTypeNormal = 0, //默认
    WZMNoteModelTypeGradient,   //渐变
} WZMNoteTextType;

typedef enum : NSInteger {
    WZMNoteTextAnimationTypeSingle,     //单字高亮
    WZMNoteTextAnimationTypeOneByOne,   //逐字高亮(卡拉OK)
} WZMNoteTextAnimationType;

@interface WZMNoteModel : NSObject

///是否显示音符,默认YES
@property (nonatomic, assign) BOOL showNote;
///是否正在编辑
@property (nonatomic, assign) BOOL editing;
///是否正在显示
@property (nonatomic, assign) BOOL showing;
///字幕
@property (nonatomic, strong) NSString *text;
///设置字幕position,会自动换行
@property (nonatomic, assign) CGPoint textPosition;
///字幕的最大宽度
@property (nonatomic, assign) CGFloat textMaxW;
///旋转的角度
@property (nonatomic, assign) CGFloat angle;
///字体、颜色相关
@property (nonatomic, assign) CFTypeRef textFont;
@property (nonatomic, assign) CGFloat textFontSize;
@property (nonatomic, strong) UIColor *backgroundColor;
///默认
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highTextColor;
///渐变
@property (nonatomic, strong) NSArray *textColors;
@property (nonatomic, strong) NSArray *highTextColors;
///单个字
@property (nonatomic, strong) NSArray *textLayers1; //预览时layer
@property (nonatomic, strong) NSArray *graLayers1;  //预览时layer
@property (nonatomic, strong) NSArray *textLayers2; //合成时layer
@property (nonatomic, strong) NSArray *graLayers2;  //合成时layer
///字幕整个试图
@property (nonatomic, strong) CALayer *contentLayer1; //预览时layer
@property (nonatomic, strong) CALayer *contentLayer2; //合成时layer
///音符
@property (nonatomic, strong) UIImage *noteImage;
///音符轨迹
@property (nonatomic, strong) NSArray *points;
///起止时间
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat duration;

///字幕样式
@property (nonatomic, assign) WZMNoteTextType textType;
@property (nonatomic, assign) WZMNoteTextAnimationType textAnimationType;

///最大宽度每行字数的最大值,即列数
- (NSInteger)textColumns;
///出总共有几行
- (NSInteger)textRows;
///字幕坐标
- (CGRect)textFrame;

@end
