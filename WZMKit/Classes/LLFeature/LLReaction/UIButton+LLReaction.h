//
//  UIButton+LLReaction.h
//  LLCommonStatic
//
//  Created by WangZhaomeng on 2019/6/24.
//  Copyright © 2019 WangZhaomeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLReactionManager.h"

@interface UIButton (LLReaction)

///btn只添加一种点击事件
- (void)ll_executeEvent:(UIControlEvents)event action:(nextAction)action;

///btn添加多个点击事件, 在回调中判断事件类型
- (void)ll_executeEvent:(eventAction)action;

@end
