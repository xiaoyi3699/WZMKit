//
//  WZMVideoKeyView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMVideoKeyViewDelegate;

@interface WZMVideoKeyView : UIView

///音频地址
@property (nonatomic, strong) NSURL *videoUrl;
///0-1
@property (nonatomic, assign) CGFloat value;
///代理
@property (nonatomic, weak) id<WZMVideoKeyViewDelegate> delegate;

@end

@protocol WZMVideoKeyViewDelegate <NSObject>

@optional
- (void)videoKeyView:(WZMVideoKeyView *)videoKeyView didChangeValue:(CGFloat)value;

@end
