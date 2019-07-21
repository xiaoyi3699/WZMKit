//
//  WZMDefaultInputBtn.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WZMDefaultInputBtnTypeNormal = 0,   //系统默认类型
    WZMDefaultInputBtnTypeRetry,        //重发消息按钮
    WZMDefaultInputBtnTypeTool,         //键盘工具按钮
    WZMDefaultInputBtnTypeMoreKeyboard, //加号键盘按钮
}WZMDefaultInputBtnType;

@interface WZMDefaultInputBtn : UIButton

+ (instancetype)chatButtonWithType:(WZMDefaultInputBtnType)type;

@end
