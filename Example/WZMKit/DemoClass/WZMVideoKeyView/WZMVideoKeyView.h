//
//  WZMVideoKeyView.h
//  WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/20.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WZMVideoKeyView : UIView

@property (nonatomic, strong) NSURL *videoUrl;
///0-1
@property (nonatomic, assign) CGFloat value;

@end

NS_ASSUME_NONNULL_END
