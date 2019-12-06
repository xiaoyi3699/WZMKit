//
//  WZMNoteConfig.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMNoteConfig : NSObject

///字幕
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CFTypeRef textFont;
@property (nonatomic, assign) CGFloat textFontSize;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
///音符
@property (nonatomic, strong) UIImage *noteImage;
///起止时间
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat duration;

@end
