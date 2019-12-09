//
//  WZMNoteModel.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMNoteModel : NSObject

///是否显示音符,默认YES
@property (nonatomic, assign) BOOL showNote;
///字幕
@property (nonatomic, strong) NSString *text;
///设置字幕position,会自动换行
@property (nonatomic, assign) CGPoint textPosition;
///字幕的最大宽度
@property (nonatomic, assign) CGFloat textMaxW;
///字体、颜色相关
@property (nonatomic, assign) CFTypeRef textFont;
@property (nonatomic, assign) CGFloat textFontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *highTextColor;
@property (nonatomic, strong) UIColor *backgroundColor;
///音符
@property (nonatomic, strong) UIImage *noteImage;
///起止时间
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat duration;
///单个字
@property (nonatomic, strong) NSArray *textLayers;
@property (nonatomic, strong) NSArray *graLayers;
///音符轨迹
@property (nonatomic, strong) NSArray *points;
///单个字的动画
@property (nonatomic, strong) NSArray *animations;

///最大宽度每行字数的最大值,即列数
- (NSInteger)textColumns;
///出总共有几行
- (NSInteger)textRows;
///字幕坐标
- (CGRect)textFrame;

@end
