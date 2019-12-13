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
    ZMCaptionInputToolViewTypeOK     = -2, //确定
    ZMCaptionInputToolViewTypeSystem = -1, //系统键盘
    ZMCaptionInputToolViewTypeColor  = 0,  //颜色
    ZMCaptionInputToolViewTypeStyle  = 1,  //样式
    ZMCaptionInputToolViewTypeFont   = 2,  //字体
    
} ZMCaptionInputToolViewType;

@interface ZMCaptionInputToolView : UIView

@property (nonatomic, weak) id<ZMCaptionInputToolViewDelegate> delegate;

- (void)restoreStatus;

@end

@protocol ZMCaptionInputToolViewDelegate <NSObject>

@optional
- (void)captionInputToolView:(ZMCaptionInputToolView *)captionInputToolView didSelectedWithType:(ZMCaptionInputToolViewType)type;

@end

NS_ASSUME_NONNULL_END
