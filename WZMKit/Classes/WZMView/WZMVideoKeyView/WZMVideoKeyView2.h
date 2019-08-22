//
//  WZMVideoKeyView2.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMEnum.h"
@protocol WZMVideoKeyView2Delegate;

@interface WZMVideoKeyView2 : UIView

///音频地址
@property (nonatomic, strong) NSURL *videoUrl;
///0-1
@property (nonatomic, assign) CGFloat value;
///圆角
@property (nonatomic, assign) CGFloat radius;
///内容宽度, 默认等于视图宽度
@property (nonatomic, assign) CGFloat contentWidth;
///代理
@property (nonatomic, weak) id<WZMVideoKeyView2Delegate> delegate;

@end

@protocol WZMVideoKeyView2Delegate <NSObject>

@optional
- (void)videoKeyView2:(WZMVideoKeyView2 *)videoKeyView2 changeType:(WZMCommonState)type;

@end
