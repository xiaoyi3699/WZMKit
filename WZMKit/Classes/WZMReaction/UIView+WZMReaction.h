//
//  UIView+WZMReaction.h
//  WZMCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZMReactionManager.h"

@interface UIView (WZMReaction)

///view只添加一种手势
- (void)wzm_executeGesture: (WZMGestureRecognizerType)type action:(nextAction)action;

///view添加多种手势, 在回调中判断手势类型
- (void)wzm_executeGesture:(gestureAction)action;

@end
