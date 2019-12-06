//
//  WZMNoteAnimation.h
//  WZMKit_Example
//
//  Created by Zhaomeng Wang on 2019/12/6.
//  Copyright © 2019 wangzhaomeng. All rights reserved.
//

#import "WZMNoteConfig.h"

@interface WZMNoteAnimation : NSObject

@property (nonatomic, strong) WZMNoteConfig *config;

- (instancetype)initWithFrame:(CGRect)frame config:(WZMNoteConfig *)config;

- (UIView *)startNoteAnimationInView:(UIView *)superview;

@end
