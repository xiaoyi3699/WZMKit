//
//  ZMCaptionInputToolView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZMCaptionInputToolViewDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSInteger {
    ZMCaptionInputToolViewTypeSystem = 0, //系统键盘
    ZMCaptionInputToolViewTypeColor,      //颜色
    ZMCaptionInputToolViewTypeStyle,      //样式
    ZMCaptionInputToolViewTypeFont,       //字体
    ZMCaptionInputToolViewTypeOK,         //确定
} ZMCaptionInputToolViewType;

@interface ZMCaptionInputToolView : UIView

@property (nonatomic, weak) id<ZMCaptionInputToolViewDelegate> delegate;

@end

@protocol ZMCaptionInputToolViewDelegate <NSObject>

@optional
- (void)captionInputToolView:(ZMCaptionInputToolView *)captionInputToolView didSelectedWithType:(ZMCaptionInputToolViewType)type;

@end

NS_ASSUME_NONNULL_END
