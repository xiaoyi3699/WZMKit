//
//  WZMCaptionView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/11.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//  字幕编辑View

#import <UIKit/UIKit.h>
@protocol WZMCaptionViewDelegate;

NS_ASSUME_NONNULL_BEGIN

#define CAP_MENU_WIDTH 10.0
@interface WZMCaptionView : UIView

///最小宽度 = 一个字的宽度
@property (nonatomic, assign) CGFloat minWidth;
///索引值
@property (nonatomic, assign) NSInteger index;
///代理
@property (nonatomic, weak) id<WZMCaptionViewDelegate> delegate;

- (void)captionViewShow:(BOOL)show;

@end

@protocol WZMCaptionViewDelegate <NSObject>

@optional
//显示/隐藏
- (void)captionViewShow:(WZMCaptionView *)captionView;
- (void)captionViewDismiss:(WZMCaptionView *)captionView;
//编辑文字
- (void)captionViewBeginEditing:(WZMCaptionView *)captionView;
//改变位置
- (void)captionView:(WZMCaptionView *)captionView changeFrame:(CGRect)frame;
- (void)captionView:(WZMCaptionView *)captionView endChangeFrame:(CGRect)newFrame oldFrame:(CGRect)oldFrame;
//旋转
- (void)captionView:(WZMCaptionView *)captionView changeTransform:(CATransform3D)transform;

@end

NS_ASSUME_NONNULL_END
