//
//  WZMDefaultInputBtn.m
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import "WZMDefaultInputBtn.h"

@interface WZMDefaultInputBtn ()

@property (nonatomic, assign) WZMDefaultInputBtnType type;

@end

@implementation WZMDefaultInputBtn

+ (instancetype)chatButtonWithType:(WZMDefaultInputBtnType)type{
    WZMDefaultInputBtn *baseBtn = [super buttonWithType:UIButtonTypeCustom];
    if (baseBtn) {
        baseBtn.type = type;
    }
    return baseBtn;
}

//重设image的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    if (self.currentImage) {
        if (_type == WZMDefaultInputBtnTypeRetry) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(12.5, 12.5, 15, 15);
        }
        if (_type == WZMDefaultInputBtnTypeTool) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(5, 5, 30, 30);
        }
        if (_type == WZMDefaultInputBtnTypeMoreKeyboard) {
            //实际应用中要根据情况，返回所需的frame
            return CGRectMake(10, 15, 40, 40);
        }
    }
    return [super imageRectForContentRect:contentRect];
}

//重设title的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (_type == WZMDefaultInputBtnTypeMoreKeyboard) {
        //实际应用中要根据情况，返回所需的frame
        return CGRectMake(0, 55, 60, 25);
    }
    return [super titleRectForContentRect:contentRect];
}

@end
