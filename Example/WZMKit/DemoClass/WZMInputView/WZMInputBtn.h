//
//  WZMInputBtn.h
//  WZMChat
//
//  Created by WangZhaomeng on 2018/9/4.
//  Copyright © 2018年 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WZMInputBtnTypeNormal = 0,   //系统默认类型
    WZMInputBtnTypeRetry,        //重发消息按钮
    WZMInputBtnTypeTool,         //键盘工具按钮
    WZMInputBtnTypeMoreKeyboard, //加号键盘按钮
}WZMInputBtnType;

@interface WZMInputBtn : UIButton

+ (instancetype)chatButtonWithType:(WZMInputBtnType)type;

@end
