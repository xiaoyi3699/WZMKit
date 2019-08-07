//
//  WZMClipView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/7.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMClipViewDelegate;

@interface WZMClipView : UIView

///取值0~1, 默认值0
@property (nonatomic, assign) CGFloat startValue;
///取值0~1, 默认值1
@property (nonatomic, assign) CGFloat endValue;
///代理
@property (nonatomic, weak) id<WZMClipViewDelegate> delegate;

@end

@protocol WZMClipViewDelegate <NSObject>

@optional
- (void)clipView:(WZMClipView *)clipView didChangeValueEnd:(BOOL)end;

@end
