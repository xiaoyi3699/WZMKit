//
//  ZMCaptionInputView.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/12.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMBaseInputView.h"
@protocol ZMCaptionInputViewDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface ZMCaptionInputView : WZMBaseInputView

@property (nonatomic, weak) id<ZMCaptionInputViewDelegate> delegate;

@end

@protocol ZMCaptionInputViewDelegate <NSObject>

@optional

@end

NS_ASSUME_NONNULL_END
