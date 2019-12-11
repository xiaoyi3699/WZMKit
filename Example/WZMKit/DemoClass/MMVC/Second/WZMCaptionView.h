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

@property (nonatomic, assign) CGSize maxSize;
@property (nonatomic, weak) id<WZMCaptionViewDelegate> delegate;

@end

@protocol WZMCaptionViewDelegate <NSObject>

@optional
- (void)captionViewBeginEdit:(WZMCaptionView *)captionView;
- (void)captionViewEndEdit:(WZMCaptionView *)captionView;
- (void)captionView:(WZMCaptionView *)captionView changeFrame:(CGRect)frame;
- (void)captionView:(WZMCaptionView *)captionView endChangeFrame:(CGRect)newFrame oldFrame:(CGRect)oldFrame;
- (void)captionView:(WZMCaptionView *)captionView changeTransform:(CATransform3D)transform;

@end

NS_ASSUME_NONNULL_END
