//
//  WZMCaptionModel.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMCaptionModel.h"

@implementation WZMCaptionModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.showing = NO;
        self.editing = NO;
        self.angle = 0.0;
        self.showNote = YES;
        self.textMaxW = 0.0;
        self.textMaxH = 0.0;
        self.text = @"我是一个字幕";
        self.textFont = (__bridge CFTypeRef)(@"Helvetica");
        self.textFontSize = 15;
        self.textColor = [UIColor whiteColor];
        self.highTextColor = [UIColor redColor];
        self.textColors = @[[UIColor grayColor],[UIColor whiteColor]];
        self.highTextColors = @[[UIColor whiteColor],[UIColor redColor]];
        self.backgroundColor = [UIColor clearColor];
        self.startTime = 0.0;
        self.duration = 0.0;
        self.textType = WZMCaptionModelTypeNormal;
        self.textAnimationType = WZMCaptionTextAnimationTypeSingle;
        self.noteImage = [UIImage wzm_getRoundImageByColor:[UIColor redColor] size:CGSizeMake(50, 50)];
        self.noteId = [NSString wzm_getTimeStampByDate:[NSDate date]];
        
    }
    return self;
}

#pragma mark - 按最大宽度计算
///最大宽度/字宽,即列数
- (NSInteger)textColumns {
    return (self.textMaxW/(self.textFontSize+5));
}

///出总共有几行
- (NSInteger)textRows {
    NSInteger textColumns = [self textColumns];
    return (self.text.length%textColumns == 0) ? (self.text.length/textColumns) : (self.text.length/textColumns + 1);
}

///字幕坐标
- (CGRect)textFrameWithTextColumns:(NSInteger *)textColumns {
    //计算出总共有几行
    NSInteger rows = [self textRows];
    //计算出字幕的frame
    CGFloat textW = self.text.length*(self.textFontSize+5);
    CGRect markFrame = CGRectZero;
    markFrame.origin = self.textPosition;
    markFrame.size.width = MIN(textW, self.textMaxW);
    markFrame.size.height = rows*(self.textFontSize+5)+(self.showNote ? 30 : 0);
    if (markFrame.size.height > self.textMaxH) {
        markFrame = [self textFrame2];
        if (textColumns) {
            *textColumns = [self textColumns2];
        }
    }
    else {
        if (textColumns) {
            *textColumns = [self textColumns];
        }
    }
    return markFrame;
}

#pragma mark - 按最大高度计算
///最大高度/字宽,即行数
- (NSInteger)textRows2 {
    CGFloat dy = self.showNote ? 30 : 0;
    return ((self.textMaxH-dy)/(self.textFontSize+5));
}

///列数
- (NSInteger)textColumns2 {
    NSInteger textRows = [self textRows2];
    return (self.text.length%textRows == 0) ? (self.text.length/textRows) : (self.text.length/textRows + 1);
}

- (CGRect)textFrame2 {
    //计算出总共有几行
    NSInteger columns = [self textColumns2];
    //计算出字幕的frame
    CGRect markFrame = CGRectZero;
    markFrame.origin = self.textPosition;
    markFrame.size.width = columns*(self.textFontSize+5);
    markFrame.size.height = self.textMaxH;
    return markFrame;
}

@end
