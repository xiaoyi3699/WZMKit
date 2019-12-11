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

@interface WZMCaptionView : UIView

///最小宽度 = 一个字的宽度
@property (nonatomic, assign) CGFloat minWidth;
@property (nonatomic, weak) id<WZMCaptionViewDelegate> delegate;

@end

@protocol WZMCaptionViewDelegate <NSObject>

@optional
- (void)captionViewWillShow:(WZMCaptionView *)captionView;
- (void)captionViewWillDismiss:(WZMCaptionView *)captionView;

- (void)captionView:(WZMCaptionView *)captionView changeFrame:(CGRect)frame;
- (void)captionView:(WZMCaptionView *)captionView endChangeFrame:(CGRect)newFrame oldFrame:(CGRect)oldFrame;
- (void)captionView:(WZMCaptionView *)captionView changeTransform:(CATransform3D)transform;

@end

NS_ASSUME_NONNULL_END
