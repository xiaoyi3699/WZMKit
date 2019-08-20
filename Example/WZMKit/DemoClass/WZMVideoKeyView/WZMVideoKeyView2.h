//
//  WZMVideoKeyView2.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMVideoKeyView2Delegate;

@interface WZMVideoKeyView2 : UIView

///音频地址
@property (nonatomic, strong) NSURL *videoUrl;
///0-1
@property (nonatomic, assign) CGFloat value;
///代理
@property (nonatomic, weak) id<WZMVideoKeyView2Delegate> delegate;

@end

@protocol WZMVideoKeyView2Delegate <NSObject>

@optional
- (void)videoKeyView2:(WZMVideoKeyView2 *)videoKeyView2 didChangeValue:(CGFloat)value;

@end
