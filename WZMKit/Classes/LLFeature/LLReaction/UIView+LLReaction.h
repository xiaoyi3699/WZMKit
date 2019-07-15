//
//  UIView+LLReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLReactionManager.h"

@interface UIView (LLReaction)

///view只添加一种手势
- (void)ll_executeGesture:(LLGestureRecognizerType)type action:(nextAction)action;

///view添加多种手势, 在回调中判断手势类型
- (void)ll_executeGesture:(gestureAction)action;

@end
