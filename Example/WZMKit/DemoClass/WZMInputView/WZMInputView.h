//
//  WZMInputView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/7/19.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WZMInputViewDelegate;

@interface WZMInputView : UIView

@property (nonatomic, assign) CGFloat startY;

@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) NSMutableArray *keyboards;

@property (nonatomic, weak) id<WZMInputViewDelegate> delegate;

- (void)createViews;

@end

@protocol WZMInputViewDelegate <NSObject>

@optional
///输入框frame改变
- (void)inputView:(WZMInputView *)inputView willChangeFrameWithDuration:(CGFloat)duration isEditing:(BOOL)isEditing;

@end
