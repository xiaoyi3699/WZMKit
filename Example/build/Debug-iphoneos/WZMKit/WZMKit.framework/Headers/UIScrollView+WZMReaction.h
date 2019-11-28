//
//  UIScrollView+WZMReaction.h
//  Pods-WZMKit_Example
//
//  Created by WangZhaomeng on 2019/8/30.
//

#import <UIKit/UIKit.h>
#import "WZMReactionManager.h"

@interface UIScrollView (WZMReaction)

///滑动事件
- (void)wzm_executeScroll:(scrollAction)action;

@end
