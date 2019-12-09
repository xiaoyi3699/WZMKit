//
//  WZMNoteModel.m
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMNoteModel.h"

@implementation WZMNoteModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.angle = 0.0;
        self.showNote = YES;
        self.textMaxW = 200.0;
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
        self.textType = WZMNoteModelTypeNormal;
        self.textAnimationType = WZMNoteTextAnimationTypeSingle;
        self.noteImage = [UIImage wzm_getRoundImageByColor:[UIColor redColor] size:CGSizeMake(50, 50)];
    }
    return self;
}

///最大宽度每行字数的最大值,即列数
- (NSInteger)textColumns {
    return (self.textMaxW/(self.textFontSize+5));
}

///出总共有几行
- (NSInteger)textRows {
    NSInteger textColumns = [self textColumns];
    return (self.text.length%textColumns == 0) ? (self.text.length/textColumns) : (self.text.length/textColumns + 1);
}

///字幕坐标
- (CGRect)textFrame {
    //计算出总共有几行
    NSInteger rows = [self textRows];
    //计算出字幕的frame
    CGFloat textW = self.text.length*(self.textFontSize+5);
    CGRect markFrame = CGRectZero;
    markFrame.origin = self.textPosition;
    markFrame.size.width = MIN(textW, self.textMaxW);
    markFrame.size.height = rows*(self.textFontSize+5)+(self.showNote ? 30 : 0);
    return markFrame;
}

@end
