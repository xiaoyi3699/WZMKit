//
//  WZMNoteModel.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMNoteModel : NSObject

///是否允许显示,默认YES
@property (nonatomic, assign) BOOL allowShow;
///字幕
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGRect textFrame;
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

@end
